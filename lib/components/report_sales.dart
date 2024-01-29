// ignore_for_file: must_be_immutable

import 'package:live_manage_dinesoft/system_all_library.dart';

class ReportSales extends StatefulWidget {
  final DateTime selectedDate;
  final String accessToken;
  final String shopToken;

  const ReportSales({
    Key? key,
    required this.selectedDate,
    required this.accessToken,
    required this.shopToken,
  }) : super(key: key);

  @override
  State<ReportSales> createState() => ReportSalesState();
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
  late DateTime selectedDate; // Declare selectedDate variable

  void updateDate(DateTime newDate) {
    setState(() {
      selectedDate = newDate; // Update selectedDate
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.listSales,
          style: AppTextStyle.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            color: darkColorScheme.surface,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              //     Text(
              //       AppLocalizations.of(context)!.listSales,
              //       style: AppTextStyle.titleMedium,
              //     ),
              //   ],
              // ),
              FutureBuilder(
                future: fetchReportData(
                    widget.selectedDate, widget.accessToken, widget.shopToken),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    print('Snapshot: $snapshot');
                    return const Text(
                        'No data available. Please refresh or select a date.');
                  } else {
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
                                  '${AppLocalizations.of(context)!.workdayPeriod}: ${order['workdayPeriodName']}',
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
                                          '${AppLocalizations.of(context)!.category}: ${detail['categoryName']}',
                                          style: AppTextStyle.textsmall,
                                        ),
                                        Text(
                                          '${AppLocalizations.of(context)!.qty}: ${detail['quantity']}',
                                          style: AppTextStyle.textsmall,
                                        ),
                                        Text(
                                          '${AppLocalizations.of(context)!.price}: RM${detail['price'].toStringAsFixed(2)}',
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
      ),
    );
  }
}
