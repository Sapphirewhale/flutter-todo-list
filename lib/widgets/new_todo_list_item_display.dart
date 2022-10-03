import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tame_the_beast/auth_provider.dart';
import 'package:tame_the_beast/models/todo_list_item.dart';
import 'package:tame_the_beast/repositories/todo_list_item_repository.dart';

class NewTodoListItemDisplay extends StatefulWidget {
  TodoListItemType initialType;
  NewTodoListItemDisplay({required this.initialType, Key? key})
      : super(key: key);

  @override
  State<NewTodoListItemDisplay> createState() => _NewTodoListItemDisplayState();
}

class _NewTodoListItemDisplayState extends State<NewTodoListItemDisplay> {
  final TextEditingController _controller = TextEditingController();
  TodoListItemType _type = TodoListItemType.frequent;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Todo List Item'),
      content: Column(
        children: [
          Row(
            children: [
              for (var type in TodoListItemType.values)
                Expanded(
                  child: RadioListTile<TodoListItemType>(
                    title: Text(type.name),
                    value: type,
                    groupValue: _type,
                    onChanged: (val) {
                      setState(() {
                        _type = val!;
                      });
                    },
                  ),
                )
            ],
          ),
          TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter a title'),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        TextButton(
            onPressed: () {
              TodoListItem item;
              switch (_type) {
                case TodoListItemType.frequent:
                  item = FrequentTodoListItem(
                    title: _controller.text,
                    appUserId: Get.find<AuthProvider>().getUserId(),
                  );
                  break;
                case TodoListItemType.single:
                  item = SingleTodoListItem(
                    title: _controller.text,
                    appUserId: Get.find<AuthProvider>().getUserId(),
                  );
                  break;
                case TodoListItemType.bonus:
                  item = BonusTodoListItem(
                    title: _controller.text,
                    appUserId: Get.find<AuthProvider>().getUserId(),
                  );
                  break;
              }

              Get.find<TodoListItemRepository>().saveItem(item);
              Navigator.pop(context);
            },
            child: Text('Save')),
      ],
    );
  }
}
