import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/TodoList.dart';
import 'package:todolist/TodoListModel.dart';

const PrimaryColor = const Color(0xFF151026);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoListModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: PrimaryColor,
        ),
        home: TodoList(),
      ),
    );
  }
}
