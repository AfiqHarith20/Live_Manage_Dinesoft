import 'dart:async';
import 'dart:math';
import 'package:live_manage_dinesoft/system_all_library.dart';

class PaymentSales extends StatefulWidget {
  final DateTime selectedDate;
  final String accessToken;
  final String shopToken;

  const PaymentSales({
    super.key,
    required this.selectedDate,
    required this.accessToken,
    required this.shopToken,
  });

  @override
  State<PaymentSales> createState() => _PaymentSalesState();
}

class _PaymentSalesState extends State<PaymentSales> {
  Map<String, dynamic> paymentData = {};
  late Timer _timer;
  List<Map<String, dynamic>> chartData = [];

  // Map full payment type names to short forms
  final Map<String, String> paymentShortForms = {
    'Cash': 'C',
    'VISA': 'V',
    'MasterCard': 'M',
    'TNG E-Wallet': 'T',
    'Maybank QR': 'Q',
    'ShopeePay': 'S',
    'razECR': 'R',
  };

  @override
  void initState() {
    super.initState();
    // Fetch payment data when the widget is initialized
    fetchPaymentData();
    // Initialize paymentData with default values
    initializePaymentData();

    // Set up a timer to refresh data every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      fetchPaymentData();
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  // Initialize paymentData with default values
  void initializePaymentData() {
    List<String> paymentTypes = [
      'Cash',
      'VISA',
      'MasterCard',
      'TNG E-Wallet',
      'Maybank QR',
      'ShopeePay',
      'razECR',
    ];

    Map<String, Map<String, dynamic>> paymentTypeDetails = {};

    // Initialize counts and total amounts for each payment type to 0
    for (var paymentType in paymentTypes) {
      paymentTypeDetails[paymentType] = {
        'count': 0,
        'totalAmount': 0.0,
      };
    }

    setState(() {
      paymentData['paymentTypeDetails'] = paymentTypeDetails;
    });
  }

  // Method to fetch payment data based on selectedDate
  void fetchPaymentData() async {
    try {
      Map<String, dynamic>? responseData = await fetchSalesData(
        widget.selectedDate,
        widget.accessToken,
        widget.shopToken,
      );

      if (responseData != null &&
          responseData.containsKey('rawData') &&
          responseData['rawData'] is List) {
        List<dynamic> allPayments = [];
        if ((responseData['rawData'] as List).isNotEmpty) {
          for (var order in responseData['rawData']) {
            if (order.containsKey('txPayments')) {
              List<dynamic>? txPayments = order['txPayments'];
              if (txPayments != null) {
                allPayments.addAll(txPayments);
              }
            }
          }

          // Process payment data if available
          Map<String, dynamic> paymentTypeDetails =
              initializePaymentTypeDetails();
          for (var payment in allPayments) {
            String paymentMethodName = payment['paymentMethodName'];

            // Ensure the payment type is in paymentTypes and paymentShortForms
            if (!paymentTypeDetails.containsKey(paymentMethodName)) {
              paymentTypeDetails[paymentMethodName] = {
                'count': 0,
                'totalAmount': 0.0,
              };

              // Generate a short form if not present
              if (!paymentShortForms.containsKey(paymentMethodName)) {
                paymentShortForms[paymentMethodName] =
                    generateShortForm(paymentMethodName);
              }
            }

            paymentTypeDetails[paymentMethodName]['count']++;
            paymentTypeDetails[paymentMethodName]['totalAmount'] +=
                payment['totalAmount'];
          }

          List<Map<String, dynamic>> newChartData = paymentTypeDetails.entries
              .map((entry) => {
                    'genre': paymentShortForms[entry.key] ?? entry.key,
                    'sold': entry.value['count'],
                  })
              .toList();

          setState(() {
            chartData = newChartData;
            paymentData['paymentTypeDetails'] = paymentTypeDetails;
          });
        } else {
          // If no payment data is available, clear paymentData and display message
          setState(() {
            paymentData.clear();
          });
        }
      } else {
        // If 'rawData' is not a list or null, clear paymentData and display message
        setState(() {
          paymentData.clear();
        });
      }
    } catch (e) {
      print('Error fetching payment data: $e');
    }
  }

  String generateShortForm(String paymentName) {
    // Split the payment name into words
    final List<String> words = paymentName.split(' ');

    // Use the first letter of the first word as the short form
    String shortForm = words[0][0];

    // If there are multiple words and the first letters are the same, use the second letter as well
    if (words.length > 1 && words[0][0] == words[1][0]) {
      shortForm += words[1][1];
    }

    return shortForm;
  }

  // Update the paymentShortForms map to use the first and second letters of the payment name
  void updatePaymentShortForms() {
    final Map<String, String> updatedPaymentShortForms = {};
    final List<String> paymentNames = paymentShortForms.keys.toList();

    // Iterate through each payment name
    for (final paymentName in paymentNames) {
      final shortForm = generateShortForm(paymentName);
      updatedPaymentShortForms[paymentName] = shortForm;
    }

    // Update the paymentShortForms map
    setState(() {
      paymentShortForms.clear();
      paymentShortForms.addAll(updatedPaymentShortForms);
    });
  }

  Map<String, dynamic> initializePaymentTypeDetails() {
    final List<String> paymentTypes = [
      'Cash',
      'VISA',
      'MasterCard',
      'TNG E-Wallet',
      'Maybank QR',
      'ShopeePay',
      'razECR',
    ];

    final Map<String, dynamic> paymentTypeDetails = {};

    // Initialize counts and total amounts for each payment type to 0
    for (final paymentType in paymentTypes) {
      paymentTypeDetails[paymentType] = {
        'count': 0,
        'totalAmount': 0.0,
      };
    }

    return paymentTypeDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: const LinearGradient(
          colors: [Color(0xFF6E63FF), Color(0xFF967ADC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                PaymentChart(chartData: chartData),
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            AppLocalizations.of(context)!.paymentListType,
            style: AppTextStyle.titleMedium.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8.0),
          if (paymentData.isNotEmpty &&
              paymentData.containsKey('paymentTypeDetails'))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: paymentData['paymentTypeDetails']
                  .entries
                  .map<Widget>((entry) {
                final paymentType = entry.key;
                final count = entry.value['count'];
                final totalAmount = entry.value['totalAmount'];
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                paymentType,
                                style: AppTextStyle.titleSmall
                                    .copyWith(color: Colors.black),
                              ),
                              Text(
                                '${AppLocalizations.of(context)!.cnt}: $count',
                                style: AppTextStyle.textsmall
                                    .copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.h, // Adjust the height as needed
                          ),
                          Text(
                            '${AppLocalizations.of(context)!.totalAmount}: RM${totalAmount.toStringAsFixed(2)}',
                            style: AppTextStyle.textsmall
                                .copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ), // Space between payment entries
                  ],
                );
              }).toList(),
            )
          else
            Center(
              child: Text(
                AppLocalizations.of(context)!.msgNoPayment,
                style: AppTextStyle.titleMedium.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
