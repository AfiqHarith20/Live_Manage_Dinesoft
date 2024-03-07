// ignore_for_file: use_build_context_synchronously, avoid_print

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
  Map<String, String> _shopTokens =
      {}; // Map to store shopName -> secretCode mapping
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _selectedShop =
        widget.shopToken; // Initialize _selectedShop with widget.shopToken
    _fetchShops();
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
          _selectedShop = _shops.contains(_selectedShop)
              ? _selectedShop
              : _shops.isNotEmpty
                  ? _shops.first
                  : '';
          _isLoading = false;
        });
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
    print('Selected shop from Dropdown: $selectedShop');
    if (selectedShop != null) {
      setState(() {
        _selectedShop = selectedShop;
        print('Updated _selectedShop: $_selectedShop');
        setState(() {});
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
        const SnackBar(
          content: Text('Tokens saved successfully.'),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _isLoading
              ? const CircularProgressIndicator(strokeWidth: 2)
              : _errorMessage != null
                  ? Text(_errorMessage!,
                      style: const TextStyle(color: Colors.red))
                  : Builder(
                      builder: (BuildContext context) {
                        return DropdownButton<String>(
                          value:
                              _selectedShop, // Use _selectedShop as the value
                          onChanged: _handleShopSelection,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(height: 2, color: Colors.grey),
                          items: _shops
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
