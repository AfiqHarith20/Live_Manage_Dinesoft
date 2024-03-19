// ignore_for_file: use_build_context_synchronously, avoid_print, unnecessary_null_comparison

import 'dart:async';

import 'package:live_manage_dinesoft/system_all_library.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppBarWithShopSelector extends StatefulWidget
    implements PreferredSizeWidget {
  final String accessToken;
  final String shopToken;
  final Function(String, String, String) onShopSelected;
  final String username;
  final String password;

  const AppBarWithShopSelector({
    super.key,
    required this.accessToken,
    required this.shopToken,
    required this.onShopSelected,
    required this.username,
    required this.password,
  });

  @override
  AppBarWithShopSelectorState createState() => AppBarWithShopSelectorState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppBarWithShopSelectorState extends State<AppBarWithShopSelector> {
  late String _selectedShop;
  List<String> _shops = [];
  Map<String, String> _shopTokens = {};
  String? _errorMessage;
  bool _isLoading = false;
  late Timer _timer; // Declare the timer variable
  late String selectedShopName;
  late final StatefulNavigationShell navigationShell;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _selectedShop = widget.shopToken;
    // selectedShopName = _selectedShop;
    _fetchShops();

    // Initialize the timer in initState
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _fetchShops();
    });
  }

  @override
  void dispose() {
    // Cancel the timer in dispose
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchShops() async {
    try {
      final http.Response response = await http.post(
        Uri.parse(
            'https://ewapi.azurewebsites.net/api/UserAccess/ShopTokenInfoList'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: json.encode({
          'username': widget.username,
          'password': widget.password,
          'selectedShop':
              _selectedShop // Include the selected shop in the request body
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          final List<dynamic> shopList = json.decode(response.body);
          _shops = shopList.map((shop) => shop['shopName'] as String).toList();

          // Populate the shop tokens map
          _shopTokens = {
            for (var shop in shopList)
              shop['shopName'] as String: shop['secretCode'] as String
          };

          // Ensure the currently selected shop is in the updated list
          _selectedShop = _shops.contains(widget.shopToken)
              ? widget.shopToken
              : _shops.isNotEmpty
                  ? _shops.first
                  : '';
          _isLoading = false;
        });
        // Pass the selected shop name to the HomePage widget
        widget.onShopSelected(_selectedShop, widget.accessToken, _selectedShop);
      } else {
        print('Failed to fetch shops');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to fetch shops';
        });
      }
    } catch (e) {
      print('Error fetching shops: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching shops';
      });
    }
  }

  void _handleShopSelection(String? selectedShop) {
    if (selectedShop != null) {
      setState(() {
        _selectedShop = selectedShop;
      });

      // Get the secret code (shop token) corresponding to the selected shop
      final secretCode = _shopTokens[selectedShop] ?? '';
      final accessToken = widget.accessToken;

      // Print the details of the selected shop
      print('Selected Shop: $selectedShop');
      print('Secret Code: $secretCode');
      print('Access Token: $accessToken');

      // Save the selected shop's tokens
      _saveTokens(selectedShop, secretCode, accessToken);

      // Reload the entire app by pushing a new instance of HomePage onto the navigation stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            accessToken: accessToken,
            shopToken: secretCode,
            username: widget.username,
            password: widget.password,
            // selectedShopName: selectedShopName,
            onShopSelected: widget.onShopSelected,
          ),
        ),
      );
    }
  }

  Future<void> _saveTokens(
      String selectedShop, String secretCode, String accessToken) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedShop', selectedShop);
      await prefs.setString('accessToken', accessToken);
      await prefs.setString('secretCode', secretCode);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully changed shop to $_selectedShop.'),
        ),
      );
    } catch (e) {
      print('Error saving tokens: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving tokens. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight * 3, // Increase the height as needed
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _isLoading
                  ? Center(
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
                    )
                  : _errorMessage != null
                      ? Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _shops.map((shop) {
                            return ListTile(
                              title: Text(
                                shop,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                _handleShopSelection(shop);
                              },
                            );
                          }).toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
