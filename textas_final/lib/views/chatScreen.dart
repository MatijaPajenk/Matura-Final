// ignore_for_file: file_names, unnecessary_string_escapes, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:textas_final/heleperFunctions/sharedPrefrencesHelper.dart';
import 'package:textas_final/services/database.dart';

class ChatScreen extends StatefulWidget {
  final String chatWithUsername, name;
  const ChatScreen(this.chatWithUsername, this.name);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId = "", messageId = "";
  String myName = "", myProfilePic = "", myUserName = "", myEmail = "";
  TextEditingController messageTextEditingController = TextEditingController();

  Stream? messageStream;

  getMyInfoFromSharedPreferences() async {
    myName = await SharedPreferencesHelper().getDisplayName() as String;
    myProfilePic = await SharedPreferencesHelper().getUserProfile() as String;
    myUserName = await SharedPreferencesHelper().getUserName() as String;
    myEmail = await SharedPreferencesHelper().getUserEmail() as String;

    chatRoomId = getChatRoomIdByUsernames(widget.chatWithUsername, myUserName);
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    }
    return "$a\_$b";
  }

  addMessage(bool sendClicked) {
    if (messageTextEditingController.text != "") {
      String message = messageTextEditingController.text;
      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": lastMessageTs,
        "imgUrl": myProfilePic
      };

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendBy": myUserName,
          "lastMessageSentTs": lastMessageTs
        };

        DatabaseMethods().updateLstMessageSend(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          //remove the text in the message input field
          messageTextEditingController.text = "";

          //make the messageId blank to get regenerated on next text message
          messageId = "";
        }
      });
    }
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  bottomRight: sendByMe
                      ? const Radius.circular(0)
                      : const Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomLeft: sendByMe
                      ? const Radius.circular(24)
                      : const Radius.circular(0),
                ),
                color: sendByMe ? Colors.blue : const Color(0xFF858585),
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: const EdgeInsets.only(
                  bottom: 70,
                  top: 16,
                ),
                itemCount: snapshot.data!.docs.length,
                reverse: true,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];
                  return chatMessageTile(documentSnapshot["message"],
                      myUserName == documentSnapshot["sendBy"]);
                })
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreferences();
    getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withOpacity(0.6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageTextEditingController,
                      onChanged: (value) {
                        addMessage(false);
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "type a message",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    )),
                    GestureDetector(
                      onTap: () {
                        addMessage(true);
                      },
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}