import 'package:flutter/cupertino.dart';

class ChatMessage{
  String messageContent;
  String messageType; // "sender" ili "receiver"
  DateTime messageSentTime;
  ChatMessage({@required this.messageContent, @required this.messageType, @required this.messageSentTime});
}