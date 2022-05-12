import 'package:flutter/cupertino.dart';

class GetSize{
  static double getMaxHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }

  static double getMaxWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
}