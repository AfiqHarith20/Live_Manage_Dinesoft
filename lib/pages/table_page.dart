import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:live_manage_dinesoft/system_all_library.dart';

class TablePage extends StatefulWidget {
  final String accessToken;
  final String shopToken;
  final DateTime selectedDate;

  const TablePage({
    super.key,
    required this.accessToken,
    required this.shopToken,
    required this.selectedDate,
  });

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  late Future<List<Map<String, dynamic>>> tableDataFuture;
  late DateTime selectedDate;

  void updateDate(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate; // Initialize selectedDate here
    // Initialize tableDataFuture in initState with the selected date
    tableDataFuture = fetchData(selectedDate);
  }

  Future<List<Map<String, dynamic>>> fetchData(DateTime selectedDate) async {
    final formattedDate =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    final url = Uri.parse(
        "https://ewapi.azurewebsites.net/api/shop/orders?date=$formattedDate");

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.get(
      url,
      headers: {
        'access_token': widget.accessToken,
        'shop_token': widget.shopToken,
      },
    );

    if (response.statusCode == 200) {
      final dynamic responseBody = jsonDecode(response.body);
      if (responseBody == null) {
        throw Exception('Response body is null');
      }
      final List<dynamic> jsonData = responseBody as List<dynamic>;
      print('API Response: $jsonData');
      return extractSummaryData(jsonData);
    } else {
      throw Exception('Failed to fetch sales');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.tableReportPageTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Wrap the Column with SingleChildScrollView
        child: Column(
          children: [
            Text(
              '${AppLocalizations.of(context)!.date}: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 8,
              color: Colors.grey.shade200,
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: tableDataFuture,
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
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.noTableAvailable),
                  );
                } else {
                  return Column(
                    children: [
                      ...snapshot.data!.map((data) {
                        final tableCode = data['tableCode'];
                        final tableRemark = data['tableRemark'];
                        final date = DateTime.parse(data['checkinDatetime']);
                        final amountTotal = data['amountTotal'];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              ListTile(
                                leading:
                                    const Icon(Icons.table_restaurant_outlined),
                                title: Text(
                                    '${AppLocalizations.of(context)!.table} $tableCode'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (tableRemark != null &&
                                        tableRemark.isNotEmpty)
                                      Text(
                                        tableRemark,
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    Text(
                                      DateFormat.jm().format(date),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Consumer<CurrencyProvider>(
                                  builder: (context, currencyProvider, _) {
                                    return Text(
                                      '${AppLocalizations.of(context)?.total}: ${currencyProvider.selectedCurrency}${amountTotal.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors
                                            .black, // Use a slightly darker color for amounts
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const Divider(),
                            ],
                          ),
                        );
                      }),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedDate =
                                DateTime.parse(selectedDate.toString())
                                    .subtract(
                              const Duration(days: 1),
                            );
                            tableDataFuture = fetchData(selectedDate);
                          });
                        },
                        child: Text(
                          '${AppLocalizations.of(context)?.previousDay}',
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> extractSummaryData(List<dynamic> jsonData) {
    // Implement your logic to extract summary data from the API response
    // This function should return a list of map containing the required data
    // Example:
    return jsonData.map((item) {
      final tableCode = item['tableCode'] ?? '';
      final tableRemark = item['tableRemark'] ?? '';
      final checkinDatetime = item['checkinDatetime'] ?? '';
      final amountTotal = item['amountTotal'] ?? '';

      return {
        'tableCode': tableCode,
        'tableRemark': tableRemark,
        'checkinDatetime': checkinDatetime,
        'amountTotal': amountTotal,
      };
    }).toList();
  }
}
