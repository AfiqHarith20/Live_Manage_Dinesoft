import 'package:live_manage_dinesoft/system_all_library.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // Accessing the language preference variable
  LanguagePreference languagePreference = LanguagePreference();

  //Write data method
  Future<void> writeSecureData(String key, String value) async {
    await storage.write(key: key, value: value);
    printDebugLog('Selected language: $value'); // Logging the selected language
  }

  //Read data method
  Future<String> readSecureData(String key) async {
    String value = await storage.read(key: key) ?? 'No data found!';
    printDebugLog('Data read from secure storage: $value');
    return value;
  }

  //Delete data method
  deleteSecureDate(String key, String value) async {
    await storage.delete(key: key);
  }

  //Write the data language to store into secure_storage
  void languageSelected(String selectedLanguage, BuildContext dialogContext) {
    // Save the selected language
    languagePreference.isLanguageSelected = true;

    // Store the selected language in secure storage
    writeSecureData('selected_language', selectedLanguage);

    // Update the app's language instantly
    final locale =
        selectedLanguage == 'ms' ? const Locale('ms') : const Locale('en');
    Provider.of<LocaleProvider>(dialogContext, listen: false).setLocale(locale);

    // Close the dialog
    Navigator.pop(dialogContext);
  }

  //Read data from secure storage to check language have already selected or not
  void checkLanguageSelection(BuildContext context) {
    readSecureData('selected_language').then((value) {
      if (value == 'en' || value == 'ms') {
        languagePreference.isLanguageSelected = true;
        final locale = value == 'ms' ? const Locale('ms') : const Locale('en');
        Provider.of<LocaleProvider>(context, listen: false).setLocale(locale);
      } else {
        showLanguageSelectionDialog(context);
      }
    });
  }

  // Check if language is selected, if not, prompt user to select
  void showLanguageSelectionDialog(BuildContext context) {
    if (!languagePreference.isLanguageSelected) {
      String selectedLanguage = ''; // Variable to hold the selected language
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Please select a language'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: const Text('🇺🇸 English'),
                      tileColor: selectedLanguage == 'en' ? Colors.green : null,
                      onTap: () {
                        setState(() {
                          selectedLanguage = 'en';
                        });
                      },
                    ),
                    ListTile(
                      title: const Text('🇲🇾 Bahasa Malaysia'),
                      tileColor: selectedLanguage == 'ms' ? Colors.green : null,
                      onTap: () {
                        setState(() {
                          selectedLanguage = 'ms';
                        });
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Perform actions after selecting the language
                            languageSelected(selectedLanguage, dialogContext);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }
}
