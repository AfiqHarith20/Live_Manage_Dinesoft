// ignore_for_file: deprecated_member_use

import 'package:live_manage_dinesoft/system_all_library.dart';

class SettingPage extends StatefulWidget {
  static const String routeName = '/setting';
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
              child: InkWell(
                onTap: () {
                  // Navigate to the authentication page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthenticationPage(),
                    ),
                  );
                },
                child: ListTile(
                  leading: const Icon(Icons.key),
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
            ),
            Divider(
              color: Colors.black,
              height: 1.h,
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
              ),
              child: InkWell(
                onTap: () async {
                  const url = 'https://www.dinesoft.com.my/';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: ListTile(
                  leading: const Icon(Icons.info),
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
            ),
            Divider(
              color: Colors.black,
              height: 1.h,
            ),
            // ListTile(
            //   leading: const Icon(Icons.logout),
            //   title: Text(
            //     AppLocalizations.of(context)?.logoutBtn ?? 'Log Out',
            //     style: AppTextStyle.textmedium,
            //   ),
            //   onTap: logout,
            //   onLongPress: () {
            //     showDialog(
            //       context: context,
            //       builder: (context) {
            //         return AlertDialog(
            //           title: Text(
            //             "Log Out",
            //             style: AppTextStyle.titleMedium,
            //           ),
            //           content: Text(
            //             "Are you sure you want to log out?",
            //             style: AppTextStyle.textmedium,
            //           ),
            //           actions: [
            //             TextButton(
            //               onPressed: () {
            //                 Navigator.pop(context);
            //               },
            //               child: Text(
            //                 'Cancel',
            //                 style: AppTextStyle.textmedium,
            //               ),
            //             ),
            //             TextButton(
            //               onPressed: () {
            //                 logout();
            //               },
            //               child: Text(
            //                 AppLocalizations.of(context)?.logoutBtn ??
            //                     'Log Out',
            //                 style: AppTextStyle.textmedium,
            //               ),
            //             ),
            //           ],
            //         );
            //       },
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
