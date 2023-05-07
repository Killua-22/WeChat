import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ChatBodyWidget extends StatelessWidget {
  final List users;

  const ChatBodyWidget({
    required this.users,
    Key? key,
  }) : super(key: key);

  Widget buildChats() => ListView.builder(
        itemBuilder: (context, index) {
          final user = users[index];

          return Container(
            height: 75,
            child: ListTile(
              onTap: () {},
              title: Text(user['name']),
            ),
          );
        },
        itemCount: users.length,
      );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Color(0xFF292F3F),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            )),
        child: buildChats(),
      ),
    );
    ;
  }
}
