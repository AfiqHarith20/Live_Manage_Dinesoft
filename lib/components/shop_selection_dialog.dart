// ignore_for_file: library_private_types_in_public_api

import 'package:live_manage_dinesoft/system_all_library.dart';

class ShopSelectionDialog extends StatefulWidget {
  final List<dynamic> userDataList;

  const ShopSelectionDialog({required this.userDataList, super.key});

  @override
  _ShopSelectionDialogState createState() => _ShopSelectionDialogState();
}

class _ShopSelectionDialogState extends State<ShopSelectionDialog> {
  int? _selectedShopIndex;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a shop'),
      content: SizedBox(
        height: 200,
        child: SingleChildScrollView(
          child: Column(
            children: widget.userDataList.map((shop) {
              return ListTile(
                title: Text(shop['shopName']),
                selected:
                    _selectedShopIndex == widget.userDataList.indexOf(shop),
                onTap: () {
                  setState(() {
                    _selectedShopIndex = widget.userDataList.indexOf(shop);
                  });
                },
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _selectedShopIndex != null
              ? () {
                  Navigator.pop(
                      context, widget.userDataList[_selectedShopIndex!]);
                }
              : null,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
