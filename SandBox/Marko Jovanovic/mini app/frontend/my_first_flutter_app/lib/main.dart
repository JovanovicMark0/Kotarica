import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyFirstApp());

class MyFirstApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
        title:'Masne fote',

        theme:ThemeData(
          primarySwatch: Colors.blue,
        ),
      home:HomePage(),

    );
  }
}

class HomePage extends StatefulWidget
{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var lastPosition = 0.0;
  var random = new Random();

  AnimationController animationController;

  double getRandomNumber() {
    lastPosition = random.nextDouble();
    return lastPosition;
  }

  @override
  void initState() {
    super.initState();
    spinTheBottle();
  }

  spinTheBottle() {
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animationController.forward();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(),
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Image.asset("graphics/white.jpg", fit: BoxFit.fill,),
          ),
          Center(
            child: Container(
              child: RotationTransition(
                turns: Tween(begin: lastPosition, end: getRandomNumber())
                    .animate(
                    new CurvedAnimation(
                        parent: animationController, curve: Curves.linear)),
                child: GestureDetector(
                  onTap: () {
                    if (animationController.isCompleted) {
                      setState(() {
                        spinTheBottle();
                      });
                    }
                  },
                  child: GestureDetector(
                    onTap: () {
                      if (animationController.isCompleted) {
                        setState(() {
                          spinTheBottle();
                        });
                      }
                    },
                    child: Image.asset(
                      "graphics/bottle.jpg", width: 250, height: 250,),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}