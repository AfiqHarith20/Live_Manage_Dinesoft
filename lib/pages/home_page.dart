// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:intl/intl.dart';
import 'package:live_manage_dinesoft/system_all_library.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  late String accessToken;
  late String shopToken;
  final String username;
  final String password;
  final Function(String, String, String) onShopSelected;

  HomePage({
    super.key,
    required this.accessToken,
    required this.shopToken,
    required this.username,
    required this.password,
    required this.onShopSelected,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  bool _loading = true;
  DateTime selectedDate = DateTime.now();
  late final StatefulNavigationShell navigationShell;
  final GlobalKey<LiveSalesState> liveSalesKey = GlobalKey();
  final GlobalKey<ReportSalesState> reportSalesKey = GlobalKey();
  @override
  bool get wantKeepAlive => true;

  void loadData() {
    setState(() {
      _loading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void _handleShopSelection(
      String newShopToken, String newAccessToken, String selectedShopName) {
    setState(() {
      widget.shopToken = newShopToken;
      widget.accessToken = newAccessToken;
    });

    widget.onShopSelected(newShopToken, newAccessToken, selectedShopName);
  }

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
      _updateDates();
      loadData();
    }
  }

  void _updateDates() {
    liveSalesKey.currentState?.updateDate(selectedDate);
    reportSalesKey.currentState?.updateDate(selectedDate);
  }

  void _handleLeftIconPress() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
    _updateDates();
    loadData();
  }

  void _handleRightIconPress() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
    });
    _updateDates();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.homePageTitle ?? 'Home',
          style: AppTextStyle.titleMedium,
        ),
        backgroundColor: darkColorScheme.primary,
        actions: [
          Builder(
            builder: (context) {
              double appBarWithShopSelectorHeight = 20.h;
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
                      GestureDetector(
                        onTap: _handleLeftIconPress,
                        child: const Icon(Icons.keyboard_arrow_left),
                      ),
                      GestureDetector(
                        onTap: () {
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
                      GestureDetector(
                        onTap: _handleRightIconPress,
                        child: const Icon(Icons.keyboard_arrow_right),
                      ),
                    ],
                  ),
                  Skeletonizer(
                    enabled: _loading,
                    child: LiveSales(
                      key: liveSalesKey,
                      selectedDate: selectedDate,
                      onDateChanged: (newDate) {
                        reportSalesKey.currentState!.updateDate(newDate);
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
    );
  }
}
