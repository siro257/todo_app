import 'package:flutter/material.dart';

void main() {
  runApp(const MyToDoApp());
}

class MyToDoApp extends StatelessWidget {
  const MyToDoApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: MaterialApp(
        title: 'Todo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Todos'),
      ),
    );
  }
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
      body: ListView(
        children: const <Widget>[
          TextWidget(),
        ],
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
  final myFocusNode = FocusNode();

  @override
  void dispose() {
    fieldText.dispose();
    super.dispose();
  }

  void _addItem(String value) {
    setState(() {
      toDoList.add(value);
    });
    fieldText.clear();
    myFocusNode.requestFocus();
  }

  void _deleteItem(int idx) {
    setState(() {
      toDoList.removeAt(idx);
    });
  }

  void _editItem(int idx, String newTask) {
    setState(() {
      toDoList.removeAt(idx);
      toDoList.insert(idx, newTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          // padding: const EdgeInsets.symmetric(horizontal: 250, vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: TextField(
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.pink,
                  width: 8.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 8.0,
                ),
              ),
              hintText: 'Enter your task!',
              filled: true,
              fillColor: Colors.grey[250],
            ),
            onSubmitted: _addItem,
            controller: fieldText,
            focusNode: myFocusNode,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            toDoList.length <= 1
                ? "${toDoList.length} task"
                : "${toDoList.length} tasks",
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        const Divider(
          color: Colors.black45,
        ),
        for (var i = 0; i < toDoList.length; i++)
          Todo(
            id: i,
            task: toDoList[i],
            onDeleteTap: _deleteItem,
            onEditSubmit: _editItem,
          ),
      ],
    );
  }
}

class Todo extends StatefulWidget {
  const Todo(
      {Key? key,
      required this.id,
      required this.task,
      required this.onDeleteTap,
      required this.onEditSubmit})
      : super(key: key);
  final int id;
  final String task;
  final Function(int) onDeleteTap;
  final Function(int, String) onEditSubmit;

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  bool _isCompleted = false;
  bool _isEditing = false;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleItem() {
    setState(() {
      _isCompleted = !_isCompleted;
    });
  }

  void _toggleEdit() {
    if (!_isEditing) {
      _controller.text = widget.task;
    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
      child: ListTile(
        title: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          onTap: _toggleItem,
          child: _isEditing
              ? TextField(
                  onTap: () => _controller.selection = TextSelection(
                      baseOffset: _controller.text.length,
                      extentOffset: _controller.text.length),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[250],
                  ),
                  onSubmitted: (String val) {
                    widget.onEditSubmit(widget.id, val);
                    _toggleEdit();
                  },
                  controller: _controller,
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.task,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.25,
                      decoration: _isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: _isCompleted ? Colors.grey.shade400 : Colors.black,
                    ),
                  ),
                ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.border_color),
          onPressed: () => _toggleEdit(),
          splashRadius: 20.0,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => widget.onDeleteTap(widget.id),
          hoverColor: Colors.red.shade100.withOpacity(0.5),
          splashRadius: 20.0,
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
