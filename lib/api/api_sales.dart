import 'package:live_manage_dinesoft/system_all_library.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

//API sales data

Future<Map<String, dynamic>> fetchSalesData(
    DateTime date, String accessToken, String shopToken) async {
  final formattedDate =
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  final url = Uri.parse(
      "https://ewapi.azurewebsites.net/api/shop/orders?date=$formattedDate");
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final http.Response response = await http.get(
    url,
    headers: ({
      'access_token': accessToken,
      'shop_token': shopToken,
    }),
  );
  if (response.statusCode == 200) {
    final List<dynamic> json = jsonDecode(response.body);
    double totalSalesAmount = 0.0;
    double totalSubSalesAmount = 0.0;

    for (var item in json) {
      if (item is Map<String, dynamic> && item.containsKey('txSalesDetails')) {
        print('txSalesDetails: ${item['txSalesDetails']}');
        // Iterate through txSalesDetails and sum up the amount
        totalSalesAmount += calculateTotalSalesAmount(item['txSalesDetails']);
        totalSubSalesAmount +=
            calculateSubTotalSalesAmount(item['txSalesDetails']);
      }
    }

    // Return a map with both the raw response, total sales amount, and totalSubSalesAmount
    return {
      'rawData': json,
      'totalSalesAmount': totalSalesAmount,
      'totalSubSalesAmount': totalSubSalesAmount,
    };
  } else {
    throw Exception('Failed to fetch sales');
  }
}

//API report data

Future<List<Map<String, dynamic>>> fetchReportData(
    DateTime date, String accessToken, String shopToken) async {
  final formattedDate =
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  final url = Uri.parse(
      "https://ewapi.azurewebsites.net/api/shop/orders?date=$formattedDate");

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final http.Response response = await http.get(
    url,
    headers: {
      'access_token': accessToken,
      'shop_token': shopToken,
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
