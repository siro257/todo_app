import 'package:flutter/material.dart';
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
          primarySwatch: primaryColor,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MyHomePage(title: "Todos"),
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
  int _selctedIdx = 0;

  static const List<Widget> _widgetOptions = [TodoList(), Text("history")];

  void _onItemTapped(int idx) {
    setState(() {
      _selctedIdx = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selctedIdx),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'History',
          ),
        ],
        currentIndex: _selctedIdx,
        selectedItemColor: Colors.indigo[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
