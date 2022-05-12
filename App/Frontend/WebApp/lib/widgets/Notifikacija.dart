import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notifikacija {
  static Stack notifikacija(post, tipNotifikacije, screenWidth, screenHeight) {
    return Stack(
      children: [
        Container(
          // IZMENITI DA BUDE OCENA
          margin: EdgeInsets.fromLTRB(screenWidth * 0.05, 10.0, 20.0, 8.0),
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 0.0, 20.0, 3.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Container(
                            child: tipNotifikacije
                                ? Text("Kupili ste proizvod sa imenom: ")
                                : Text("Kupili su od Vas proizvod sa imenom: "),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: Container(
                              child: Center(
                                  child: Text(
                            post,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))),
                        ),
                      ],
                    )
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
