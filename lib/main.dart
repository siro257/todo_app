import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants.dart';
import 'package:material_color_generator/material_color_generator.dart';

import 'home_screen.dart';

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
          primarySwatch: generateMaterialColor(color: kPrimaryColor),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(title: "Todos"),
        },
      ),
    );
  }
}
