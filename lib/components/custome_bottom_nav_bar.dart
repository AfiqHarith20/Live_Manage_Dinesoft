import 'package:live_manage_dinesoft/system_all_library.dart';

class CustomBottomNavBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final String accessToken;
  final String shopToken;
  final String username;
  final String password;
  final DateTime selectedDate;
  final Function(String, String, String) onShopSelected;

  const CustomBottomNavBar({
    super.key,
    required this.accessToken,
    required this.shopToken,
    required this.username,
    required this.password,
    required this.selectedDate,
    required this.onShopSelected,
    required this.navigationShell,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.list),
            title: const Text("Report"),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.table_chart),
            title: const Text("Table"),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings),
            title: const Text("Settings"),
            selectedColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}
