import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:up_to_do/models/get_task_model.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        return cubit.calendarTasks.isEmpty
            ? Center(child: Text('There is no tasks'))
            : Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.now().subtract(Duration(days: 1460)),
                    lastDay: DateTime.now().add(Duration(days: 1460)),
                    focusedDay: DateTime.now(),
                    onDayLongPressed: (selectedDay, focusedDay) =>
                        isSameDay(selectedDay, focusedDay),
                    eventLoader: (day) {
                      List<GetTaskModel> tasks = [];
                      for (var element in cubit.calendarTasks) {
                        DateTime evDate =
                            DateTime.parse(element.scheduledNotification)
                                .copyWith(
                          hour: 0,
                          minute: 0,
                          second: 0,
                          millisecond: 0,
                        );
                        if (isSameDay(evDate, day)) {
                          tasks.add(element);
                        }
                      }
                      return tasks;
                    },
                  ),
                  Center(
                    child: Text('Calendar'),
                  ),
                ],
              );
      },
    );
  }
}
