import 'package:flutter/material.dart';
import 'package:flutter_app/models/LikesModel.dart';
import 'package:flutter_app/pages/AddNewPostPage.dart';
import 'package:flutter_app/pages/AuctionPage.dart';
import 'package:flutter_app/pages/HomePage.dart';
import 'package:flutter_app/pages/NotificationPage.dart';
import 'package:flutter_app/pages/ProfilePage.dart';
import 'package:flutter_app/pages/UserProfilePage.dart';
import 'package:flutter_app/pages/WishlistPage.dart';
import 'package:flutter_app/utility/SignalRHelper.dart';
import 'package:provider/provider.dart';
import 'models/WishModel.dart';
import 'pages/HomePage.dart';
import 'pages/LoginPage.dart';
import 'package:flutter_app/models/GradeModel.dart';

// modeli
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/models/PurchaseModel.dart';
import 'package:flutter_app/models/PostModel.dart';

void main() {
  //Provider.debugCheckInvalidValueType = null;
  //greska prilikom ulaska na dodaj oglas
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserModel()),
        Provider(create: (context) => PostModel()),
        Provider(create: (context) => LikesModel()),
        Provider(create: (context) => PurchaseModel()),
        Provider(create: (context) => WishModel()),
        Provider(create: (context) => SignalR()),
        Provider(create: (context) => GradeModel()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(
              0xff59071a), //Changing this will change the color of the TabBar
          accentColor: Colors.white,
        ),
        title: 'Kotarica',
        debugShowCheckedModeBanner: false,
        home:
            LoginPage(), //NavigationBar() // Promeniti na NavigationBar() za novo rutiranje stranica, ali preskace login stranicu
        //builder: (context, _) => NavigationBar(),
        routes: {
          HomePage.routeName: (_) => HomePage(),
          WishlistPage.routeName: (_) => WishlistPage(),
          AddNewPostPage.routeName: (_) => AddNewPostPage(),
          NotificationPage.routeName: (_) => NotificationPage(),
          UserProfilePage.routeName: (_) => UserProfilePage(),
          ProfilePage.routeName: (_) => ProfilePage(),
          LoginPage.routeName: (_) => LoginPage(),
          AuctionPage.routeName: (_) => AuctionPage(),
        },
      ),
    );
  }
}
