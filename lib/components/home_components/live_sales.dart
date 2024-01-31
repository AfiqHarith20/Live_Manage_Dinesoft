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
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.accessToken,
    required this.shopToken,
  }) : super(key: key);

  @override
  State<LiveSales> createState() => LiveSalesState();
}

double calculateSubTotalSalesAmount(List<dynamic> salesDetails) {
  double totalSubAmount = 0.0;
  for (var salesDetail in salesDetails) {
    if (salesDetail is Map<String, dynamic> &&
        salesDetail.containsKey('amount')) {
      totalSubAmount += (salesDetail['amount'] ?? 0.0);
    }
  }
  return totalSubAmount;
}

double calculateTotalSalesAmount(List<dynamic> salesDetails) {
  double totalAmount = 0.0;
  for (var salesDetail in salesDetails) {
    if (salesDetail is Map<String, dynamic> &&
        salesDetail.containsKey('amount')) {
      totalAmount += (salesDetail['amount'] ?? 0.0);
    }
  }
  return totalAmount;
}

int calculateSalesCountForDay(List<dynamic> salesDetails, DateTime targetDate) {
  // Filter salesDetails based on the target date
  List<dynamic> salesForTargetDate = salesDetails
      .where((salesDetail) =>
          salesDetail is Map<String, dynamic> &&
          salesDetail.containsKey('txDate') &&
          DateTime.parse(salesDetail['txDate']).isAtSameMomentAs(targetDate))
      .toList();

  // Create a set to store unique txSalesHeaderId values
  Set<int> uniqueTxSalesHeaderIds = {};

  // Iterate through salesForTargetDate and add txSalesHeaderId values to the set
  for (var salesDetail in salesForTargetDate) {
    if (salesDetail is Map<String, dynamic> &&
        salesDetail.containsKey('txSalesHeaderId')) {
      uniqueTxSalesHeaderIds.add(salesDetail['txSalesHeaderId']
          as int); // Assuming txSalesHeaderId is of type int
    }
  }

  // Return the count of unique txSalesHeaderId values
  return uniqueTxSalesHeaderIds.length;
}

class LiveSalesState extends State<LiveSales> {
  late Future<dynamic> futureSalesData;
  late Future<dynamic> futureNetSalesData;
  late Timer _timer;
  double totalAmount = 0.0;
  double subTotalAmount = 0.0;
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
    return totalAmount;
  }

  double calculateNetSalesAmount(List<dynamic> salesDetails) {
    double totalAmount = 0.0;
    for (var salesDetail in salesDetails) {
      if (salesDetail is Map<String, dynamic> &&
          salesDetail.containsKey('amountTotal')) {
        totalAmount += (salesDetail['amountTotal'] ?? 0.0);
      }
    }
    return totalAmount;
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
                  title: AppLocalizations.of(context)!.count,
                  future: futureSalesData,
                  color: Colors.orange,
                  dataSelector: (data) => calculateSalesCountForDay(
                    data['rawData'],
                    widget.selectedDate,
                  ),
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
                        '${value.toString()}',
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