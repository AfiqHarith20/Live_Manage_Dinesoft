import 'package:intl/intl.dart';
import 'package:live_manage_dinesoft/system_all_library.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class LiveSales extends StatefulWidget {
  DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  LiveSales({Key? key, required this.selectedDate, required this.onDateChanged})
      : super(key: key);

  @override
  State<LiveSales> createState() => LiveSalesState();
}

Future<Map<String, dynamic>> fetchSalesData(DateTime date) async {
  final formattedDate =
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  final url = Uri.parse(
      "https://ewapi.azurewebsites.net/api/shop/orders?date=$formattedDate");

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final http.Response response = await http.get(
    url,
    headers: {
      'access_token': '00a333f4-6b41-4151-afa4-3259b2aa0bd4',
      'shop_token': 'a746cb2f-2772-4016-a312-60a6ca8f4f7a'
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> json = jsonDecode(response.body);
    double totalSalesAmount = 0.0;
    double totalSubSalesAmount = 0.0;

    for (var item in json) {
      if (item is Map<String, dynamic> && item.containsKey('txSalesDetails')) {
        totalSalesAmount += calculateTotalSalesAmount(item['txSalesDetails']);
        totalSubSalesAmount +=
            calculateSubTotalSalesAmount(item['txSalesDetails']);
      }
    }

    return {
      'rawData': json,
      'totalSalesAmount': totalSalesAmount,
      'totalSubSalesAmount': totalSubSalesAmount,
    };
  } else {
    throw Exception('Failed to fetch sales');
  }
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
    futureSalesData = fetchSalesData(widget.selectedDate);
    futureNetSalesData = fetchSalesData(widget.selectedDate);
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
        color: darkColorScheme.surface,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date: ${DateFormat('yyyy-MM-dd').format(widget.selectedDate)}',
                style: AppTextStyle.textmedium,
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2025),
                  );

                  if (pickedDate != null && pickedDate != widget.selectedDate) {
                    setState(() {
                      widget.selectedDate = pickedDate;
                      fetchDataAndUpdateState();
                    });
                  }
                },
                child: const Text('Change Date'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: darkColorScheme.secondary,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: FutureBuilder(
                  future: futureSalesData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return const Text('No data available');
                    } else {
                      double totalSalesAmount =
                          snapshot.data!['totalSalesAmount'];
                      return Column(
                        children: [
                          Text(
                            'Gross Sales:',
                            style: AppTextStyle.textsmall,
                          ),
                          Text(
                            'RM${totalSalesAmount.toStringAsFixed(2)}',
                            style: AppTextStyle.textmedium,
                          )
                        ],
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: darkColorScheme.tertiary,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: FutureBuilder(
                  future: futureNetSalesData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return const Text('No data available');
                    } else {
                      print('Raw Data: ${snapshot.data!['rawData']}');
                      double totalNetSalesAmount =
                          calculateNetSalesAmount(snapshot.data!['rawData']);
                      return Column(
                        children: [
                          Text(
                            'Net Sales:',
                            style: AppTextStyle.textsmall,
                          ),
                          Text(
                            'RM${totalNetSalesAmount.toStringAsFixed(2)}',
                            style: AppTextStyle.textmedium,
                          )
                        ],
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: darkColorScheme.primary,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: FutureBuilder(
                  future: futureSalesData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return const Text('No data available');
                    } else {
                      int salesCount = calculateSalesCountForDay(
                          snapshot.data!['rawData'], widget.selectedDate);
                      return Column(
                        children: [
                          Text(
                            'Count:',
                            style: AppTextStyle.textsmall,
                          ),
                          Text(
                            '$salesCount',
                            style: AppTextStyle.textmedium,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
