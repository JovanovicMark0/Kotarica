import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Ocena {
  static Stack ocena(username, komentar, jePozitivnaOcena, screenWidth, screenHeight) {
    return Stack(
      children: [
        Container(
          // IZMENITI DA BUDE OCENA
          margin: EdgeInsets.fromLTRB(screenWidth * 0.05, 10.0, 20.0, 8.0),
          decoration: BoxDecoration(
            color: jePozitivnaOcena ? Colors.greenAccent : Colors.redAccent,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 0.0, 20.0, 3.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 50),
                        child: Container(
                            child: Center(child: Text(username, style: TextStyle(fontWeight: FontWeight.bold),))
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Container(child: Text(komentar),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: SizedBox(child:
                          jePozitivnaOcena ? Icon(Icons.thumb_up, color: Colors.white, size: 30,) : Icon(Icons.thumb_down, color: Colors.white, size: 30),
                          height: 50,
                        ),
                      ),

                    ],)
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}