import 'package:live_manage_dinesoft/system_all_library.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool _obscureText = true;

class _LoginPageState extends State<LoginPage> {
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                            "DINESOFT LIVE",
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
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                              // controller: userNameController,
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
                                fillColor: colorScheme.surface,
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
                              // controller: passwordController,
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
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .forgotPassword,
                                    style: AppTextStyle.textsmall,
                                  ),
                                  TextSpan(
                                    text:
                                        AppLocalizations.of(context)!.clickHere,
                                    style: AppTextStyle.textlink,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                // All fields are valid, call the userLogin function
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AuthenticationPage(),
                                  ),
                                );
                              } else {
                                // Show a snackbar with a warning
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter both username and password',
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
