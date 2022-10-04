import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tame_the_beast/auth_provider.dart';
import 'package:tame_the_beast/models/todo_list_item.dart';
import 'package:tame_the_beast/repositories/todo_list_item_repository.dart';
import 'package:weekday_selector/weekday_selector.dart';

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
  FrequencyType _frequency = FrequencyType.daily;
  List<int> frequencyList = [1];

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
          if (_type == TodoListItemType.frequent)
            Row(
              children: [
                for (var frequency in FrequencyType.values)
                  Expanded(
                    child: RadioListTile<FrequencyType>(
                      title: Text(frequency.name),
                      value: frequency,
                      groupValue: _frequency,
                      onChanged: (val) {
                        setState(() {
                          _frequency = val!;
                          frequencyList = [1];
                        });
                      },
                    ),
                  )
              ],
            ),
          if (_type == TodoListItemType.frequent &&
              _frequency == FrequencyType.weekly)
            WeekdaySelector(
                onChanged: (day) => setState(() {
                      if (frequencyList.contains(day)) {
                        if (frequencyList.length > 1) frequencyList.remove(day);
                      } else {
                        frequencyList.add(day);
                      }
                    }),
                values: [
                  frequencyList.contains(7),
                  frequencyList.contains(1),
                  frequencyList.contains(2),
                  frequencyList.contains(3),
                  frequencyList.contains(4),
                  frequencyList.contains(5),
                  frequencyList.contains(6),
                ]),
          if (_type == TodoListItemType.frequent &&
              _frequency == FrequencyType.daily)
            Container() // TODO Add time selection display
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
                  Frequency frequency = _frequency == FrequencyType.daily
                      ? DailyFrequency(startingTimes: frequencyList)
                      : WeeklyFrequency(startingTimes: frequencyList);
                  item = FrequentTodoListItem(
                    frequency: frequency,
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
