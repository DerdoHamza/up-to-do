import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_to_do/features/add_task.dart';
import 'package:up_to_do/features/edit_task.dart';
import 'package:up_to_do/features/login.dart';
import 'package:up_to_do/services/cache_helper.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is ToDoSignOutSuccessState) {
          CacheHelper.removeCacheData(key: 'userId').then((value) {
            if (context.mounted) {
              navigateAndReplace(context: context, screen: Login());
            }
          });
        }
      },
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        return PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  cubit.signOut();
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
              ),
              title: Text(
                'Home Screen',
              ),
              centerTitle: true,
            ),
            floatingActionButton: Padding(
              padding:
                  EdgeInsets.only(bottom: kBottomNavigationBarHeight * 1.25),
              child: FloatingActionButton(
                onPressed: () {
                  navigateTo(
                    context: context,
                    screen: AddTask(),
                  );
                },
                child: Icon(Icons.add),
              ),
            ),
            body: cubit.allTasks.isEmpty
                ? Center(
                    child: Text('No Tasks'),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 8, bottom: 150),
                    child: Column(
                      children: [
                        CustomTextFormField(
                          onChange: (value) {
                            log(value);
                            cubit.search(text: value);
                          },
                          label: 'Search',
                          prefix: Icon(Icons.search),
                          type: TextInputType.text,
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) => TaskItem(
                              cubit: cubit,
                              task: cubit.searchTasks[index],
                              edit: () {
                                navigateTo(
                                  context: context,
                                  screen: EditTask(
                                    task: cubit.allTasks[index],
                                  ),
                                );
                              },
                              remove: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Center(child: Text('Remove task')),
                                    content: Text(
                                        'Are you sure to delete this task ?'),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 35.0),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            cubit.deleteTask(
                                                data: cubit.allTasks[index]);
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
                                            style:
                                                TextStyle(color: Colors.blue),
                                          )),
                                    ],
                                  ),
                                );
                              },
                            ),
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 8),
                            itemCount: cubit.searchTasks.length,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
