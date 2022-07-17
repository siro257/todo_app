import 'package:flutter/material.dart';

import 'Todo.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
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
                  color: Colors.amber,
                  width: 3.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.amber,
                  width: 5.0,
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
