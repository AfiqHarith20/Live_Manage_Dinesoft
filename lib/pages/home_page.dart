// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:intl/intl.dart';
import 'package:live_manage_dinesoft/system_all_library.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  late String accessToken;
  late String shopToken;
  // late String selectedShopName;
  final String username;
  final String password;
  final Function(String, String, String) onShopSelected;
  HomePage({
    super.key,
    required this.accessToken,
    required this.shopToken,
    required this.username,
    // required this.selectedShopName,
    required this.password,
    required this.onShopSelected,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  DateTime selectedDate = DateTime.now();
  final GlobalKey<LiveSalesState> liveSalesKey = GlobalKey();
  final GlobalKey<ReportSalesState> reportSalesKey = GlobalKey();

  // Add a method to simulate content loading
  void loadData() {
    setState(() {
      _loading = true; // Set _loading to true before initiating data fetching
    });

    // Simulate an asynchronous operation
    Future.delayed(const Duration(seconds: 2), () {
      // Once the data fetching is complete, set _loading to false
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Call loadData in initState or wherever appropriate in your code
    loadData();
  }

  void _handleShopSelection(
      String newShopToken, String newAccessToken, String selectedShopName) {
    setState(() {
      // Update tokens with new values
      widget.shopToken = newShopToken;
      widget.accessToken = newAccessToken;
      // widget.selectedShopName = selectedShopName;
    });

    // Invoke the onShopSelected callback with the new shop token
    widget.onShopSelected(newShopToken, newAccessToken, selectedShopName);
  }

  // Method to show DatePicker and update selectedDate
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });

      // Update the selected date in LiveSales
      liveSalesKey.currentState?.updateDate(selectedDate);
      // Update the selected date in ReportSales
      reportSalesKey.currentState?.updateDate(selectedDate);

      // Reload the page by calling the loadData method
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerPage(
        accessToken: widget.accessToken,
        shopToken: widget.shopToken,
        selectedDate: selectedDate,
        // selectedShop: widget.selectedShopName,
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.bars,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.homePageTitle,
          style: AppTextStyle.titleMedium,
        ),
        backgroundColor: darkColorScheme.primary,
        actions: [
          Builder(
            builder: (context) {
              double appBarWithShopSelectorHeight =
                  20.h; // Adjust this value as needed
              return PopupMenuButton(
                icon: const FaIcon(FontAwesomeIcons.shop),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      height: appBarWithShopSelectorHeight,
                      child: AppBarWithShopSelector(
                        accessToken: widget.accessToken,
                        shopToken: widget.shopToken,
                        username: widget.username,
                        password: widget.password,
                        onShopSelected: _handleShopSelection,
                      ),
                    ),
                  ];
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Perform the data loading here
            loadData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 8,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Handle left icon press to change date or day
                          // Example: Decrease date by one day
                          setState(() {
                            selectedDate =
                                selectedDate.subtract(const Duration(days: 1));
                            liveSalesKey.currentState?.updateDate(selectedDate);
                            reportSalesKey.currentState
                                ?.updateDate(selectedDate);
                            // Reload data or perform necessary actions
                            loadData();
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_left),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Show date picker when the date text is tapped
                          _selectDate(context);
                        },
                        child: Text(
                          DateFormat('MMM d, EEE').format(selectedDate),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle right icon press to change date or day
                          // Example: Increase date by one day
                          setState(() {
                            selectedDate =
                                selectedDate.add(const Duration(days: 1));
                            liveSalesKey.currentState?.updateDate(selectedDate);
                            reportSalesKey.currentState
                                ?.updateDate(selectedDate);
                            // Reload data or perform necessary actions
                            loadData();
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_right),
                      ),
                    ],
                  ),
                  // Skeletonizer(
                  //   enabled: _loading,
                  //   child: AppBarWithShopSelector(
                  //     accessToken: widget.accessToken,
                  //     shopToken: widget.shopToken,
                  //     username: widget.username,
                  //     password: widget.password,
                  //     onShopSelected: _handleShopSelection,
                  //   ),
                  // ),
                  Skeletonizer(
                    enabled: _loading,
                    child: LiveSales(
                      selectedDate: selectedDate,
                      onDateChanged: (newDate) {
                        // Update the selected date in ReportSales
                        reportSalesKey.currentState?.updateDate(newDate);
                      },
                      accessToken: widget.accessToken,
                      shopToken: widget.shopToken,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Skeletonizer(
                    enabled: _loading,
                    child: ComparingPage(
                      selectedDate: selectedDate,
                      accessToken: widget.accessToken,
                      shopToken: widget.shopToken,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Skeletonizer(
                    enabled: _loading,
                    child: PaymentSales(
                      selectedDate: selectedDate,
                      accessToken: widget.accessToken,
                      shopToken: widget.shopToken,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: SpeedDial(
      //   icon: Icons.add,
      //   tooltip: AppLocalizations.of(context)!.selectDate,
      //   backgroundColor: Colors.blue,
      //   foregroundColor: Colors.white,
      //   children: [
      //     SpeedDialChild(
      //       child: const FaIcon(FontAwesomeIcons.calendar),
      //       label: AppLocalizations.of(context)!.selectDate,
      //       onTap: () => _selectDate(context),
      //     ),
      //   ],
      // ),
    );
  }
}
