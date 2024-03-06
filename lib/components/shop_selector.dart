// ignore_for_file: library_private_types_in_public_api

import 'package:live_manage_dinesoft/system_all_library.dart';

class ShopSelector extends StatefulWidget {
  final String accessToken;
  final List<String> shops;
  final String selectedShop;
  final Function(String) onShopSelected;

  const ShopSelector({
    super.key,
    required this.accessToken,
    required this.shops,
    required this.selectedShop,
    required this.onShopSelected,
  });

  @override
  _ShopSelectorState createState() => _ShopSelectorState();
}

class _ShopSelectorState extends State<ShopSelector> {
  late String _currentShop;

  @override
  void initState() {
    super.initState();
    _currentShop = widget.selectedShop;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _currentShop,
      onChanged: (value) {
        setState(() {
          _currentShop = value!;
        });
        widget.onShopSelected(value!);
      },
      items: widget.shops.map<DropdownMenuItem<String>>((String shop) {
        return DropdownMenuItem<String>(
          value: shop,
          child: Text(shop),
        );
      }).toList(),
    );
  }
}
