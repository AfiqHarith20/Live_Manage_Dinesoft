import 'package:live_manage_dinesoft/system_all_library.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<Map<String, dynamic>> fetchSalesData(DateTime date) async {
  final formattedDate =
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  final url = Uri.parse(
      "https://ewapi.azurewebsites.net/api/shop/orders?date=$formattedDate");
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final http.Response response = await http.get(
    url,
    headers: ({
      'access_token': '00a333f4-6b41-4151-afa4-3259b2aa0bd4',
      'shop_token': 'a746cb2f-2772-4016-a312-60a6ca8f4f7a'
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
