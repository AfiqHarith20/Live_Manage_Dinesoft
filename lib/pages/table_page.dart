import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:live_manage_dinesoft/system_all_library.dart';

class TablePage extends StatefulWidget {
  final String accessToken;
  final String shopToken;

  const TablePage({
    Key? key,
    required this.accessToken,
    required this.shopToken,
  }) : super(key: key);

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  late Future<List<Map<String, dynamic>>> tableDataFuture;

  @override
  void initState() {
    super.initState();
    // Initialize tableDataFuture in initState
    tableDataFuture = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final DateTime date = DateTime.now();
    final formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
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
        title: const Text('Table Page'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: tableDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final data = snapshot.data![index];
                final tableCode = data['tableCode'];
                final tableRemark = data['tableRemark'];
                final date = DateTime.parse(data['checkinDatetime']);
                final amountTotal = data['amountTotal'];

                return ListTile(
                  leading: const FaIcon(FontAwesomeIcons.table),
                  title: Text('Table $tableCode'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (tableRemark != null && tableRemark.isNotEmpty)
                        Text(tableRemark),
                      Text(
                        DateFormat.yMd().add_jm().format(date),
                      ),
                    ],
                  ),
                  trailing: Text('Total: RM ${amountTotal ?? ''}'),
                );
              },
            );
          }
        },
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
