import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Todo.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final myFocusNode = FocusNode();
  final fieldText = TextEditingController();

  List<String> _todoList = [];

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    getTodoList();
  }

  @override
  void dispose() {
    fieldText.dispose();
    super.dispose();
  }

  void _addItem(String value) {
    if (value.isEmpty || value.trim() == '') {
      return;
    }

    setState(() {
      _todoList.add(value.trim());
    });
    saveTodoList(_todoList);
    fieldText.clear();
    myFocusNode.requestFocus();
  }

  void _deleteItem(int idx) {
    setState(() {
      _todoList.removeAt(idx);
    });
    saveTodoList(_todoList);
  }

  void _editItem(int idx, String newTask) {
    setState(() {
      _todoList.removeAt(idx);
      _todoList.insert(idx, newTask);
    });
    saveTodoList(_todoList);
  }

  void saveTodoList(List<String> todoList) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList("todoList", todoList);
  }

  void getTodoList() async {
    prefs = await SharedPreferences.getInstance();
    List<String>? todoList = prefs.getStringList("todoList");
    setState(() {
      _todoList = todoList!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          // padding: const EdgeInsets.symmetric(horizontal: 250, vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Enter some text";
              }
              return null;
            },
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: 3.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: 5.0,
                ),
              ),
              hintText: 'Enter your task!',
              filled: true,
              fillColor: Colors.grey[250],
            ),
            onFieldSubmitted: _addItem,
            controller: fieldText,
            focusNode: myFocusNode,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            _todoList.length <= 1
                ? "${_todoList.length} task"
                : "${_todoList.length} tasks",
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        const Divider(
          color: Colors.black45,
        ),
        for (var i = 0; i < _todoList.length; i++)
          Todo(
            id: i,
            task: _todoList[i],
            onDeleteTap: _deleteItem,
            onEditSubmit: _editItem,
          ),
      ],
    );
  }
}
