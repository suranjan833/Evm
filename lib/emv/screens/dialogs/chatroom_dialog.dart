import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../base_widgets/custom_flat_button.dart';
import '../../commons/helper_functions.dart';
import '../../commons/stylesheet.dart';
import '../../handlers/data_handler.dart';

class ChatRoomSelectView extends StatefulWidget {
  const ChatRoomSelectView({Key key}) : super(key: key);

  @override
  State<ChatRoomSelectView> createState() => _ChatRoomSelectViewState();
}

class _ChatRoomSelectViewState extends State<ChatRoomSelectView> {
  bool privateChat = false;

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDataHandler>(context);
    final chatRoomsList = db.getChatroomList;
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Row(
        children: [
          Expanded(
              child: SizedBox(
                  child: CustomExpandedButton(
            ontap: () => setState(() => privateChat = !privateChat),
            backgroundColor: privateChat ? kDefaultColor : kWhiteColor,
            labelColor: privateChat ? kWhiteColor : kBlackColor,
            label: "Private",
          ))),
          Expanded(
              child: SizedBox(
                  child: CustomExpandedButton(
            ontap: () => setState(() => privateChat = !privateChat),
            backgroundColor: !privateChat ? kDefaultColor : kWhiteColor,
            labelColor: !privateChat ? kWhiteColor : kBlackColor,
            label: "Rooms",
          ))),
        ],
      ),
      children: [
        privateChat
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                    child: Text('Chat Room is Empty',
                        style: textTheme(context).headlineMedium)),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: getScreenWidth(context),
                child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (context, i) => ListTile(
                        onTap: () => {
                              db.setNewsModel(
                                  chatRoomsList[i].replaceAll(" (0)", "")),
                              db.getMsg()
                            },
                        title: Text(chatRoomsList[i],
                            style: textTheme(context).headlineMedium)),
                    separatorBuilder: (context, i) => const Divider(height: 2),
                    itemCount: chatRoomsList.length),
              ),
      ],
    );
  }
}
