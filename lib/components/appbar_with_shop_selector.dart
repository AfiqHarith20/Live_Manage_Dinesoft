import 'package:live_manage_dinesoft/system_all_library.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class AppBarWithShopSelector extends StatefulWidget
    implements PreferredSizeWidget {
  final String accessToken;
  final String shopToken;
  final Function(String, String) onShopSelected;
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
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true; // Set isLoading to true when starting the fetch
    _selectedShop = widget.shopToken; // Initialize _selectedShop here
    _fetchShops();
  }

  Future<void> _fetchShops() async {
    try {
      final http.Response response = await http.post(
        Uri.parse(
            'https://ewapi.azurewebsites.net/api/UserAccess/ShopTokenInfoList'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, String>{
          'username': widget.username,
          'password': widget.password,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> shopList = json.decode(response.body);
        setState(() {
          _shops = shopList.map((shop) => shop['shopName'] as String).toList();
          _selectedShop = _shops.isNotEmpty ? _shops.first : '';
          _isLoading = false; // Set isLoading to false after fetching data
        });
      } else {
        print('Failed to fetch shops');
        setState(() {
          _isLoading = false; // Set isLoading to false in case of error
          _errorMessage = 'Failed to fetch shops'; // Set error message
        });
      }
    } catch (e) {
      print('Error fetching shops: $e');
      setState(() {
        _isLoading = false; // Set isLoading to false in case of error
        _errorMessage = 'Error fetching shops'; // Set error message
      });
    }
  }

  void _handleShopSelection(String newShopToken, String newAccessToken) {
    setState(() {});

    // Invoke the onShopSelected callback with the new shop token
    widget.onShopSelected(newShopToken, newAccessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _isLoading
              ? const CircularProgressIndicator(
                  strokeWidth: 2,
                )
              : _errorMessage != null
                  ? Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    )
                  : DropdownButton<String>(
                      value: _selectedShop,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedShop = newValue!;
                        });
                        _handleShopSelection;
                      },
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.grey,
                      ),
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
                    ),
        ),
      ],
    );
  }
}
