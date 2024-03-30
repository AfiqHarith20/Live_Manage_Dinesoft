import 'package:intl/intl.dart';
import 'package:live_manage_dinesoft/system_all_library.dart';

class ReportSales extends StatefulWidget {
  final DateTime selectedDate;
  final String accessToken;
  final String shopToken;

  const ReportSales({
    super.key,
    required this.selectedDate,
    required this.accessToken,
    required this.shopToken,
  });

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
  late String username;
  late String password;
  // late StatefulNavigationShell navigationShell;
  late Function(String, String, String) onShopSelected;
  late DateTime selectedDate;
  late Map<String, Map<String, dynamic>> salesByCategory;
  bool sortDescending = true;
  late double totalPrice = 0;
  bool isLoading = false;
  String? errorMessage;

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
    fetchDataOnPageLoad();
  }

  Future<void> fetchDataOnPageLoad() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Fetch sales data for the selected date
      Map<String, dynamic> salesData = await fetchSalesData(
        selectedDate,
        widget.accessToken,
        widget.shopToken,
      );

      // Extract summary data from sales data
      List<Map<String, dynamic>> summaryList =
          extractSummaryData(salesData['rawData']);

      // Clear the previous data before populating with new data
      setState(() {
        salesByCategory.clear();
      });

      // Populate salesByCategory map with new data
      for (var order in summaryList) {
        for (var detail in order['txSalesDetails']) {
          String category = detail['categoryName'];
          if (!salesByCategory.containsKey(category)) {
            salesByCategory[category] = {};
          }
          String itemName = detail['itemName'];
          int quantity = (detail['quantity'] ?? 0).toInt();
          double price = detail['price'] ?? 0.0;

          // Exclude items with quantity 0
          if (quantity > 0) {
            if (!salesByCategory[category]!.containsKey(itemName)) {
              salesByCategory[category]![itemName] = {
                'quantity': quantity,
                'price': price,
              };
            } else {
              salesByCategory[category]![itemName]['quantity'] += quantity;
              salesByCategory[category]![itemName]['price'] += price;
            }
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

      // Recalculate total price
      calculateTotalPrice();
    } catch (e) {
      // Handle errors
      print('Error fetching data on page load: $e');
      setState(() {
        errorMessage = 'Error fetching data. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      // Manually trigger the loading state
    });
    try {
      // Fetch new data here
      await fetchReportData(
        widget.selectedDate,
        widget.accessToken,
        widget.shopToken,
      );

      // Recalculate total price
      calculateTotalPrice();
    } catch (e) {
      // Handle errors
      print('Error fetching data: $e');
    }
  }

  // Method to calculate total price
  void calculateTotalPrice() {
    double sum = 0;
    salesByCategory.values.forEach((value) {
      value.forEach((itemName, itemData) {
        sum += itemData['price']; // Add price of each item
      });
    });
    setState(() {
      totalPrice = sum;
    });
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

  // Method to show date picker and update selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      // Fetch data for the newly selected date
      fetchDataOnPageLoad();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencyProvider>(builder: (context, currencyProvider, _) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: darkColorScheme.primary,
          title: Text(
            AppLocalizations.of(context)?.salesReportPageTitle ??
                'Sales Report',
            style: AppTextStyle.titleMedium,
          ),
          actions: <Widget>[
            // Add IconButton to trigger date picker
            // IconButton(
            //   icon: const Icon(Icons.calendar_today), // Calendar icon
            //   onPressed: () {
            //     _selectDate(context); // Call _selectDate method
            //   },
            // ),
            Ink(
              decoration: const ShapeDecoration(
                color: Colors.transparent,
                shape: CircleBorder(),
              ),
              child: IconButton(
                splashColor: Colors.blueAccent,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.date}: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),
                  FutureBuilder(
                    future: fetchReportData(
                      widget.selectedDate,
                      widget.accessToken,
                      widget.shopToken,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SizedBox(
                            height: 20.h, // Set the desired height here
                            child: const LoadingIndicator(
                              indicatorType: Indicator.ballClipRotateMultiple,
                              colors: [Colors.orangeAccent],
                              strokeWidth: 3,
                              backgroundColor: Colors.transparent,
                              pathBackgroundColor: Colors.transparent,
                            ),
                          ),
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
                            AppLocalizations.of(context)?.noSalesAvailable ??
                                "No Sales Available",
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
                            if (!salesByCategory[category]!
                                .containsKey(itemName)) {
                              salesByCategory[category]![itemName] = {
                                'quantity': detail['quantity'],
                                'price': detail['price'],
                              };
                            } else {
                              salesByCategory[category]![itemName]
                                  ['quantity'] += detail['quantity'];
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
                            double categoryTotalPrice = 0;
                            num categoryTotalQuantity = 0;
                            // Calculate total price and total quantity for the category
                            salesByCategory[category]!.forEach((item, value) {
                              categoryTotalPrice += value['price'];
                              categoryTotalQuantity += value['quantity'];
                            });
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              elevation: 3,
                              child: ExpansionTile(
                                title: ListTile(
                                  title: Text(
                                    category,
                                    style: AppTextStyle.textmedium
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Text(
                                        '${AppLocalizations.of(context)!.totalQty}: $categoryTotalQuantity',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(
                                            '${AppLocalizations.of(context)?.totalPrice}: ',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          Text(
                                            '${currencyProvider.selectedCurrency}${categoryTotalPrice.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                children:
                                    salesByCategory[category]!.entries.map(
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
                                              '${AppLocalizations.of(context)?.qty ?? "Quantity"}: ${entry.value['quantity']}',
                                              style: AppTextStyle.textsmall,
                                            ),
                                            Consumer<CurrencyProvider>(
                                              builder: (context,
                                                  currencyProvider, _) {
                                                return Text(
                                                  '${AppLocalizations.of(context)?.price}: ${currencyProvider.selectedCurrency}${entry.value['price'].toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors
                                                        .black, // Use a slightly darker color for amounts
                                                  ),
                                                );
                                              },
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
                  SizedBox(height: 3.h),
                  const Divider(), // Add a section separator
                  SizedBox(height: 3.h),
                  Consumer<CurrencyProvider>(
                    builder: (context, currencyProvider, _) {
                      return Text(
                        '${AppLocalizations.of(context)?.totalPrice}: ${currencyProvider.selectedCurrency}${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors
                              .black, // Use a slightly darker color for amounts
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
