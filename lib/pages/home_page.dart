import 'package:live_manage_dinesoft/system_all_library.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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

  // Method to show DatePicker and update selectedDate
  // Method to show DatePicker and update selectedDate
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
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
      appBar: AppBar(
        title: Text(
          "General",
          style: AppTextStyle.titleMedium,
        ),
        backgroundColor: darkColorScheme.primary,
        actions: [
          // Add a PopupMenuButton for the date selection
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: InkWell(
                  onTap: () => _selectDate(context),
                  child: const Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 8.0),
                      Text('Select Date'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 8,
            ),
            child: Column(
              children: <Widget>[
                Skeletonizer(
                  enabled: _loading,
                  child: LiveSales(
                    selectedDate: selectedDate,
                    onDateChanged: (newDate) {
                      // Update the selected date in ReportSales
                      reportSalesKey.currentState?.updateDate(newDate);
                    },
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Skeletonizer(
                  enabled: _loading,
                  child: ReportSales(
                    selectedDate: selectedDate,
                    key: reportSalesKey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
