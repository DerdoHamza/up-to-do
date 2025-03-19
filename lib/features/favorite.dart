import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_to_do/features/edit_task.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        return cubit.favorite.isEmpty
            ? Center(
                child: Text('There is no any favorite task'),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
                  itemBuilder: (context, index) => TaskItem(
                    cubit: cubit,
                    task: cubit.favorite[index],
                    edit: () {
                      navigateTo(
                        context: context,
                        screen: EditTask(
                          task: cubit.favorite[index],
                        ),
                      );
                    },
                    remove: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Center(child: Text('Remove task')),
                          content: Text('Are you sure to delete this task ?'),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 35.0),
                          actionsAlignment: MainAxisAlignment.spaceBetween,
                          actions: [
                            TextButton(
                                onPressed: () {
                                  cubit.deleteTask(data: cubit.allTasks[index]);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.blue),
                                )),
                          ],
                        ),
                      );
                    },
                  ),
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                  itemCount: cubit.favorite.length,
                ),
              );
      },
    );
  }
}
