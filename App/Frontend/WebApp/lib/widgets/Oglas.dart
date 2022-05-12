import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class Oglas {
  static Stack oglas(
      naslov, poslednjaPonuda, kupiOdmah, screenWidth, screenHeight) {
    return Stack(
      children: [
        Container(
          //ZELENA POZADINA OGLASA
          margin: EdgeInsets.fromLTRB(screenWidth * 0.05, 10.0, 20.0, 8.0),
          decoration: BoxDecoration(
            color: Color(0xff5F968E),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            margin: EdgeInsets.fromLTRB(screenWidth * 0.25, 0.0, 20.0, 3.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02),
                            width: screenWidth * 0.27,
                            child: Text(
                              naslov, //activity.name,
                              style: TextStyle(
                                fontSize: screenHeight * 0.022,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.access_time_outlined,
                                  color: Colors.white,
                                  size: screenWidth*0.035,
                                ),
                              ),
                              Wrap(
                                children: [ CountdownTimer(
                                  endTime: DateTime(2021, 5, 5, 12, 48, 00)
                                      .millisecondsSinceEpoch,
                                  textStyle: TextStyle(
                                    fontSize: screenWidth*0.032,
                                    color: Colors.white,
                                  ),
                                  onEnd: () {},
                                ),
                                  ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ImageIcon(AssetImage('images/gavel.png'), size: screenWidth*0.035,color: Colors.white,)
                                ),
                              ),
                              Text(
                                poslednjaPonuda,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth*0.032,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              //margin: EdgeInsets.only(top: screenHeight * 0.2),
                              child: Text(
                                kupiOdmah, //'\$${activity.price}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenHeight * 0.021,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              'Kupi odmah',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            Align(
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 10.0, right: 0.0, bottom: 0.0),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.favorite_border,
                                      color: Colors.white70),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: screenWidth * 0.03,
          top: screenHeight * 0.02,
          bottom: screenHeight * 0.003,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              'images/oglasSlike.jpg',
              fit: BoxFit.cover,
              width: screenWidth * 0.30,
              height: screenHeight * 0.20,
            ),
          ),
        ),
      ],
    );
  }
}
