//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/PostModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/pages/HomePage.dart';
import 'package:flutter_app/pages/ProfilePage.dart';
import 'package:flutter_app/pages/UserProfilePage.dart';
import 'package:flutter_app/pages/WishlistPage.dart';
import 'package:flutter_app/pages/AddNewPostPage.dart';
import 'package:flutter_app/pages/NotificationPage.dart';
import 'package:provider/provider.dart';

class NavigationBar {
  static navigationBar(context) {
    int _selectedIndex = 0;
    return Material(
      child: BottomNavigationBar(
        backgroundColor: Color(0xff59071a),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xff59071a),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add_outlined),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_sharp),
            label: 'Cart',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_sharp),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (currentIndex) {
          if (currentIndex == 0)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          else if (currentIndex == 1)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WishlistPage()),
            );
          else if (currentIndex == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNewPostPage()),
            );
          } else if (currentIndex == 3)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage()),
            );
          else if (currentIndex == 4)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfilePage()),
            );
        },
      ),
    );
  }
}
