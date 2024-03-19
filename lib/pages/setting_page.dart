// ignore_for_file: deprecated_member_use

import 'package:live_manage_dinesoft/system_all_library.dart';

class SettingPage extends StatefulWidget {
  final String accessToken;
  final String shopToken;
  final DateTime selectedDate;
  final String username;
  final String password;
  final Function(String, String, String) onShopSelected;
  const SettingPage(
      {super.key,
      required this.accessToken,
      required this.shopToken,
      required this.selectedDate,
      required this.username,
      required this.password,
      required this.onShopSelected});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late StatefulNavigationShell navigationShell;
  Future<void> logout() async {
    // Clear user's tokens here
    // Navigate back to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.settingPageContent ?? "Setting",
          style: AppTextStyle.titleMedium,
        ),
        backgroundColor: darkColorScheme.primary,
        actions: const [
          LocaleSwitcherWidget(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Container(
            //   decoration: const BoxDecoration(
            //     border: Border(
            //       top: BorderSide(
            //         color: Colors.black,
            //         width: 1.0,
            //       ),
            //       bottom: BorderSide(
            //         color: Colors.black,
            //         width: 1.0,
            //       ),
            //     ),
            //   ),
            //   child: ListTile(
            //     onTap: () {
            //       // Navigate to the authentication page
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const AuthenticationPage(),
            //         ),
            //       );
            //     },
            //     title: Text(
            //       AppLocalizations.of(context)?.authKeyTxt ??
            //           "Authentication Key",
            //       style: AppTextStyle.textmedium.copyWith(
            //         color: Colors.black,
            //       ),
            //     ),
            //     trailing: const Icon(Icons.arrow_forward_ios),
            //   ),
            // ),
            // Add more Container widgets with ListTile for additional settings
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
              ),
              child: ListTile(
                onTap: () async {
                  const url = 'https://www.dinesoft.com.my/';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                title: Text(
                  AppLocalizations.of(context)?.aboutPageContent ??
                      "About Page",
                  style: AppTextStyle.textmedium.copyWith(
                    color: Colors.black,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Center(
              child: TextButton(
                onPressed: () async {
                  showCurrencyPicker(
                    context: context,
                    theme: CurrencyPickerThemeData(
                      flagSize: 25,
                      titleTextStyle: const TextStyle(fontSize: 17),
                      subtitleTextStyle: TextStyle(
                          fontSize: 15, color: Theme.of(context).hintColor),
                      bottomSheetHeight: MediaQuery.of(context).size.height / 2,
                      inputDecoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Start typing to search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF8C98A8).withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    onSelect: (Currency currency) {
                      // Handle the selected currency here
                      print('Selected currency: ${currency.name}');

                      // Update the selected currency in the app
                      Provider.of<CurrencyProvider>(context, listen: false)
                          .setSelectedCurrency(currency.code);

                      // Save the selected currency to shared preferences
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setString('selectedCurrency', currency.code);
                      });
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.monetization_on), // Currency change icon
                    const SizedBox(
                        width: 8), // Add some space between icon and text
                    Consumer<CurrencyProvider>(
                      builder: (context, currencyProvider, _) => Text(
                        'Change Currency (${currencyProvider.selectedCurrency})',
                        style: AppTextStyle.textmedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),
            GestureDetector(
              onTap: () {
                logout();
              },
              child: Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.rightFromBracket,
                    ),
                    SizedBox(
                      width: 2.h,
                    ),
                    Text(
                      AppLocalizations.of(context)?.logoutBtn ?? 'Log Out',
                      style: AppTextStyle.textmedium,
                    ),
                  ],
                ),
              ),
            ),
            // Add more Container widgets with ListTile for additional settings
            // Container(
            //   decoration: const BoxDecoration(
            //     border: Border(
            //       bottom: BorderSide(
            //         color: Colors.black,
            //         width: 1.0,
            //       ),
            //     ),
            //   ),
            //   child: ListTile(
            //     onTap: () {
            //       // Navigate to the authentication page
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const AuthenticationPage(),
            //         ),
            //       );
            //     },
            //     title: Text(
            //       "Language",
            //       style: AppTextStyle.textmedium.copyWith(
            //         color: Colors.black,
            //       ),
            //     ),
            //     trailing: const Icon(Icons.arrow_forward_ios),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
