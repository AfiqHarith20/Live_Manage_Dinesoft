// ignore_for_file: must_be_immutable

import 'package:live_manage_dinesoft/system_all_library.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

class ReportSales extends StatefulWidget {
  DateTime selectedDate;

  ReportSales({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<ReportSales> createState() => ReportSalesState();
}

Future<List<Map<String, dynamic>>> fetchReportData(DateTime date) async {
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
    print('API Response: $json');
    // Extract and return the required data directly
    return extractSummaryData(json);
  } else {
    throw Exception('Failed to fetch sales');
  }
}

DateTime parseApiDateTime(String apiDateTime) {
  print('Attempting to parse date string: $apiDateTime');
  try {
    // Extract the date and time string from the response
    String dateTimeString = apiDateTime.split(' ')[1];

    // Parse the date and time string
    DateTime parsedDateTime = DateTime.parse(dateTimeString);

    // Convert the parsedDateTime to local time (if needed)
    // parsedDateTime = parsedDateTime.toLocal();

    return parsedDateTime;
  } catch (e) {
    print('Error parsing date. Date string: $apiDateTime, Error: $e');
    return DateTime.now(); // Use current date as a fallback
  }
}

List<Map<String, dynamic>> extractSummaryData(List<dynamic> json) {
  // Use json directly
  List<Map<String, dynamic>> summaryList = [];
  for (var item in json) {
    if (item is Map<String, dynamic>) {
      String workdayPeriodName = item['startWorkdayPeriodName'] ?? 'Unknown';

      // Add other properties as needed
      String txSalesHeaderId = item['txSalesHeaderId'].toString();
      List<Map<String, dynamic>> txSalesDetails = item['txSalesDetails'] != null
          ? extractTxSalesDetails(item['txSalesDetails'])
          : [];

      summaryList.add({
        'workdayPeriodName': workdayPeriodName,
        'txSalesHeaderId': txSalesHeaderId,
        'txSalesDetails': txSalesDetails,
      });
    }
  }
  return summaryList;
}

List<Map<String, dynamic>> extractTxSalesDetails(List<dynamic> txSalesDetails) {
  List<Map<String, dynamic>> detailsList = [];
  for (var salesDetail in txSalesDetails) {
    if (salesDetail is Map<String, dynamic>) {
      String txSalesDetailId = salesDetail['txSalesDetailId'].toString();
      String categoryName = salesDetail['categoryName'] ?? 'Unknown';
      String itemName = salesDetail['itemName'] ?? 'Unknown';
      int quantity = (salesDetail['qty'] ?? 0).toInt();
      double price = salesDetail['price'] ?? 0.0;

      detailsList.add({
        'txSalesDetailId': txSalesDetailId,
        'categoryName': categoryName,
        'itemName': itemName,
        'quantity': quantity,
        'price': price,
      });
    }
  }
  return detailsList;
}

class ReportSalesState extends State<ReportSales> {
  final GlobalKey<ReportSalesState> keyReportSales = GlobalKey();

  void updateDate(DateTime newDate) {
    setState(() {
      widget.selectedDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30.0),
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

                    if (pickedDate != null &&
                        pickedDate != widget.selectedDate) {
                      setState(() {
                        widget.selectedDate = pickedDate;
                      });
                    }
                  },
                  child: const Text('Change Date'),
                ),
              ],
            ),
            FutureBuilder(
              future: fetchReportData(widget.selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  print('Snapshot: $snapshot');
                  return const Text('No data available');
                } else {
                  // Access rawData directly
                  List<Map<String, dynamic>>? summaryList = snapshot.data;
                  // Display the data in a ListView
                  return Column(
                    children: [
                      for (var order in summaryList!)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Workday Period: ${order['workdayPeriodName']}',
                                style: AppTextStyle.textmedium,
                              ),
                            ),
                            for (var detail in order['txSalesDetails'])
                              Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: Text(
                                    detail['itemName'].toString(),
                                    style: AppTextStyle.textmedium,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Category: ${detail['categoryName']}',
                                        style: AppTextStyle.textsmall,
                                      ),
                                      Text(
                                        'Quantity: ${detail['quantity']}',
                                        style: AppTextStyle.textsmall,
                                      ),
                                      Text(
                                        'Price: RM${detail['price'].toStringAsFixed(2)}',
                                        style: AppTextStyle.textsmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
