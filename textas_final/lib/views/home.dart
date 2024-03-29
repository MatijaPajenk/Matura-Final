// ignore_for_file: use_key_in_widget_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:textas_final/heleperFunctions/sharedPrefrencesHelper.dart';
import 'package:textas_final/services/auth.dart';
import 'package:textas_final/services/database.dart';
import 'package:textas_final/views/chatScreen.dart';
import 'package:textas_final/views/signIn.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;

  // ignore: prefer_typing_uninitialized_variables
  Stream<QuerySnapshot>? usersStream, chatRoomsStream;

  TextEditingController seacrhUsernameEditingController =
      TextEditingController();
  String chatRoomId = "", messageId = "";
  String? myName = "", myProfilePic = "", myUserName = "", myEmail = "";

  getMyInfoFromSharedPreferences() async {
    myName = await SharedPreferencesHelper().getDisplayName();
    myProfilePic = await SharedPreferencesHelper().getUserProfile();
    myUserName = await SharedPreferencesHelper().getUserName();
    myEmail = await SharedPreferencesHelper().getUserEmail();
    setState(() {});
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "${b}_$a";
    }
    return "${a}_$b";
  }

  onSearchBtnClick() async {
    isSearching = true;
    setState(() {});
    usersStream = await DatabaseMethods()
        .getUserByUserName(seacrhUsernameEditingController.text);

    setState(() {});
  }

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomsStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  return ChatRoomListTile(
                    documentSnapshot["lastMessage"],
                    documentSnapshot.id,
                    myUserName!,
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget searchListUserTile({profileUrl, name, username, email}) {
    return GestureDetector(
      onTap: () {
        var chatRoomId = getChatRoomIdByUsernames(myUserName!, username);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, username]
        };
        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(username, name)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).scaffoldBackgroundColor ==
                    const Color(0xfffec47f)
                ? const Color(0xFFE9632F)
                : Colors.grey.shade600,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(
                  profileUrl,
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).scaffoldBackgroundColor ==
                                const Color(0xfffec47f)
                            ? const Color(0xffffffff)
                            : Colors.white,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).scaffoldBackgroundColor ==
                                const Color(0xfffec47f)
                            ? const Color(0xffffffff)
                            : Colors.white70,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget searchUsersList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  try {
                    return searchListUserTile(
                        profileUrl: documentSnapshot["profileUrl"],
                        name: documentSnapshot["name"],
                        username: documentSnapshot["userName"],
                        email: documentSnapshot["email"]);
                  } catch (e) {
                    return Container();
                  }
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  getChatRooms() async {
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  onScreenLoaded() async {
    await getMyInfoFromSharedPreferences();
    getChatRooms();
  }

  @override
  void initState() {
    onScreenLoaded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/text_only.png",
          height: 40,
          color: Theme.of(context).scaffoldBackgroundColor ==
                  const Color(0xfffec47f)
              ? Colors.black
              : Colors.white,
        ),
        actions: [
          InkWell(
            onTap: () {
              AuthMethods().signOut().then((val) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                  (Route<dynamic> route) => false,
                );
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                isSearching
                    ? GestureDetector(
                        onTap: () {
                          isSearching = false;
                          seacrhUsernameEditingController.text = "";
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()));
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(Icons.arrow_back),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: seacrhUsernameEditingController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "username",
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (seacrhUsernameEditingController.text != "") {
                              onSearchBtnClick();
                            }
                          },
                          child: const Icon(Icons.search),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            isSearching ? searchUsersList() : chatRoomsList(),
          ],
        ),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUserName;
  const ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUserName);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "";

  getThisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUserName, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username);
    name = "${querySnapshot.docs[0]["name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["profileUrl"]}";

    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text("Archive conversation?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      DatabaseMethods().deleteChatRoom(widget.chatRoomId);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                          (route) => false);
                    },
                    child: const Text("ARCHIVE"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("CANCEL"),
                  )
                ],
              );
            });
      },
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(username, name)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).scaffoldBackgroundColor ==
                    const Color(0xfffec47f)
                ? const Color(0xFFE9632F)
                : Colors.grey.shade600,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  profilePicUrl,
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor ==
                              const Color(0xfffec47f)
                          ? const Color(0xffffffff)
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.lastMessage,
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor ==
                              const Color(0xfffec47f)
                          ? const Color(0xffffffff)
                          : Colors.white70,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
