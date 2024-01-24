// ignore_for_file: use_build_context_synchronously

import 'package:live_manage_dinesoft/system_all_library.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  TextEditingController accessTokenController = TextEditingController();
  TextEditingController shopTokenController = TextEditingController();

  Future<void> saveTokens() async {
    try {
      // Check if tokens are not empty
      if (accessTokenController.text.isEmpty ||
          shopTokenController.text.isEmpty) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter both tokens.'),
          ),
        );
        return;
      }

      // Print the tokens before saving
      print('Access Token: ${accessTokenController.text}');
      print('Shop Token: ${shopTokenController.text}');

      // Save the tokens to SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('access_token', accessTokenController.text);
      prefs.setString('shop_token', shopTokenController.text);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tokens saved successfully.'),
        ),
      );

      // Navigate to the home page with the tokens
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            accessToken: accessTokenController.text,
            shopToken: shopTokenController.text,
          ),
        ),
      );
    } catch (e) {
      // Handle specific exceptions and show error message
      print('Error saving tokens: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving tokens. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.authPageTitle,
          style: AppTextStyle.titleMedium,
        ),
        backgroundColor: darkColorScheme.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 8,
            ),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: accessTokenController,
                  decoration: const InputDecoration(labelText: 'Access Token'),
                ),
                TextField(
                  controller: shopTokenController,
                  decoration: const InputDecoration(labelText: 'Shop Token'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    saveTokens();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.savebtn,
                    style: AppTextStyle.textsmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
