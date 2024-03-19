import 'package:live_manage_dinesoft/system_all_library.dart';

class AppNavigation {
  final String accessToken;
  final String shopToken;
  final String username;
  final String password;
  final DateTime selectedDate;
  final Function(String, String, String) onShopSelected;
  final StatefulNavigationShell navigationShell; // Add navigationShell field

  AppNavigation({
    required this.accessToken,
    required this.shopToken,
    required this.username,
    required this.password,
    required this.selectedDate,
    required this.onShopSelected,
    required this.navigationShell, // Pass navigationShell here
  }) {
    initializeRouter(); // Call initializeRouter in the constructor
  }

  static String initR = '/home';
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _rootNavigatorHome =
      GlobalKey<NavigatorState>();

  late final GoRouter _router;

  GoRouter get router => _router;

  void initializeRouter() {
    _router = GoRouter(
      initialLocation: initR,
      navigatorKey: _rootNavigatorKey,
      routes: <RouteBase>[
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShellInstance) {
            // Use a different name for the parameter
            return CustomBottomNavBar(
              accessToken: accessToken,
              shopToken: shopToken,
              username: username,
              password: password,
              selectedDate: selectedDate,
              onShopSelected: onShopSelected,
              navigationShell:
                  navigationShellInstance, // Pass navigationShellInstance
            );
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              navigatorKey: _rootNavigatorHome,
              routes: [
                GoRoute(
                  path: '/home',
                  name: 'Home',
                  builder: (context, state) {
                    return HomePage(
                      accessToken: accessToken,
                      shopToken: shopToken,
                      username: username,
                      password: password,
                      onShopSelected: onShopSelected,
                      navigationShell:
                          navigationShell, // Pass navigationShell to HomePage
                    );
                  },
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
