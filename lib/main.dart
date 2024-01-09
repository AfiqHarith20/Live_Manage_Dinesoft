import 'package:live_manage_dinesoft/system_all_library.dart';

bool isDebugMode = true;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          final provider = Provider.of<LocaleProvider>(context);
          return ResponsiveSizer(builder: (context, orientation, deviceType) {
            return MaterialApp(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context)!.appTitle,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: provider.locale,
              debugShowCheckedModeBanner: isDebugMode,
              home: const LoginPage(),
            );
          });
        });
  }
}
