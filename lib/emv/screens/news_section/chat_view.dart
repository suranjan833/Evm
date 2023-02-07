import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../base_widgets/custom_text_field.dart';
import '../../commons/helper_functions.dart';
import '../../commons/stylesheet.dart';
import '../../handlers/data_handler.dart';
import '../../handlers/models.dart';
import '../auth/login.dart';
import '../dialogs/chatroom_dialog.dart';
import '../dialogs/login_page_center_dialog.dart';

class ChatViewScreen extends StatefulWidget {
  const ChatViewScreen({Key key}) : super(key: key);

  @override
  State<ChatViewScreen> createState() => _ChatViewScreenState();
}

class _ChatViewScreenState extends State<ChatViewScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  ScrollController _scrollController = ScrollController();
  ScrollController _controller;
  final ImagePicker _picker = ImagePicker();
  XFile pickedFile;
  Timer _timer;
  bool showChatRooms = false;
  bool privateChat = false;
  bool _sending = false;
  bool scroll = false;
  int scrollcount = 0;
  @override
  void initState() {
    // getSession();
    _controller = ScrollController();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _controller.animateTo(_controller.position.maxScrollExtent,
    //       duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
    // });

    //await Future.delayed(const Duration(milliseconds: 300));

    // _timer=Timer.periodic(const Duration(milliseconds: 1200), (t) => {
    //
    //
    // });

    _timer =
        Timer.periodic(const Duration(milliseconds: 800), (t) => getChats());

    super.initState();
  }

  getSession() {
    if (prefs.getString("authToken") == null) {
      pushTo(context, LoginScreen());
    } else {
      null;
    }
  }

  getChats() async {
    final db = Provider.of<AppDataHandler>(context, listen: false);
    await db.getMsg();
    if (scrollcount != 1) {
      scrollcount = 1;
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }

  void scrollBottom() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _controller.animateTo(_controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn);
    });
    scrollcount = 2;
    setState(() {});
  }

  chatroomfactor(String name) {
    switch (name) {
      case "1":
        return "Tesla";
      case "2":
        return "SpaceX";
      default:
        return "Elon Musk";
    }
  }

  String getChatroomName(AppDataHandler db) {
    switch (db.newsModel) {
      case "All":
        return chatroomfactor(db.newsType);
      default:
        return db.newsModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    final roomName = db.newTypeValue();
    final msgList = db.getChatingList;
    if (scrollcount == 1) {
      scrollBottom();
    }
    //toast(msgList.length.toString()+" "+db.getUserProfile.userId.toString());
    return Expanded(
      child: SizedBox(
        child: prefs.getString("authToken") == null
            ? const Padding(
                padding: EdgeInsets.all(30.0),
                child: Center(child: LoginPageCenterDialog()),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: getScreenWidth(context),
                    padding:
                        const EdgeInsets.all(10).copyWith(top: 0, bottom: 0),
                    decoration: const BoxDecoration(color: kDefaultColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                splashRadius: 10,
                                onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const ChatRoomSelectView()),
                                icon:
                                    const Icon(Icons.menu, color: kWhiteColor)),
                            Text(
                                "Chat Room: ${getChatroomName(db) == "Model E" ? "Model 3" : getChatroomName(db)}",
                                style: textTheme(context)
                                    .headlineMedium
                                    ?.copyWith(color: kWhiteColor)),
                          ],
                        ),
                        Text("(${msgList.length})",
                            style: textTheme(context)
                                .headlineMedium
                                ?.copyWith(color: kWhiteColor)),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SingleChildScrollView(
                      reverse: false,
                      controller: _controller,
                      child: Column(
                        children: msgList
                            .map((e) => getChatCloud(
                                e.senderId.toString() ==
                                    db.getUserProfile.userId.toString(),
                                e))
                            .toList(),
                      ),
                    ),
                  )),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                                child: CustomTextField(
                          controller: _msgCtrl,
                          shrink: true,
                          showBorder: true,
                          hint: "Enter your message..",
                        ))),
                        IconButton(
                            onPressed: () async {
                              pickedFile = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              setState(() => {});
                              //toast(pickedFile.path);
                            },
                            icon: Icon(Icons.attach_file_outlined,
                                color: kBlackColor.withOpacity(0.5))),
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: kDefaultColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: _sending
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: kWhiteColor))
                                : IconButton(
                                    onPressed: () async {
                                      if (_msgCtrl.text.isEmpty &&
                                          pickedFile.path.isEmpty) {
                                        null;
                                      } else {
                                        setState(() => _sending = true);
                                        //toast(pickedFile.path);
                                        await db
                                            .sendMsg(
                                                _msgCtrl.text.trim(),
                                                pickedFile != null
                                                    ? pickedFile.path
                                                    : '',
                                                "file")
                                            .then((value) => {
                                                  _msgCtrl.clear(),
                                                  pickedFile = null,
                                                  setState(() => {
                                                        _sending = false,
                                                        scrollcount = 1
                                                      })
                                                });
                                      }
                                    },
                                    icon: const Icon(Icons.send,
                                        color: kWhiteColor))),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget getChatCloud(bool right, ChatModel msg) {
    if (right) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints:
                BoxConstraints(maxWidth: getScreenWidth(context) * 0.5),
            width: msg.msg.contains("<img src=")
                ? getScreenWidth(context) * 0.5
                : null,
            margin:
                EdgeInsets.only(top: 8, left: getScreenWidth(context) * 0.25),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
                color: kDefaultColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(5)
                    .copyWith(bottomRight: const Radius.circular(0))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text.rich(TextSpan(
                    text: "${msg.senderName} ",
                    style: textTheme(context).headlineMedium,
                    children: [
                      TextSpan(
                          text: "${msg.msgtime}",
                          style: textTheme(context)
                              .headlineSmall
                              .copyWith(fontWeight: FontWeight.w300))
                    ])),
                SizedBox(height: 3),
                msg.msg.contains("<img src=")
                    ? Html(
                        shrinkWrap: false,
                        data: msg.msg,
                        style: {
                          "body": Style(
                            width: getScreenWidth(context) * 0.5,
                            color: kBlackColor,
                            textAlign: TextAlign.left,
                            fontSize: const FontSize(16.0),
                          ),
                        },
                      )
                    : Text(msg.msg,
                        style: textTheme(context)
                            .headlineMedium
                            ?.copyWith(color: kWhiteColor))
              ],
            ),
          ),
          SizedBox(width: 5),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(msg.senderImage),
          )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(msg.senderImage),
          ),
          SizedBox(width: 5),
          Container(
            constraints:
                BoxConstraints(maxWidth: getScreenWidth(context) * 0.5),
            width: msg.msg.contains("<img src=")
                ? getScreenWidth(context) * 0.5
                : null,
            margin:
                EdgeInsets.only(top: 8, right: getScreenWidth(context) * 0.25),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
                color: kBlackColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(5)
                    .copyWith(bottomLeft: const Radius.circular(0))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(
                    text: "${msg.senderName} ",
                    style: textTheme(context).headlineMedium,
                    children: [
                      TextSpan(
                          text: "${msg.msgtime}",
                          style: textTheme(context)
                              .headlineSmall
                              .copyWith(fontWeight: FontWeight.w300))
                    ])),
                SizedBox(height: 3),
                msg.msg.contains("<img src=")
                    ? Html(
                        shrinkWrap: false,
                        data: msg.msg,
                        style: {
                          "body": Style(
                            width: getScreenWidth(context) * 0.5,
                            color: kBlackColor,
                            textAlign: TextAlign.left,
                            fontSize: const FontSize(16.0),
                          ),
                        },
                      )
                    : Text(msg.msg,
                        style: textTheme(context)
                            .headlineMedium
                            ?.copyWith(color: kWhiteColor))
              ],
            ),
          ),
        ],
      );
    }
  }

  dom.Document convertText(String text) {
    dom.Document myDocument = htmlparser.parse(text);
    return myDocument;
  }
}
