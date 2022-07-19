import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'todo.dart';

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
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: kDefaultPadding,
                right: kDefaultPadding,
                bottom: 36 + kDefaultPadding,
              ),
              height: size.height * 0.2 - 27,
              decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36))),
              child: Row(
                children: [
                  Text(
                    "Hi James",
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Spacer(),
                  Text(
                    _todoList.length <= 1
                        ? "${_todoList.length} task"
                        : "${_todoList.length} tasks",
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Container(
                alignment: Alignment.center,
                height: 54,
                margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter some text";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Enter your task!',
                  ),
                  onFieldSubmitted: _addItem,
                  controller: fieldText,
                  focusNode: myFocusNode,
                ),
              ),
            ),
          ],
        ),
        // actual todo lists
        Expanded(
          child: ListView(
            children: [
              for (var i = 0; i < _todoList.length; i++)
                Todo(
                  id: i,
                  task: _todoList[i],
                  onDeleteTap: _deleteItem,
                  onEditSubmit: _editItem,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
