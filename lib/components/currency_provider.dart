import 'package:live_manage_dinesoft/system_all_library.dart';

class CurrencyProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  String _selectedCurrency = 'RM'; // Default currency is RM

  CurrencyProvider() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _selectedCurrency = _prefs.getString('selectedCurrency') ?? 'RM';
    notifyListeners();
  }

  String get selectedCurrency => _selectedCurrency;

  Future<void> setSelectedCurrency(String currency) async {
    _selectedCurrency = currency;
    await _prefs.setString('selectedCurrency', currency);
    notifyListeners();
  }
}
