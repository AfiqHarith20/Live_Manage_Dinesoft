import 'package:live_manage_dinesoft/system_all_library.dart';

class DrawerPage extends StatefulWidget {
  final String accessToken;
  final String shopToken;
  final DateTime selectedDate;
  const DrawerPage({
    super.key,
    required this.accessToken,
    required this.shopToken,
    required this.selectedDate,
  });

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final GlobalKey<ReportSalesState> reportSalesKey = GlobalKey();
  DateTime selectedDate = DateTime.now();

  // Future<void> _selectDate(BuildContext context) async {
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime(2025),
  //   );

  //   if (pickedDate != null && pickedDate != selectedDate) {
  //     setState(() {
  //       selectedDate = pickedDate;
  //     });

  //     // Update the selected date in ReportSales
  //     reportSalesKey.currentState?.updateDate(selectedDate);
  //   }
  // }

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
                    AppLocalizations.of(context)!.salesReportPageTitle,
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
                    AppLocalizations.of(context)!.settingPageTitle,
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
