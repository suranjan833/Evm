import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_config.dart';
import '../../base_widgets/custom_flat_button.dart';
import '../../base_widgets/custom_text_field.dart';
import '../../commons/custom_loading_indicator.dart';
import '../../commons/helper_functions.dart';
import '../../commons/stylesheet.dart';
import '../../commons/toast.dart';
import '../../handlers/data_handler.dart';
import '../dashboard.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _fNameCtrl = TextEditingController();
  final TextEditingController _lNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _confirmPassCtrl = TextEditingController();

  bool _termAccepted = false;
  bool _policyAccepted = false;

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    return GestureDetector(
      onTap: () => unfocus(context),
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          appLogo,
                          width: getScreenWidth(context) * 0.3,
                        ),
                        IconButton(
                            onPressed: () =>
                                pushAndRemove(context, DashboardScreen()),
                            icon: const Icon(Icons.home, color: kDefaultColor))
                      ],
                    ),
                    putHeight(30),
                    CustomTextField(
                      controller: _usernameCtrl,
                      hint: "User Name",
                      showBorder: true,
                    ),
                    putHeight(10),
                    // CustomTextField(
                    //   controller: _fNameCtrl,
                    //   hint: "First Name",
                    //   showBorder: true,
                    // ),
                    // putHeight(10),
                    // CustomTextField(
                    //   controller: _lNameCtrl,
                    //   hint: "Last Name",
                    //   showBorder: true,
                    // ),
                    // putHeight(10),
                    CustomTextField(
                      controller: _emailCtrl,
                      hint: "Email Address",
                      showBorder: true,
                    ),
                    putHeight(10),
                    // CustomTextField(
                    //   controller: _phoneCtrl,
                    //   hint: "Phone Number",
                    //   showBorder: true,
                    // ),
                    // putHeight(10),
                    CustomTextField(
                      controller: _passCtrl,
                      hint: "Password",
                      showBorder: true,
                    ),
                    putHeight(10),
                    CustomTextField(
                      controller: _confirmPassCtrl,
                      hint: "Confirm Password",
                      showBorder: true,
                    ),
                    putHeight(20),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Checkbox(
                          activeColor: kOrangeColor,
                          value: _termAccepted,
                          onChanged: (v) => setState(
                                () => _termAccepted = !_termAccepted,
                              )),
                      title: Text(
                        "I accept the terms & conditions",
                        style: textTheme(context).headlineMedium,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Checkbox(
                          activeColor: kOrangeColor,
                          value: _policyAccepted,
                          onChanged: (v) => setState(
                                () => _policyAccepted = !_policyAccepted,
                              )),
                      title: Text(
                        "I accept the privacy policy",
                        style: textTheme(context).headlineMedium,
                      ),
                    ),
                    putHeight(20),
                    CustomExpandedButton(
                      label: "Sign Up",
                      backgroundColor: kOrangeColor,
                      ontap: () => _onSignUpTapped(),
                    ),
                    putHeight(30),
                    Center(
                        child: Text(
                      "Already have and account?",
                      style: textTheme(context).headlineMedium,
                    )),
                    CustomExpandedButton(
                      isFlexible: true,
                      backgroundColor: Colors.transparent,
                      label: "Log In",
                      labelColor: kDefaultColor,
                      ontap: () => pushTo(context, LoginScreen()),
                    )
                  ],
                ),
              ),
            )),
            _loading ? const CustomLoadingIndicator() : const SizedBox()
          ],
        ),
      ),
    );
  }

  Map<String, String> getForm() {
    Map<String, String> body = {
      "email": _emailCtrl.text.trim(),
      "password": _passCtrl.text.trim(),
      "name": _usernameCtrl.text.trim(),
      "user_name": _usernameCtrl.text.trim()
    };
    return body;
  }

  _onSignUpTapped() async {
    final db = Provider.of<AppDataHandler>(context, listen: false);
    if (_validateData()) {
      setState(() => _loading = true);

      await db.registerUser(context, getForm()).then((value) {
        setState(() => _loading = false);
      });
    } else {
      null;
    }
  }

  bool _validateData() {
    if (!_policyAccepted || !_termAccepted) {
      toast("Please accept our terms, conditions and policy to continue");
      return false;
    } else if (_usernameCtrl.text.isEmpty ||
        _emailCtrl.text.isEmpty ||
        _passCtrl.text.isEmpty ||
        _confirmPassCtrl.text.isEmpty) {
      toast("Please enter information in all fields");
      return false;
    } else if (_passCtrl.text.length < 8) {
      toast("Password must be alteast 8 character long");
      return false;
    } else if (_passCtrl.text.trim() != _confirmPassCtrl.text.trim()) {
      toast("Password and Confirm Password does not match");
      return false;
    } else {
      return true;
    }
  }
}
