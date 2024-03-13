// ignore_for_file: library_private_types_in_public_api
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:live_manage_dinesoft/system_all_library.dart';

class ShopListPage extends StatefulWidget {
  final String accessToken;
  final String shopToken;
  final Function(List<String>) onShopsSelected;
  final String username;
  final String password;

  const ShopListPage({
    Key? key,
    required this.onShopsSelected,
    required this.accessToken,
    required this.shopToken,
    required this.username,
    required this.password,
  }) : super(key: key);

  @override
  _ShopListPageState createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  late String _selectedShop;
  List<String> selectedShops = [];
  List<String> _shops = []; // Initialize shops list
  Map<String, String> _shopTokens = {};
  String? _errorMessage;
  bool _isLoading = false;
  late Timer _timer; // Declare the timer variable

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
          'selectedShop': _selectedShop,
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

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _selectedShop = widget.shopToken;
    _fetchShops(); // Call _fetchShops method when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Shops'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.onShopsSelected(selectedShops);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: _isLoading
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
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : ListView.builder(
                  itemCount: _shops.length,
                  itemBuilder: (context, index) {
                    final shop = _shops[index];
                    return ListTile(
                      title: Text(
                        shop,
                        style: const TextStyle(fontSize: 18),
                      ),
                      leading: Checkbox(
                        value: selectedShops.contains(shop),
                        onChanged: (value) {
                          setState(() {
                            if (value != null && value) {
                              selectedShops.add(shop);
                            } else {
                              selectedShops.remove(shop);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
