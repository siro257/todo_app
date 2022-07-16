import 'package:flutter/material.dart';

void main() {
  runApp(const MyToDoApp());
}

class MyToDoApp extends StatelessWidget {
  const MyToDoApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Todos'),
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextWidget(),
          ],
        ),
      ),
    );
  }
}

class TextWidget extends StatefulWidget {
  const TextWidget({Key? key}) : super(key: key);

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  List<String> toDoList = [];
  final fieldText = TextEditingController();
  bool _isCompleted = false;

  void _addValue(String value) {
    setState(() {
      toDoList.add(value);
    });
    fieldText.clear();
  }

  void _deleteItem(int idx) {
    setState(() {
      toDoList.removeAt(idx);
    });
  }

  void _toggleTask() {
    setState(() {
      _isCompleted = !_isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 250, vertical: 16),
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.pink,
                  width: 16.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 16.0,
                ),
              ),
              hintText: 'Enter your task!',
              filled: true,
              fillColor: Colors.grey[250],
            ),
            onSubmitted: _addValue,
            controller: fieldText,
          ),
        ),
        Center(
          child: Column(
            children: [
              // for (var i in toDoList)
              for (var i = 0; i < toDoList.length; i++)
                // TODO:
                // Widgetize this Widget
                // pass in the index number when creating one
                // use that index to complete the task/not
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListTile(
                    title: InkWell(
                      onTap: _toggleTask,
                      child: Text(
                        toDoList[i],
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.25,
                          decoration: _isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: _isCompleted
                              ? Colors.grey.shade400
                              : Colors.black,
                        ),
                      ),
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.border_color),
                      onPressed: () => print("EDIT!!!!!!"),
                      splashRadius: 20.0,
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => _deleteItem(i),
                      hoverColor: Colors.red.shade100.withOpacity(0.5),
                      splashRadius: 20.0,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
