// ignore_for_file: must_be_immutable, unnecessary_string_interpolations

import 'package:intl/intl.dart';
import 'package:live_manage_dinesoft/system_all_library.dart';

import 'dart:async';

class LiveSales extends StatefulWidget {
  DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final String accessToken;
  final String shopToken;

  LiveSales({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.accessToken,
    required this.shopToken,
  });

  @override
  State<LiveSales> createState() => LiveSalesState();
}

class LiveSalesState extends State<LiveSales> {
  late Future<dynamic> futureSalesData;
  late Future<dynamic> futureNetSalesData;
  late Timer _timer;
  double totalAmount = 0.0;
  double subTotalAmount = 0.0;
  int orderCount = 0; // New variable to hold the order count
  bool isFetchingData = false;
  bool isCalculatingTotal = false;
  bool isCalculatingSubTotal = false;

  void updateDate(DateTime newDate) {
    setState(() {
      widget.selectedDate = newDate;
      fetchDataAndUpdateState();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDataAndUpdateState();

    // Perform initial loading when the widget is initialized
    updateTotalAmount();

    _timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      setState(() {
        fetchDataAndUpdateState();
      });
    });
  }

  void fetchDataAndUpdateState() {
    futureSalesData = fetchSalesData(
        widget.selectedDate, widget.accessToken, widget.shopToken);
    futureNetSalesData = fetchSalesData(
        widget.selectedDate, widget.accessToken, widget.shopToken);
  }

  // Function to update the total amount based on new payments
  Future<void> updateTotalAmount() async {
    try {
      // Set the flag to true before calculating total amount
      setState(() {
        isCalculatingTotal = true;
      });

      // Fetch the latest sales data
      Map<String, dynamic> latestSalesData = await futureSalesData;
      Map<String, dynamic> latestNetSalesData = await futureNetSalesData;

      // Print details for each txSalesDetailId and totalSales
      latestSalesData.forEach((txSalesDetailId, sale) {
        if (sale is Map<String, dynamic>) {
          final totalSales = sale['amountTotal'];
          print('TxSalesDetailId: $txSalesDetailId, TotalSales: $totalSales');
        }
      });

      latestNetSalesData.forEach((txSalesDetailId, net) {
        if (net is Map<String, dynamic>) {
          final totalNetSales = net['amountSubTotal'];
          print(
              'TxSalesDetailId: $txSalesDetailId, TotalSubSales: $totalNetSales');
        }
      });

      // Accumulate the new payment amounts
      double newPaymentAmount =
          calculateTotalSalesAmount(latestSalesData['rawData']);
      double newNetPaymentAmount =
          calculateNetSalesAmount(latestNetSalesData['rawData']);

      // Calculate order count
      orderCount = calculateOrderCount(latestSalesData['rawData']);

      // Update the total amount by adding the new payment amount
      setState(() {
        totalAmount += newPaymentAmount;
        subTotalAmount += newNetPaymentAmount;
        isFetchingData = false; // Reset the flag after data is fetched
        isCalculatingTotal =
            false; // Reset the flag after calculating total amount
        isCalculatingSubTotal = false;
      });
    } catch (e) {
      print('Error updating total amount: $e');
      setState(() {
        isFetchingData = false; // Reset the flag on error
        isCalculatingTotal = false; // Reset the flag on error
        isCalculatingSubTotal = false;
      });
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
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 206, 206, 202),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppLocalizations.of(context)!.date}: ${DateFormat('yyyy-MM-dd').format(widget.selectedDate)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildSalesCard(
                  title: '${AppLocalizations.of(context)!.grossSales}\n(RM)',
                  future: futureSalesData,
                  color: Colors.blue,
                  dataSelector: (data) => data['totalSalesAmount'],
                ),
                _buildSalesCard(
                  title: '${AppLocalizations.of(context)!.netSales}\n(RM)',
                  future: futureNetSalesData,
                  color: Colors.green,
                  dataSelector: (data) =>
                      calculateNetSalesAmount(data['rawData']),
                ),
                _buildSalesCard(
                  title: AppLocalizations.of(context)!
                      .count, // Uncommented for order count
                  future: futureSalesData,
                  color: Colors.orange,
                  dataSelector: (data) =>
                      orderCount, // Use order count as data selector
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
          borderRadius: BorderRadius.circular(14),
        ),
        color: color,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
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
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formattedValue
                            .toString(), // Ensure it's converted to a String
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
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
