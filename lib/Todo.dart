import 'package:flutter/material.dart';

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
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
          onTap: _toggleItem,
          child: _isEditing
              ? TextField(
                  onTap: () => _controller.selection = TextSelection(
                      baseOffset: _controller.text.length,
                      extentOffset: _controller.text.length),
                  autofocus: true,
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
                      fontSize: 28,
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
          icon: const Icon(
            Icons.highlight_remove,
          ),
          onPressed: () => widget.onDeleteTap(widget.id),
          highlightColor: Colors.red.shade200.withOpacity(0.5),
          splashColor: Colors.red.shade200.withOpacity(0.5),
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
