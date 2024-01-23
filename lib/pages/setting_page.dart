// ignore_for_file: deprecated_member_use

import 'package:live_manage_dinesoft/system_all_library.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
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
                  "About Us",
                  style: AppTextStyle.textmedium.copyWith(
                    color: Colors.black,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
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
