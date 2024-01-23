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
      // Save the tokens to SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('access_token', accessTokenController.text);
      prefs.setString('shop_token', shopTokenController.text);

      // Navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      // Handle the error (e.g., show an error message)
      print('Error saving tokens: $e');
      // You might want to show an error dialog or another UI feedback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Authentication",
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
                    // Check if the tokens are not empty
                    if (accessTokenController.text.isNotEmpty &&
                        shopTokenController.text.isNotEmpty) {
                      // Save the tokens and navigate to the home page
                      saveTokens();
                    } else {
                      // Show an error message or prevent navigation
                      // For example:
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter both tokens.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
