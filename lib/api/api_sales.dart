import 'dart:io';

import 'package:live_manage_dinesoft/system_all_library.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

//API sales data

Future<Map<String, dynamic>> fetchSalesData(
    DateTime date, String accessToken, String shopToken) async {
  try {
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

    // Print the response body for debugging
    // print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final dynamic responseBody = jsonDecode(response.body);

      // Add null check here
      if (responseBody == null) {
        return {'rawData': [], 'totalSalesAmount': 0};
      }

      if (responseBody is List<dynamic>) {
        // Check if the list is not empty
        if (responseBody.isNotEmpty) {
          // Calculate total sales amount
          double totalSalesAmount = calculateTotalSalesAmount(responseBody);

          // Return the data including totalSalesAmount
          return {
            'rawData': responseBody,
            'totalSalesAmount': totalSalesAmount
          };
        } else {
          return {'rawData': [], 'totalSalesAmount': 0};
        }
      } else {
        throw Exception('Invalid response format: Not a JSON array');
      }
    } else {
      // Check for specific error codes and handle them accordingly
      if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please check your access token');
      } else {
        throw Exception('Failed to fetch sales: ${response.statusCode}');
      }
    }
  } on SocketException catch (_) {
    // Handle SocketException (no internet connection)
    throw Exception('No internet connection');
  } catch (e) {
    throw Exception('0');
  }
}

double calculateSubTotalSalesAmount(List<dynamic> salesDetails) {
  double totalSubAmount = 0.0;
  for (var salesDetail in salesDetails) {
    if (salesDetail is Map<String, dynamic> &&
        salesDetail.containsKey('amountSubtotal')) {
      totalSubAmount += (salesDetail['amountSubtotal'] ?? 0.0);
    }
  }
  return totalSubAmount;
}

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
    final dynamic responseBody = jsonDecode(response.body);
    if (responseBody == null) {
      throw Exception('Response body is null');
    }
    final List<dynamic> json = responseBody as List<dynamic>;
    print('API Response: $json');
    // Extract and return the required data directly
    return extractSummaryData(json);
  } else {
    throw Exception('Failed to fetch sales');
  }
}
