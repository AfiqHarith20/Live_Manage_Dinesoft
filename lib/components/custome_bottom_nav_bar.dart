// // ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// import 'package:live_manage_dinesoft/system_all_library.dart';

// class CustomBottomNavBar extends StatelessWidget {
//   late String accessToken;
//   late String shopToken;
//   final String username;
//   final String password;
//   final DateTime selectedDate;
//   final Function(String, String, String) onShopSelected;
//   CustomBottomNavBar({
//     super.key,
//     required this.accessToken,
//     required this.shopToken,
//     required this.username,
//     required this.password,
//     required this.selectedDate,
//     required this.onShopSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: PersistentTabView(
//         tabs: [
//           PersistentTabConfig(
//             screen: HomePage(
//               accessToken: accessToken,
//               shopToken: shopToken,
//               onShopSelected: onShopSelected,
//               username: username,
//               password: password,
//             ),
//             item: ItemConfig(
//               icon: const FaIcon(
//                 FontAwesomeIcons.house,
//               ),
//               title: "Home",
//             ),
//           ),
//           PersistentTabConfig(
//             screen: ReportSales(
//               selectedDate: selectedDate,
//               accessToken: accessToken,
//               shopToken: shopToken,
//             ),
//             item: ItemConfig(
//               icon: const FaIcon(
//                 FontAwesomeIcons.list,
//               ),
//               title: "Report",
//             ),
//           ),
//           PersistentTabConfig(
//             screen: TablePage(
//               accessToken: accessToken,
//               shopToken: shopToken,
//               selectedDate: selectedDate,
//             ),
//             item: ItemConfig(
//               icon: const Icon(
//                 Icons.table_restaurant_outlined,
//               ),
//               title: "Table",
//             ),
//           ),
//           PersistentTabConfig(
//             screen: const SettingPage(),
//             item: ItemConfig(
//               icon: const FaIcon(
//                 FontAwesomeIcons.gear,
//               ),
//               title: "Setting",
//             ),
//           ),
//         ],
//         navBarBuilder: (navBarConfig) => Style8BottomNavBar(
//           navBarConfig: navBarConfig,
//         ),
//       ),
//     );
//   }
// }
