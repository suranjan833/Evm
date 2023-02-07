import 'package:emv/emv/screens/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../../../custom/toast_component.dart';
import '../../../helpers/auth_helper.dart';
import '../../app_config.dart';
import '../../base_widgets/custom_flat_button.dart';
import '../../base_widgets/custom_text_field.dart';
import '../../commons/custom_loading_indicator.dart';
import '../../commons/helper_functions.dart';
import '../../commons/icons_logo_strings.dart';
import '../../commons/stylesheet.dart';
import '../../commons/toast.dart';
import '../../handlers/api_handler.dart';
import '../../handlers/data_handler.dart';
import '../../handlers/request_handler.dart';
import '../dashboard.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  int pageReference;
  LoginScreen({Key key, this.pageReference = 0}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  String _login_by = "email";

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final db = Provider.of<AppDataHandler>(context);
    return GestureDetector(
      onTap: () => unfocus(context),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kWhiteColor,
          foregroundColor: kBlackColor,
          elevation: 0,
          centerTitle: true,
          title: Image.asset(
            appLogo,
            width: getScreenWidth(context) * 0.3,
          ),
          leading: IconButton(
              onPressed: () => pushAndRemove(
                  context, DashboardScreen(viewIndex: widget.pageReference)),
              icon: const Icon(
                Icons.arrow_back_outlined,
                color: kBlackColor,
              )),
        ),
        body: Stack(
          children: [
            SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    putHeight(30),
                    CustomTextField(
                      controller: _emailCtrl,
                      hint: "Username or Email",
                      suffixIcon: sunIcon,
                      suffixColor: kDefaultColor.withOpacity(0.3),
                    ),
                    putHeight(30),
                    CustomTextField(
                      controller: _passCtrl,
                      hint: "Password",
                      suffixColor: kDefaultColor.withOpacity(0.3),
                      suffixIcon: sunIcon,
                    ),
                    putHeight(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () =>
                                pushTo(context, const ForgotPasswordScreen()),
                            child: Text(
                              "Forgot Password?",
                              style: theme.headlineMedium
                                  .copyWith(color: kDefaultColor),
                            ))
                      ],
                    ),
                    putHeight(30),
                    CustomExpandedButton(
                      label: "Log In",
                      backgroundColor: kOrangeColor,
                      ontap: () {
                        if (!validateEmail()) {
                          toast("Please enter a valid email address");
                        } else if (_passCtrl.text.isEmpty) {
                          toast("Password field can not be empty");
                        } else {
                          _onLogin();
                        }
                      },
                    ),
                    putHeight(40),
                    Center(
                      child: Text(
                        "Don't have an account?",
                        style: theme.headlineMedium,
                      ),
                    ),
                    CustomExpandedButton(
                      label: "Create Now",
                      isFlexible: true,
                      labelColor: kDefaultColor,
                      backgroundColor: kWhiteColor,
                      ontap: () => pushTo(context, const SignUpScreen()),
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

  bool validateEmail() {
    bool valid = _emailCtrl.text.isNotEmpty &&
        (_emailCtrl.text.contains("@") ||
            _emailCtrl.text.contains(".com") ||
            _emailCtrl.text.contains(".in"));

    return valid;
  }

  Map<String, String> getForm() {
    Map<String, String> body = {
      "email": _emailCtrl.text.trim(),
      "password": _passCtrl.text.trim()
    };
    return body;
  }

  _onLogin() async {
    setState(() => _loading = true);

    var loginResponse = await RequestHandler.postServerRequest(
        "${LOGIN_API}", getForm(), false);
    print("${LOGIN_API}");
    print(loginResponse);
    if (loginResponse == null) {
      toast("Incorrect Credentials or User not registered");
      setState(() => _loading = false);
    } else {
      final db = Provider.of<AppDataHandler>(context, listen: false);
      ToastComponent.showDialog("Login Successfully",
          gravity: Toast.center, duration: Toast.lengthLong);
      AuthHelper().setUserData(loginResponse);

      // push notification starts
      // if (OtherConfig.USE_PUSH_NOTIFICATION) {
      //   final FirebaseMessaging _fcm = FirebaseMessaging.instance;

      //   await _fcm.requestPermission(
      //     alert: true,
      //     announcement: false,
      //     badge: true,
      //     carPlay: false,
      //     criticalAlert: false,
      //     provisional: false,
      //     sound: true,
      //   );

      //   String fcmToken = await _fcm.getToken();

      //   if (fcmToken != null) {
      //     print("--fcm token--");
      //     print(fcmToken);

      //     // update device token
      //     var deviceTokenUpdateResponse =
      //         await ProfileRepository().getDeviceTokenUpdateResponse(fcmToken);
      //   }
      // }
      loginResponse != null
          ? await db
              .loginUser(context, getForm(), widget.pageReference)
              .then((value) => setState(() => _loading = false))
          : setState(() => _loading = false);
    }
  }
}
