import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class TodoListItem {
  String id;
  String title;
  bool isDone;
  DateTime startDate;
  DateTime? completionDate;
  String appUserId;
  abstract TodoListItemType type;

  TodoListItem(
      {required this.title,
      required this.appUserId,
      this.isDone = false,
      this.id = ''})
      : startDate = DateTime.now();

  static TodoListItem fromMap(Map<String, dynamic> json) {
    switch (TodoListItemTypeUtils.fromString(json['type'])) {
      case TodoListItemType.frequent:
        return FrequentTodoListItem.fromMap(json);
      case TodoListItemType.single:
        return SingleTodoListItem.fromMap(json);
      case TodoListItemType.bonus:
        return BonusTodoListItem.fromMap(json);
      default:
        throw Exception('Invalid type');
    }
  }

  TodoListItem._fromMap(Map<String, dynamic> json)
      : title = json['title'],
        isDone = json['isDone'],
        id = json['id'],
        appUserId = json['appUserId'],
        completionDate = json['completionDate'] != null
            ? DateTime.parse(json['completionDate'])
            : null,
        startDate = json['startDate'] != null
            ? DateTime.parse(json['startDate'])
            : DateTime.now();

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['title'] = title;
    data['isDone'] = isDone;
    data['id'] = id;
    data['appUserId'] = appUserId;
    data['type'] = type.toString();
    data['completionDate'] = completionDate?.toIso8601String();
    data['startDate'] = startDate.toIso8601String();
    return data;
  }

  void toggleTaskCompletion() {
    if (!isDone) {
      isDone = true;
      completionDate = DateTime.now();
    } else {
      isDone = false;
      completionDate = null;
    }
  }
}

class FrequentTodoListItem extends TodoListItem {
  @override
  TodoListItemType type = TodoListItemType.frequent;

  FrequentTodoListItem({required String title, required String appUserId})
      : super(title: title, appUserId: appUserId);

  FrequentTodoListItem.fromMap(Map<String, dynamic> json)
      : super._fromMap(json);
}

class SingleTodoListItem extends TodoListItem {
  @override
  TodoListItemType type = TodoListItemType.single;

  SingleTodoListItem({required String title, required String appUserId})
      : super(title: title, appUserId: appUserId);

  SingleTodoListItem.fromMap(Map<String, dynamic> json) : super._fromMap(json);
}

class BonusTodoListItem extends TodoListItem {
  @override
  TodoListItemType type = TodoListItemType.bonus;

  BonusTodoListItem({required String title, required String appUserId})
      : super(title: title, appUserId: appUserId) {
    toggleTaskCompletion();
  }

  BonusTodoListItem.fromMap(Map<String, dynamic> json) : super._fromMap(json);
}

enum TodoListItemType { frequent, single, bonus }

extension TodoListItemTypeUtils on TodoListItemType {
  static TodoListItemType fromString(String type) {
    switch (type) {
      case 'TodoListItemType.frequent':
        return TodoListItemType.frequent;
      case 'frequent':
        return TodoListItemType.frequent;
      case 'TodoListItemType.single':
        return TodoListItemType.single;
      case 'single':
        return TodoListItemType.single;
      case 'TodoListItemType.bonus':
        return TodoListItemType.bonus;
      case 'bonus':
        return TodoListItemType.bonus;
      default:
        throw Exception('Invalid type');
    }
  }

  String get name {
    switch (this) {
      case TodoListItemType.frequent:
        return 'Scheduled';
      case TodoListItemType.single:
        return 'Single';
      case TodoListItemType.bonus:
        return 'Bonus';
    }
  }

  Color get color {
    switch (this) {
      case TodoListItemType.frequent:
        return Colors.blue;
      case TodoListItemType.single:
        return Colors.brown;
      case TodoListItemType.bonus:
        return Colors.red;
    }
  }
}

abstract class Frequency {
  List<int> startingTimes = [];
  abstract FrequencyType type;

  Frequency({required this.startingTimes});

  DateTime getNextStartingTime();

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['type'] = type.toString();
    data['startingTimes'] = startingTimes;
    return data;
  }

  static Frequency fromMap(Map<String, dynamic> json) {
    switch (FrequencyTypeUtils.fromString(json['type'])) {
      case FrequencyType.daily:
        return DailyFrequency(startingTimes: json['startingTimes']);
      case FrequencyType.weekly:
        return WeeklyFrequency(startingTimes: json['startingTimes']);
      default:
        throw Exception('Invalid type');
    }
  }
}

class DailyFrequency extends Frequency {
  @override
  FrequencyType type = FrequencyType.daily;

  DailyFrequency({required List<int> startingTimes})
      : super(startingTimes: startingTimes);

  @override
  DateTime getNextStartingTime() {
    DateTime? nextStartingTime;
    DateTime now = DateTime.now();
    for (int startingTime in startingTimes) {
      if (now.hour < startingTime) {
        nextStartingTime = DateTime(now.year, now.month, now.day, startingTime);
        break;
      }
    }
    return nextStartingTime ??
        DateTime(now.year, now.month, now.day + 1, startingTimes.first);
  }
}

class WeeklyFrequency extends Frequency {
  @override
  FrequencyType type = FrequencyType.daily;

  WeeklyFrequency({required List<int> startingTimes})
      : super(startingTimes: startingTimes);

  @override
  DateTime getNextStartingTime() {
    DateTime? nextStartingTime;
    DateTime now = DateTime.now();
    for (int startingTime in startingTimes) {
      if (now.weekday < startingTime) {
        nextStartingTime =
            DateTime(now.year, now.month, getWeekStart(now) + startingTime);
        break;
      }
    }
    return nextStartingTime ??
        DateTime(
            now.year, now.month, getWeekStart(now) + 7 + startingTimes.first);
  }

  int getWeekStart(DateTime date) {
    return date.day - (date.weekday - 1);
  }
}

enum FrequencyType { daily, weekly }

extension FrequencyTypeUtils on FrequencyType {
  static FrequencyType fromString(String type) {
    switch (type) {
      case 'FrequencyType.daily':
        return FrequencyType.daily;
      case 'daily':
        return FrequencyType.daily;
      case 'FrequencyType.weekly':
        return FrequencyType.weekly;
      case 'weekly':
        return FrequencyType.weekly;
      default:
        throw Exception('Invalid type');
    }
  }
}
