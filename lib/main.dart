import 'package:flutter/material.dart';
import 'package:flutter_todo_app/SecondRoute.dart';
import 'package:flutter_todo_app/constants.dart';

import 'TodoList.dart';

void main() {
  runApp(const MyToDoApp());
}

class DismissKeyboard extends StatelessWidget {
  const DismissKeyboard({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}

class MyToDoApp extends StatelessWidget {
  const MyToDoApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: PRIMARYCOLOR,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MyHomePage(title: "Todos"),
          '/second': (context) => const SecondRoute()
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/second'),
              child: Icon(Icons.menu),
            ),
          )
        ],
      ),
      body: ListView(
        children: const <Widget>[
          TodoList(),
        ],
      ),
    );
  }
}
