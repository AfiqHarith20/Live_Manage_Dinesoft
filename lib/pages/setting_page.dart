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
        // actions: const [
        //   LocaleSwitcherWidget(),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
              ),
              child: ListTile(
                onTap: () {
                  // Navigate to the authentication page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthenticationPage(),
                    ),
                  );
                },
                title: Text(
                  AppLocalizations.of(context)?.authKeyTxt ??
                      "Authentication Key",
                  style: AppTextStyle.textmedium.copyWith(
                    color: Colors.black,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
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
            SizedBox(height: 8.h),
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
