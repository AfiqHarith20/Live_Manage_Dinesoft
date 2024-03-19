// ignore_for_file: must_be_immutable, unnecessary_string_interpolations

import 'package:live_manage_dinesoft/system_all_library.dart';

import 'dart:async';

class LiveSales extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final String accessToken;
  final String shopToken;

  LiveSales({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.accessToken,
    required this.shopToken,
  }) : super(key: key);

  @override
  State<LiveSales> createState() => LiveSalesState();
}

class LiveSalesState extends State<LiveSales> {
  late Future<dynamic> futureSalesData;
  late Future<dynamic> futureNetSalesData;
  late Timer _timer;
  double totalAmount = 0.0;
  double subTotalAmount = 0.0;
  int orderCount = 0;
  bool isFetchingData = false;
  bool isCalculatingTotal = false;
  bool isCalculatingSubTotal = false;

  @override
  void initState() {
    super.initState();
    fetchDataAndUpdateState();
    updateTotalAmount();

    _timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      if (mounted) {
        setState(() {
          fetchDataAndUpdateState();
        });
      }
    });
  }

  void updateDate(DateTime newDate) {
    setState(() {
      widget.selectedDate = newDate;
      fetchDataAndUpdateState();
    });
  }

  @override
  void didUpdateWidget(covariant LiveSales oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      fetchDataAndUpdateState();
      updateTotalAmount();
    }
  }

  void fetchDataAndUpdateState() {
    futureSalesData = fetchSalesData(
        widget.selectedDate, widget.accessToken, widget.shopToken);
    futureNetSalesData = fetchSalesData(
        widget.selectedDate, widget.accessToken, widget.shopToken);
  }

  void updateDate(DateTime newDate) {
    setState(() {
      fetchDataAndUpdateState();
    });
  }

  // Function to update the total amount based on new payments
  Future<void> updateTotalAmount() async {
    if (!mounted) return; // Exit the method if the widget is not mounted

    try {
      setState(() {
        isCalculatingTotal = true;
      });

      Map<String, dynamic> latestSalesData = await futureSalesData;
      Map<String, dynamic> latestNetSalesData = await futureNetSalesData;

      double newPaymentAmount =
          calculateTotalSalesAmount(latestSalesData['rawData']);
      double newNetPaymentAmount =
          calculateNetSalesAmount(latestNetSalesData['rawData']);

      orderCount = calculateOrderCount(latestSalesData['rawData']);

      setState(() {
        totalAmount += newPaymentAmount;
        subTotalAmount += newNetPaymentAmount;
        isFetchingData = false;
        isCalculatingTotal = false;
        isCalculatingSubTotal = false;
      });
    } catch (e) {
      print('Error updating total amount: $e');
      if (mounted) {
        setState(() {
          isFetchingData = false;
          isCalculatingTotal = false;
          isCalculatingSubTotal = false;
        });
      }
    }
  }

  // Function to calculate the total amount from sales data
  double calculateTotalSalesAmount(List<dynamic> salesDetails) {
    double totalAmount = 0.0;
    for (var salesDetail in salesDetails) {
      if (salesDetail is Map<String, dynamic> &&
          salesDetail.containsKey('amountTotal')) {
        totalAmount += (salesDetail['amountTotal'] ?? 0.0);
      }
    }
    // Format the total amount to display only two decimal places
    return double.parse(totalAmount.toStringAsFixed(2));
  }

  // Function to calculate the net sales amount from sales data
  double calculateNetSalesAmount(List<dynamic> salesDetails) {
    double totalAmount = 0.0;
    for (var salesDetail in salesDetails) {
      if (salesDetail is Map<String, dynamic> &&
          salesDetail.containsKey('amountSubtotal')) {
        totalAmount += (salesDetail['amountSubtotal'] ?? 0.0);
      }
    }
    // Format the net sales amount to display only two decimal places
    return double.parse(totalAmount.toStringAsFixed(2));
  }

  // Function to calculate the order count based on txSalesHeaderId
  int calculateOrderCount(List<dynamic> salesDetails) {
    Set<int> uniqueTxSalesHeaderIds = {};
    for (var salesDetail in salesDetails) {
      if (salesDetail is Map<String, dynamic> &&
          salesDetail.containsKey('txSalesHeaderId')) {
        uniqueTxSalesHeaderIds.add(salesDetail['txSalesHeaderId'] as int);
      }
    }
    return uniqueTxSalesHeaderIds.length;
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 238, 238, 236),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Consumer<CurrencyProvider>(
                  builder: (context, currencyProvider, _) => _buildSalesCard(
                    title:
                        '${AppLocalizations.of(context)?.netSales ?? 'Net Sales'}\n(${currencyProvider.selectedCurrency})',
                    future: futureNetSalesData,
                    color: Colors.greenAccent,
                    dataSelector: (data) =>
                        calculateNetSalesAmount(data['rawData']),
                  ),
                ),
                Consumer<CurrencyProvider>(
                  builder: (context, currencyProvider, _) => _buildSalesCard(
                    title:
                        '${AppLocalizations.of(context)?.grossSales ?? 'Gross Sales'}\n(${currencyProvider.selectedCurrency})',
                    future: futureSalesData,
                    color: Colors.blueAccent,
                    dataSelector: (data) =>
                        calculateTotalSalesAmount(data['rawData']),
                  ),
                ),
                _buildSalesCard(
                  title: AppLocalizations.of(context)?.count ??
                      'Count', // Uncommented for order count
                  future: futureSalesData,
                  color: Colors.orangeAccent,
                  dataSelector: (data) =>
                      orderCount.toDouble(), // Use order count as data selector
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesCard({
    required String title,
    required Future future,
    required Color color,
    required dynamic Function(dynamic) dataSelector,
  }) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: color,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              print('Snapshot: $snapshot'); // Debug statement

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    height: 20, // Adjust height as needed
                    width: 20, // Adjust width as needed
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              } else if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.noDataAvailable,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              } else {
                dynamic data = snapshot.data;
                dynamic value = dataSelector(data);

                print('Value: $value'); // Debug statement

                // Format the value with two decimal places to remove trailing zeroes
                final formattedValue = value != null
                    ? double.parse(
                        value.toStringAsFixed(2)) // Format to 2 decimal places
                    : 'N/A';

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$formattedValue',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
