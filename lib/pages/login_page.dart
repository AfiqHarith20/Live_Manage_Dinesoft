// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:live_manage_dinesoft/system_all_library.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool _obscureText = true;
bool _rememberMe = false;

class _LoginPageState extends State<LoginPage> {
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  late String selectedShopName;

  Future<bool> _validateLoginResponse(http.Response response) async {
    if (response.statusCode == 200) {
      // Login successful, return true
      return true;
    } else {
      // Login failed, show an error message and return false
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.messageSnackBar2,
            style: AppTextStyle.textsmall,
          ),
        ),
      );
      return false;
    }
  }

  Future<void> _fetchUserData(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      // All fields are valid, call the login API
      final String username = userNameController.text;
      final String password = passwordController.text;
      final http.Response response = await http.post(
        Uri.parse(
            'https://ewapi.azurewebsites.net/api/UserAccess/ShopTokenInfoList'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      // Validate login response
      dynamic validateResponse = await _validateLoginResponse(response);

      if (validateResponse) {
        // Parse JSON array and show the shop selection dialog
        final List<dynamic> userDataList = json.decode(response.body);
        if (userDataList.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => ShopSelectionDialog(
              userDataList: userDataList,
            ),
          ).then((selectedShop) async {
            if (selectedShop != null) {
              final Map<String, dynamic> userData = selectedShop;
              final String secretCode = userData['secretCode'];
              final String accessToken = userData['accessToken'];

              // Call saveTokens method here
              await saveTokens(context, accessToken, secretCode,
                  (String newShopToken, String newAccessToken,
                      String selectedShopName) {
                // Implement your logic here
              }, username, password);
            }
          });
        } else {
          print('No user data found in the JSON array');
        }
      } else {
        // Show a snackbar with a warning
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.messageSnackBar3,
              style: AppTextStyle.textsmall,
            ),
          ),
        );
      }
    }
  }

  Future<void> saveTokens(
      BuildContext context,
      String accessToken,
      String secretCode,
      Function(String, String, String) onShopSelected,
      String username,
      String password) async {
    try {
      // Check if tokens are not empty
      if (accessToken.isEmpty || secretCode.isEmpty) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter both tokens.'),
          ),
        );
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('shop_token', secretCode);

      // Save user credentials if Remember Me is checked
      if (_rememberMe) {
        await prefs.setString('username', username);
        await prefs.setString('password', password);
      }

      // Print the tokens before saving
      print('Access Token: $accessToken');
      print('Shop Token: $secretCode');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successfully.'),
        ),
      );

      // Navigate to the home page with the tokens
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            accessToken: accessToken,
            shopToken: secretCode,
            onShopSelected: onShopSelected,
            username: username,
            password: password,
            // selectedShopName: selectedShopName,
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
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const ColorScheme colorScheme = darkColorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primary,
                    colorScheme.secondary,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  const LocaleSwitcherWidget(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "DINESMART",
                            style: AppTextStyle.titleLarge,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            AppLocalizations.of(context)!.welcomePageTitle,
                            style: AppTextStyle.titleMedium,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          SizedBox(
                            width: 85.w,
                            child: TextFormField(
                              controller: urlController
                                ..text = 'hq.caterlord', // Set initial text
                              decoration: const InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 15.0,
                                  ),
                                  child: FaIcon(FontAwesomeIcons.link),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 15.0,
                                ),
                              ),
                              style: const TextStyle(
                                // TextStyle for the default text
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                color:
                                    Colors.grey, // Adjust the color if needed
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          SizedBox(
                            width: 85.w,
                            child: TextFormField(
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                              controller: userNameController,
                              decoration: InputDecoration(
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 15.0,
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.user,
                                  ),
                                ),
                                hintText: AppLocalizations.of(context)!
                                    .hintAccountNameLabel,
                                hintStyle: AppTextStyle.hint,
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 15.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          SizedBox(
                            width: 85.w,
                            child: TextFormField(
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              controller: passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 15.0,
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.key,
                                  ),
                                ),
                                hintText: AppLocalizations.of(context)!
                                    .hintPasswordLabel,
                                hintStyle: AppTextStyle.hint,
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 15.0,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: FaIcon(
                                      _obscureText
                                          ? FontAwesomeIcons.eyeSlash
                                          : FontAwesomeIcons.eye,
                                      color: colorScheme.outlineVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                },
                              ),
                              Text(
                                'Remember Me',
                                style: AppTextStyle.textsmall,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                // All fields are valid, call the login API
                                await _fetchUserData(context);
                              } else {
                                // Show a snackbar with a warning
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppLocalizations.of(context)!
                                          .messageSnackBar3,
                                      style: AppTextStyle.textsmall,
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(
                                40.w,
                                5.h,
                              ), // Set the width and height as needed
                            ),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .welcomePageSignInBtn,
                              style: AppTextStyle.textmedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
