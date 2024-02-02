import 'package:flutter/material.dart';
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
  late DateTime selectedDate;
  late Map<String, Map<String, dynamic>> salesByCategory;
  bool sortDescending = true; // Indicates whether to sort in descending order

  void updateDate(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
    salesByCategory = {};
  }

  Future<void> _refreshData() async {
    setState(() {
      // Manually trigger the loading state
    });
    // Fetch new data here
    await fetchReportData(
      widget.selectedDate,
      widget.accessToken,
      widget.shopToken,
    );
  }

  void _toggleSorting() {
    setState(() {
      // Toggle sorting order
      sortDescending = !sortDescending;

      // Sort categories by total price
      salesByCategory.forEach((key, value) {
        print('Category: $key, Items: ${value.length}');
        var sortedEntries = value.entries.toList()
          ..sort((a, b) {
            if (sortDescending) {
              return b.value['price'].compareTo(a.value['price']);
            } else {
              return a.value['price'].compareTo(b.value['price']);
            }
          });
        salesByCategory[key] = Map.fromEntries(sortedEntries);
      });

      // Print sorted categories
      print('Sorted Categories: $salesByCategory');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkColorScheme.primary,
        title: Text(
          AppLocalizations.of(context)!.salesReportPageTitle,
          style: AppTextStyle.titleMedium,
        ),
        actions: <Widget>[
          Ink(
            decoration: const ShapeDecoration(
              color: Colors.transparent,
              shape: CircleBorder(),
            ),
            child: IconButton(
              splashColor: Colors.blueAccent, // Set the splash color
              icon: FaIcon(
                sortDescending
                    ? FontAwesomeIcons.sortDown
                    : FontAwesomeIcons.sortUp,
              ),
              onPressed: _toggleSorting,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder(
              future: fetchReportData(
                widget.selectedDate,
                widget.accessToken,
                widget.shopToken,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  );
                } else if (!snapshot.hasData ||
                    (snapshot.data as List).isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.noSalesAvailable,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  );
                } else {
                  List<Map<String, dynamic>>? summaryList =
                      snapshot.data as List<Map<String, dynamic>>;
                  salesByCategory = {};
                  for (var order in summaryList) {
                    for (var detail in order['txSalesDetails']) {
                      String category = detail['categoryName'];
                      if (!salesByCategory.containsKey(category)) {
                        salesByCategory[category] = {};
                      }
                      String itemName = detail['itemName'];
                      if (!salesByCategory[category]!.containsKey(itemName)) {
                        salesByCategory[category]![itemName] = {
                          'quantity': detail['quantity'],
                          'price': detail['price'],
                        };
                      } else {
                        salesByCategory[category]![itemName]['quantity'] +=
                            detail['quantity'];
                        salesByCategory[category]![itemName]['price'] +=
                            detail['price'];
                      }
                    }
                  }

                  // Sort categories by total price in descending order
                  salesByCategory.forEach((key, value) {
                    var sortedEntries = value.entries.toList()
                      ..sort((a, b) => sortDescending
                          ? b.value['price'].compareTo(a.value['price'])
                          : a.value['price'].compareTo(b.value['price']));
                    salesByCategory[key] = Map.fromEntries(sortedEntries);
                  });

                  return Column(
                    children: salesByCategory.keys.map((category) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 3,
                        child: ExpansionTile(
                          title: Text(
                            category,
                            style: AppTextStyle.textmedium,
                          ),
                          children: salesByCategory[category]!.entries.map(
                            (entry) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${AppLocalizations.of(context)!.totalQty}: ${entry.value['quantity']}',
                                        style: AppTextStyle.textsmall,
                                      ),
                                      Text(
                                        '${AppLocalizations.of(context)!.totalPrice}: RM${entry.value['price'].toStringAsFixed(2)}',
                                        style: AppTextStyle.textsmall,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
