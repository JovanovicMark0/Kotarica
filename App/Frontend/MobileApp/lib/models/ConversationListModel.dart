import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/pages/MessageUserPage.dart';
import 'package:page_transition/page_transition.dart';

class ConversationList extends StatefulWidget {
  User secondUser;
  User name;
  String messageText;
  String imageUrl;
  String time;
  bool newMessage;
  ConversationList(
      {@required this.secondUser,
      @required this.name,
      @required this.messageText,
      @required this.imageUrl,
      @required this.time,
      @required this.newMessage});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: MessageUserPage(chatUser: widget.secondUser.id)));
        });
      },
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
              color: widget.newMessage ? Color(0xff5F968E) : Color(0xff91C9C1),
              border: Border.all(
                color:
                    widget.newMessage ? Color(0xff5F968E) : Color(0xff91C9C1),
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.imageUrl),
                      maxRadius: 60,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.name.firstname +
                                  " " +
                                  widget.name.lastname,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: widget.newMessage
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              widget.messageText,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: widget.newMessage
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                widget.time,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: widget.newMessage
                        ? FontWeight.bold
                        : FontWeight.normal),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
