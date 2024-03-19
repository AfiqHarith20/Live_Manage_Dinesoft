import 'package:live_manage_dinesoft/system_all_library.dart';

class LocaleSwitcherWidget extends StatelessWidget {
  const LocaleSwitcherWidget({super.key});

  String _getLanguageDisplayText(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return '🇺🇸 English';
      case 'ms':
        return '🇲🇾 Bahasa Malaysia';
      default:
        return locale.languageCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    const ColorScheme colorScheme = lightColorScheme;
    return IconButton(
      icon: FaIcon(
        FontAwesomeIcons.language,
        color: colorScheme.onTertiary,
      ), // You can set the icon as globe emoji if you prefer
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            String selectedLanguage =
                ''; // Variable to hold the selected language
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text(
                    AppLocalizations.of(context)!.selectLaguageTitle,
                  ),
                  titleTextStyle: AppTextStyle.titleSmall,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        AppLocalizations.supportedLocales.map((nextLocale) {
                      return ListTile(
                        title: Text(_getLanguageDisplayText(nextLocale)),
                        tileColor: selectedLanguage == nextLocale.languageCode
                            ? colorScheme.tertiary // Highlighted color
                            : null,
                        onTap: () {
                          setState(() {
                            selectedLanguage = nextLocale.languageCode;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        final provider =
                            Provider.of<LocaleProvider>(context, listen: false);
                        final locale = selectedLanguage == 'ms'
                            ? const Locale('ms')
                            : const Locale('en');
                        provider.setLocale(locale);
                        SecureStorage().writeSecureData(
                            'selected_language', selectedLanguage);
                        Navigator.pop(
                            context); // Close the dialog after selection
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
