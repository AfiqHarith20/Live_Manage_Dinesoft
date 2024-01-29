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

    // Print the txPayments section of the response
    if (json.isNotEmpty && json.first.containsKey('txPayments')) {
      print('txPayments section: ${json.first['txPayments']}');
    } else {
      print('No txPayments section found in the response.');
    }

    Map<String, dynamic> paymentMethodTotals = {};
    double totalSalesAmount = 0.0;
    double totalSubSalesAmount = 0.0;

    for (var item in json) {
      if (item is Map<String, dynamic> && item.containsKey('txPayments')) {
        List<dynamic> payments = item['txPayments'];
        for (var payment in payments) {
          String paymentMethodName = payment['paymentMethodName'] ?? 'Unknown';
          double totalAmount = payment['totalAmount'] ?? 0.0;
          paymentMethodTotals.update(
              paymentMethodName, (value) => (value ?? 0.0) + totalAmount,
              ifAbsent: () => totalAmount);
        }
      }
      if (item is Map<String, dynamic> && item.containsKey('txSalesDetails')) {
        // Calculate total sales amount and total sub sales amount
        totalSalesAmount += calculateTotalSalesAmount(item['txSalesDetails']);
        totalSubSalesAmount +=
            calculateSubTotalSalesAmount(item['txSalesDetails']);
      }
    }

    // Return a map with both the raw response, payment method totals,
    // total sales amount, and total sub sales amount
    return {
      'rawData': json,
      'paymentMethodTotals': paymentMethodTotals,
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
