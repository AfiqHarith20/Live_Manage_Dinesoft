import 'package:live_manage_dinesoft/system_all_library.dart';

class DrawerPage extends StatefulWidget {
  final String accessToken;
  final String shopToken;
  final DateTime selectedDate;
  final String username; // Add username property
  final String password; // Add password property
  // final String selectedShop;
  const DrawerPage({
    super.key,
    required this.accessToken,
    required this.shopToken,
    required this.selectedDate,
    required this.username,
    required this.password,
    // required this.selectedShop,
  });

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final GlobalKey<ReportSalesState> reportSalesKey = GlobalKey();
  DateTime selectedDate = DateTime.now();

  Future<void> logout() async {
    // Clear user's tokens here
    // Navigate back to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GFDrawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: darkColorScheme.primary,
            ),
            child: Text(
              'Welcome to Dinesmart',
              style: AppTextStyle.titleMedium,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportSales(
                    selectedDate: widget.selectedDate, // Pass selectedDate
                    accessToken: widget.accessToken,
                    shopToken: widget.shopToken,
                    // selectedShopName: widget.selectedShop,
                  ),
                ),
              );
            },
            child: Container(
              height: 8.h,
              // width: 20.w,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.list,
                  ),
                  SizedBox(
                    width: 2.h,
                  ),
                  Text(
                    AppLocalizations.of(context)?.salesReportPageTitle ??
                        "Sales Report",
                    style: AppTextStyle.textmedium,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TablePage(
                    accessToken: widget.accessToken,
                    shopToken: widget.shopToken,
                    selectedDate: widget.selectedDate,
                  ),
                ),
              );
            },
            child: Container(
              height: 8.h,
              // width: 20.w,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.table_restaurant_outlined),
                  SizedBox(
                    width: 2.h,
                  ),
                  Text(
                    AppLocalizations.of(context)?.salesReportPageTitle ??
                        "Table Report",
                    style: AppTextStyle.textmedium,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingPage(),
                ),
              );
            },
            child: Container(
              height: 8.h,
              // width: 20.w,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.gear,
                  ),
                  SizedBox(
                    width: 2.h,
                  ),
                  Text(
                    AppLocalizations.of(context)?.settingPageTitle ?? "Setting",
                    style: AppTextStyle.textmedium,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              logout();
            },
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.rightFromBracket,
                  ),
                  SizedBox(
                    width: 2.h,
                  ),
                  Text(
                    AppLocalizations.of(context)?.logoutBtn ?? "Log Out",
                    style: AppTextStyle.textmedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
