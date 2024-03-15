import 'package:live_manage_dinesoft/system_all_library.dart';

bool isDebugMode = false;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });
  late StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadTokens(), // Load tokens from SharedPreferences
      builder: (context, AsyncSnapshot<Map<String, String>> snapshot) {
        final accessToken = snapshot.data?['access_token'] ?? '';
        final shopToken = snapshot.data?['shop_token'] ?? '';
        final isLoggedIn = snapshot.data?['is_logged_in'] == 'true';

        if (isLoggedIn && accessToken.isNotEmpty && shopToken.isNotEmpty) {
          // Initialize AppNavigation with the required parameters
          final appNavigation = AppNavigation(
            accessToken: accessToken,
            shopToken: shopToken,
            selectedDate: DateTime.now(),
            username: snapshot.data?['username'] ?? '',
            password: snapshot.data?['password'] ?? '',
            onShopSelected: (String newShopToken, String newAccessToken,
                String selectedShopName) {
              // Implement your logic here
            },
            navigationShell: navigationShell,
          );

          return ChangeNotifierProvider(
            create: (context) => LocaleProvider(),
            builder: (context, child) {
              final provider = Provider.of<LocaleProvider>(context);
              return ResponsiveSizer(
                builder: (context, orientation, deviceType) {
                  return MaterialApp.router(
                    onGenerateTitle: (context) =>
                        AppLocalizations.of(context)!.appTitle,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    locale: provider.locale,
                    debugShowCheckedModeBanner: isDebugMode,
                    routerConfig: appNavigation.router,
                    // home: HomePage(
                    //   accessToken: accessToken,
                    //   shopToken: shopToken,
                    //   // selectedShopName: selectedShopName,
                    //   username: snapshot.data?['username'] ?? '',
                    //   password: snapshot.data?['password'] ?? '',
                    //   onShopSelected: (String newShopToken,
                    //       String newAccessToken, String selectedShopName) {
                    //     // Implement your logic here
                    //   },
                    // ),
                  );
                },
              );
            },
          );
        } else {
          return ChangeNotifierProvider(
            create: (context) => LocaleProvider(),
            builder: (context, child) {
              final provider = Provider.of<LocaleProvider>(context);
              return ResponsiveSizer(
                builder: (context, orientation, deviceType) {
                  return MaterialApp(
                    onGenerateTitle: (context) =>
                        AppLocalizations.of(context)!.appTitle,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    locale: provider.locale,
                    debugShowCheckedModeBanner: isDebugMode,
                    home: const LoginPage(),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  Future<Map<String, String>> _loadTokens() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token') ?? '';
    final secretCode = prefs.getString('shop_token') ?? '';
    final username = prefs.getString('username') ?? '';
    final password = prefs.getString('password') ?? '';
    return {
      'access_token': accessToken,
      'shop_token': secretCode,
      'username': username,
      'password': password,
      'is_logged_in': 'true'
    };
  }
}
