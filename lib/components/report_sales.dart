// ignore_for_file: must_be_immutable

import 'package:live_manage_dinesoft/system_all_library.dart';

class ReportSales extends StatefulWidget {
  DateTime selectedDate;

  ReportSales({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<ReportSales> createState() => ReportSalesState();
}

class ReportSalesState extends State<ReportSales> {
  final GlobalKey<ReportSalesState> keyReportSales = GlobalKey();

  void updateDate(DateTime newDate) {
    setState(() {
      widget.selectedDate = newDate;
    });
  }

  List<Map<String, dynamic>> extractSummaryData(List<dynamic> txSalesDetails) {
    List<Map<String, dynamic>> summaryList = [];

    for (var salesDetail in txSalesDetails) {
      if (salesDetail is Map<String, dynamic>) {
        // Extract relevant information and add to summaryList
        String categoryName = salesDetail['categoryName'] ?? 'Unknown';
        String itemName = salesDetail['itemName'] ?? 'Unknown';
        int quantity = salesDetail['qty'] ?? 0;
        double price = salesDetail['price'] ?? 0.0;

        summaryList.add({
          'categoryName': categoryName,
          'itemName': itemName,
          'quantity': quantity,
          'price': price,
        });
      }
    }

    return summaryList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: darkColorScheme.surface,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: fetchSalesData(widget.selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!['txSalesDetails'] == null) {
                  return const Text('No data available');
                } else {
                  // Print txSalesDetails response
                  print('txSalesDetails: ${snapshot.data!['txSalesDetails']}');
                  List<Map<String, dynamic>> summaryList =
                      extractSummaryData(snapshot.data!['txSalesDetails']);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: summaryList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(summaryList[index]['itemName'].toString()),
                        subtitle: Text(
                          'Category: ${summaryList[index]['categoryName']} | '
                          'Quantity: ${summaryList[index]['quantity']} | '
                          'Price: RM${summaryList[index]['price'].toStringAsFixed(2)}',
                        ),
                        // Add more details or customize the widget as needed
                      );
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
