import 'package:chat_app/Authenticate/Methods.dart';
import 'package:chat_app/Screens/ChatRoom.dart';
// import 'package:chat_app/group_chats/group_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../chatbody.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  String name = "";
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF1B202D),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Messages",
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xFF1B202D),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context))
        ],
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Row(children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Container(
                        height: size.height / 14,
                        width: size.width / 1.4,
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: size.height / 14,
                          width: size.width / 1.15,
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            onChanged: (val) {
                              setState(() {
                                name = val;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 2, left: 20),
                              filled: true,
                              fillColor: Color(0xFF373E4E),
                              hintText: "Search",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(200),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width / 50,
                    ),
                    ElevatedButton(
                      // onPressed: onSearch(
                      // name),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: Icon(Icons.search),
                    ),
                  ]),
                  SizedBox(
                    height: size.height / 30,
                    // height: 200,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 0, top: 40),
                      decoration: BoxDecoration(
                          color: Color(0xFF292F3F),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          )),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore.collection('users').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot doc =
                                      snapshot.data!.docs[index];

                                  if (name.isEmpty &&
                                      doc['name'] !=
                                          _auth.currentUser!.displayName!) {
                                    return ListTile(
                                      contentPadding: EdgeInsets.only(left: 40),
                                      leading: CircleAvatar(
                                          backgroundColor: Colors.black),
                                      title: Text(
                                        doc['name'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        doc['email'],
                                        style:
                                            TextStyle(color: Color(0xFFB3B9C9)),
                                      ),
                                      onTap: () {
                                        print(_auth.currentUser!.displayName!);
                                        print(doc['name']);
                                        userMap = doc.data() as Map<String,
                                            dynamic>; //as Map<String, dynamic>;
                                        String roomId = chatRoomId(
                                            _auth.currentUser!.displayName!,
                                            doc['name']);

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => ChatRoom(
                                              chatRoomId: roomId,
                                              userMap: userMap!,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  if (doc['name']
                                          .toString()
                                          .toLowerCase()
                                          .startsWith(name.toLowerCase()) &&
                                      doc['name'] !=
                                          _auth.currentUser!.displayName!) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                          backgroundColor: Colors.black),
                                      title: Text(
                                        doc['name'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        doc['email'],
                                        style:
                                            TextStyle(color: Color(0xFFB3B9C9)),
                                      ),
                                      onTap: () {
                                        userMap = doc.data() as Map<String,
                                            dynamic>; //as Map<String, dynamic>;
                                        print(_auth.currentUser!.displayName!);
                                        String roomId = chatRoomId(
                                            _auth.currentUser!.displayName!,
                                            doc['name']);

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => ChatRoom(
                                              chatRoomId: roomId,
                                              userMap: userMap!,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  return Container();
                                });
                          }
                          return Container();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
