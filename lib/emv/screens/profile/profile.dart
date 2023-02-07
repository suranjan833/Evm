import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../app_config.dart';
import '../../base_widgets/custom_flat_button.dart';
import '../../commons/helper_functions.dart';
import '../../commons/icons_logo_strings.dart';
import '../../commons/stylesheet.dart';
import '../../commons/toast.dart';
import '../../handlers/data_handler.dart';
import '../../handlers/request_handler.dart';
import '../auth/login.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({Key key}) : super(key: key);

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  bool _loading = false;
  String imgurl = "";
  final TextEditingController _NameCtrl = TextEditingController();
  final TextEditingController _userNameCtrl = TextEditingController();
  final TextEditingController _phoneNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _cpasswordCtrl = TextEditingController();

  @override
  void initState() {
    _NameCtrl.text = prefs.getString('name');
    _emailCtrl.text = prefs.getString('email');
    _phoneNameCtrl.text = prefs.getString('phone');
    _userNameCtrl.text = prefs.getString('username');
    _passwordCtrl.text = "";
    _cpasswordCtrl.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: prefs.getString("authToken") == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Not logged in",
                        style: textTheme(context)
                            .displayMedium
                            ?.copyWith(color: kredColor)),
                    putHeight(10),
                    Text("You must be logged in to access this page",
                        style: textTheme(context)
                            .headlineMedium
                            ?.copyWith(color: kBlackColor)),
                    putHeight(30),
                    CustomExpandedButton(
                        label: "Login",
                        ontap: () => pushTo(context, LoginScreen()))
                  ],
                ),
              )
            : Column(children: [
                Consumer<AppDataHandler>(builder: (context, data, _) {
                  final profile = data.getUserProfile;

                  return Card(
                    elevation: 10,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: getScreenWidth(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              imgurl != ""
                                  ? Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kBlackColor.withOpacity(0.2)),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.network(imgurl)),
                                    )
                                  : Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kBlackColor.withOpacity(0.2)),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: profile.avatar != "null"
                                            ? imgurl != ""
                                                ? Image.network(imgurl)
                                                : Image.network(profile.avatar)
                                            : Image.asset(
                                                imagePlaceHolder,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                              putWidth(20),
                              Expanded(
                                  child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MaterialButton(
                                      onPressed: () async {
                                        print("object");
                                        File file;
                                        var status =
                                            await Permission.storage.status;
                                        if (status.isGranted) {
                                          print('granted');
                                          final ImagePicker _picker =
                                              ImagePicker();
                                          final XFile image =
                                              await _picker.pickImage(
                                                  source: ImageSource.gallery);
                                          file = File(image.path);
                                          uploadProfilePicture(
                                              image.path, profile.userId);
                                        } else {
                                          Permission.storage.request();
                                          print('permission denied');
                                        }
                                        // final ImagePicker _picker = ImagePicker();
                                        // final XFile image = await _picker.pickImage(source: ImageSource.gallery);
                                      },
                                      child: Text(
                                        "Convert Your Pic Into Your Avatar",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      color: Colors.black,
                                      textColor: Colors.white,
                                    ),
                                    // Text(profile != null ? profile.name : "Unknown",
                                    //     style: textTheme(context).headline3),
                                    // Text(profile != null ? profile.email : "Unknown",
                                    //     style: textTheme(context).headline5),
                                  ],
                                ),
                              )),
                            ],
                          ),
                          Card(
                            child: Column(
                              children: [
                                TextField(
                                  controller: _NameCtrl,
                                  decoration: InputDecoration(hintText: "Name"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: _userNameCtrl,
                                  decoration:
                                      InputDecoration(hintText: "User Name"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: _emailCtrl,
                                  decoration:
                                      InputDecoration(hintText: "Email"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: _phoneNameCtrl,
                                  decoration:
                                      InputDecoration(hintText: "Phone"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: _passwordCtrl,
                                  decoration:
                                      InputDecoration(hintText: "Password"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: _cpasswordCtrl,
                                  decoration: InputDecoration(
                                      hintText: "Confirm Password"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    updateProfile(profile.userId.toString());
                                  },
                                  child: Text("Update Profile"),
                                  color: Colors.green,
                                  textColor: Colors.white,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
                putHeight(10),
                Card(
                  elevation: 5,
                  child: ListTile(
                    onTap: () {
                      setState(() => _loading = true);
                      Future.delayed(const Duration(milliseconds: 1200), () {
                        prefs.remove("authToken");
                        _loading = false;
                        setState(() {});
                      });
                    },
                    leading: const Icon(
                      Icons.logout_sharp,
                      color: kBlackColor,
                    ),
                    title: Text("Logout",
                        style: textTheme(context).headlineMedium),
                    trailing: _loading
                        ? const SizedBox(
                            height: 25,
                            width: 25,
                            child: Center(child: CircularProgressIndicator()))
                        : const SizedBox(),
                  ),
                )
              ]),
      ),
    );
  }

  Future<void> uploadProfilePicture(filepath, userid) async {
    setState(() {
      _loading = true;
    });
    var url = "${baseUrl}/api/v1/convert_avatar";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['id'] = userid.toString();
    request.files.add(http.MultipartFile('image',
        File(filepath).readAsBytes().asStream(), File(filepath).lengthSync(),
        filename: filepath.split("/").last));
    var res = await request.send();
    final respStr = await res.stream.bytesToString();
    setState(() {
      imgurl = respStr;
      _loading = false;
    });

    print(respStr);
  }

  bool validateEmail() {
    bool valid = _emailCtrl.text.isNotEmpty &&
        (_emailCtrl.text.contains("@") ||
            _emailCtrl.text.contains(".com") ||
            _emailCtrl.text.contains(".in"));

    return valid;
  }

  Map<String, String> getForm(String email, String name, String userid,
      String username, String phone, String password) {
    Map<String, String> body = {
      "email": email,
      "name": name,
      "user_id": userid,
      "user_name": username,
      "phone": phone,
      "password": password
    };
    return body;
  }

  void updateProfile(String userid) {
    // if (_emailCtrl.text.isEmpty && _NameCtrl.text.isEmpty) {
    //   submitProfile(email, name, userid);
    // } else {
    if (!validateEmail()) {
      toast("Please enter a valid email address");
    } else if (_NameCtrl.text.isEmpty) {
      toast("Please enter  name");
    } else if (_passwordCtrl.text != _cpasswordCtrl.text) {
      toast("Password and confirm password are not matched");
    } else {
      submitProfile(
          _emailCtrl.text.toString(), _NameCtrl.text.toString(), userid);
    }
  }

  void submitProfile(String email, String name, String userid) async {
    //toast(userid.toString());
    setState(() => _loading = true);

    var loginResponse = await RequestHandler.postServerRequest(
        "${baseUrl}/api/profile-update",
        getForm(email, name, userid, _userNameCtrl.text, _phoneNameCtrl.text,
            _passwordCtrl.text),
        false);
    print(loginResponse.toString());
    //toast(loginResponse.toString());
    if (loginResponse == null) {
      toast("Something went wrong");
      setState(() => _loading = false);
    } else {
      toast("Successfully Changed");
      setState(() => _loading = false);
      //prefs.remove("authToken");
      prefs.setString('name', name);
      prefs.setString('email', email);
      prefs.setString('password', _passwordCtrl.text.toString());
      prefs.setString('phone', _phoneNameCtrl.text.toString());
      prefs.setString('username', _userNameCtrl.text.toString());
      // Future.delayed(const Duration(milliseconds: 1200), () {
      //
      //   //prefs.remove('user_id');
      //   _loading = false;
      //   setState(() {});
      // }
      //
      // );
    }
  }
}
