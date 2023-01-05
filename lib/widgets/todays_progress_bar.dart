import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tame_the_beast/models/todo_list_item.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:tame_the_beast/theme.dart';

class TodaysProgressDisplay extends StatelessWidget {
  List<TodoListItem> items;
  TodaysProgressDisplay({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProgressBar(
            items: items
                .where(
                  (element) => element.type == TodoListItemType.frequent,
                )
                .toList()),
        SizedBox(
          height: min(200, MediaQuery.of(context).size.width / 3),
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    centerText: items
                            .where((element) =>
                                element.type == TodoListItemType.single &&
                                element.isDone)
                            .length
                            .toString() +
                        "/" +
                        items
                            .where((element) =>
                                element.type == TodoListItemType.single)
                            .length
                            .toString(),
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    dataMap: {
                      "Done": items
                          .where((element) =>
                              element.type == TodoListItemType.single &&
                              element.isDone)
                          .length
                          .toDouble(),
                      "Not Done": items
                          .where((element) =>
                              element.type == TodoListItemType.single &&
                              !element.isDone)
                          .length
                          .toDouble()
                    },
                    colorList: [
                      TTBTheme.singleTaskColor,
                      TTBTheme.transparentGrey
                    ],
                    legendOptions: const LegendOptions(showLegends: false),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValueBackground: false,
                      showChartValues: false,
                    ),
                  ),
                ),
                Expanded(
                  child: PieChart(
                    centerText: items
                            .where((element) =>
                                element.type == TodoListItemType.bonus &&
                                element.isDone)
                            .length
                            .toString() +
                        "/" +
                        items
                            .where((element) =>
                                element.type == TodoListItemType.bonus)
                            .length
                            .toString(),
                    chartType: ChartType.ring,
                    ringStrokeWidth: 30,
                    dataMap: {
                      "Done": items
                          .where((element) =>
                              element.type == TodoListItemType.bonus &&
                              element.isDone)
                          .length
                          .toDouble(),
                      "Not Done": items
                          .where((element) =>
                              element.type == TodoListItemType.bonus &&
                              !element.isDone)
                          .length
                          .toDouble()
                    },
                    colorList: [
                      TTBTheme.bonusTaskColor,
                      TTBTheme.transparentGrey
                    ],
                    legendOptions: const LegendOptions(showLegends: false),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValueBackground: false,
                      showChartValues: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProgressBar extends StatelessWidget {
  List<TodoListItem> items;

  ProgressBar({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<TodoListItemType, int> counts = {};
    for (TodoListItem item in items.where(
      (element) => element.isDone,
    )) {
      counts[item.type] = (counts[item.type] ?? 0) + 1;
    }
    bool first = true;
    List<Widget> children = [];
    for (TodoListItemType type in counts.keys) {
      bool last =
          type == counts.keys.where((element) => counts[element]! > 0).last &&
              items.where((element) => !element.isDone).isEmpty;
      if (counts[type]! > 0) {
        children.add(
          Expanded(
            flex: counts[type]!,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                    left: first ? Radius.circular(30) : Radius.zero,
                    right: last ? Radius.circular(30) : Radius.zero),
                color: type.color,
              ),
            ),
          ),
        );
        first = false;
      }
    }
    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...children,
          Expanded(
            flex: items.where((element) => !element.isDone).length,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                    left: first ? Radius.circular(30) : Radius.zero,
                    right: Radius.circular(30)),
                color: TTBTheme.transparentGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
