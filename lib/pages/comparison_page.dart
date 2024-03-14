// ignore_for_file: library_private_types_in_public_api

import 'package:live_manage_dinesoft/system_all_library.dart';

class ComparingPage extends StatefulWidget {
  final DateTime selectedDate;
  final String accessToken;
  final String shopToken;

  const ComparingPage({
    super.key,
    required this.selectedDate,
    required this.accessToken,
    required this.shopToken,
  });

  @override
  _ComparingPageState createState() => _ComparingPageState();
}

class _ComparingPageState extends State<ComparingPage> {
  late Future<Map<String, dynamic>> todaySalesData;
  late Future<Map<String, dynamic>> yesterdaySalesData;

  @override
  void initState() {
    super.initState();
    // Fetch yesterday's and today's data
    fetchSalesDataForSelectedDate(widget.selectedDate);
  }

  void fetchSalesDataForSelectedDate(DateTime selectedDate) {
    // Fetch yesterday's sales data (selectedDate - 1 day)
    DateTime yesterday = selectedDate.subtract(const Duration(days: 1));
    yesterdaySalesData =
        fetchSalesData(yesterday, widget.accessToken, widget.shopToken);

    // Fetch today's sales data
    todaySalesData =
        fetchSalesData(selectedDate, widget.accessToken, widget.shopToken);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([todaySalesData, yesterdaySalesData]),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
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
        } else if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          Map<String, dynamic>? todayData = snapshot.data![0];
          Map<String, dynamic>? yesterdayData = snapshot.data![1];

          double todayTotalSalesAmount = todayData['rawData'] != null
              ? calculateTotalSalesAmount(todayData['rawData'])
              : 0.0;
          double yesterdayTotalSalesAmount = yesterdayData['rawData'] != null
              ? calculateTotalSalesAmount(yesterdayData['rawData'])
              : 0.0;
          double todayNetSalesAmount = todayData['rawData'] != null
              ? calculateNetSalesAmount(todayData['rawData'])
              : 0.0;
          double yesterdayNetSalesAmount = yesterdayData['rawData'] != null
              ? calculateNetSalesAmount(yesterdayData['rawData'])
              : 0.0;
          int todayOrderCount = todayData['rawData'] != null
              ? calculateOrderCount(todayData['rawData'])
              : 0;
          int yesterdayOrderCount = yesterdayData['rawData'] != null
              ? calculateOrderCount(yesterdayData['rawData'])
              : 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCard(
                  'Today',
                  todayTotalSalesAmount,
                  todayNetSalesAmount,
                  todayOrderCount,
                  getArrowIcon(
                      todayTotalSalesAmount, yesterdayTotalSalesAmount),
                  getArrowIcon(todayNetSalesAmount, yesterdayNetSalesAmount),
                  getArrowIcon(todayOrderCount.toDouble(),
                      yesterdayOrderCount.toDouble()),
                ),
                const SizedBox(height: 16),
                _buildCard(
                  'Yesterday',
                  yesterdayTotalSalesAmount,
                  yesterdayNetSalesAmount,
                  yesterdayOrderCount,
                  getArrowIcon(
                      yesterdayTotalSalesAmount, todayTotalSalesAmount),
                  getArrowIcon(yesterdayNetSalesAmount, todayNetSalesAmount),
                  getArrowIcon(yesterdayOrderCount.toDouble(),
                      todayOrderCount.toDouble()),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildCard(
    String title,
    double totalSales,
    double netSales,
    int orderCount,
    IconData totalSalesArrow,
    IconData netSalesArrow,
    IconData orderCountArrow,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildMetric('Total Sales', 'RM$totalSales', totalSalesArrow),
            _buildMetric('Net Sales', 'RM$netSales', netSalesArrow),
            _buildMetric('Order Count', '$orderCount', orderCountArrow),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData arrowIcon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (arrowIcon != null) // Show arrow icon if it's not null
              Icon(
                arrowIcon,
                color:
                    arrowIcon == Icons.arrow_upward ? Colors.green : Colors.red,
              ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  IconData getArrowIcon(double todayValue, double yesterdayValue) {
    if (todayValue > yesterdayValue) {
      return Icons.arrow_upward;
    } else if (todayValue < yesterdayValue) {
      return Icons.arrow_downward;
    } else {
      return Icons.compare_arrows;
    }
  }

  double calculateTotalSalesAmount(List<dynamic> salesDetails) {
    double totalAmount = 0.0;
    for (var salesDetail in salesDetails) {
      if (salesDetail is Map<String, dynamic> &&
          salesDetail.containsKey('amountTotal')) {
        totalAmount += (salesDetail['amountTotal'] ?? 0.0);
      }
    }
    return double.parse(totalAmount.toStringAsFixed(2));
  }

  double calculateNetSalesAmount(List<dynamic> salesDetails) {
    double totalAmount = 0.0;
    for (var salesDetail in salesDetails) {
      if (salesDetail is Map<String, dynamic> &&
          salesDetail.containsKey('amountSubtotal')) {
        totalAmount += (salesDetail['amountSubtotal'] ?? 0.0);
      }
    }
    return double.parse(totalAmount.toStringAsFixed(2));
  }

  int calculateOrderCount(List<dynamic> salesDetails) {
    Set<int> uniqueTxSalesHeaderIds = {};
    for (var salesDetail in salesDetails) {
      if (salesDetail is Map<String, dynamic> &&
          salesDetail.containsKey('txSalesHeaderId')) {
        uniqueTxSalesHeaderIds.add(salesDetail['txSalesHeaderId'] as int);
      }
    }
    return uniqueTxSalesHeaderIds.length;
  }
}
