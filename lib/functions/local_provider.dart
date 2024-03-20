import 'package:live_manage_dinesoft/system_all_library.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale("en");

  Locale get locale => _locale;

  final SecureStorage secureStorage = SecureStorage();

  void setLocale(Locale locale) {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();

      // Log the selected language
      if (locale.languageCode == 'en') {
        printDebugLog('English');
      } else if (locale.languageCode == 'ms') {
        printDebugLog('Bahasa Malaysia');
        // You can use 'ms' or any other language code you're using for Bahasa Malaysia
      }
    } else if (locale.languageCode == 'zh') {
      printDebugLog('官話');
    }
  }
}
