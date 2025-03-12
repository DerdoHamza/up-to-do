import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_to_do/features/add_task.dart';
import 'package:up_to_do/features/edit_task.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/constant.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class TeamTasks extends StatelessWidget {
  final int teamId;
  final String leaderId;
  final String teamTitle;
  const TeamTasks({
    super.key,
    required this.teamId,
    required this.leaderId,
    required this.teamTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is ToDoGetAllTaskSuccessState) {
          ToDoCubit.get(context).getTeamTasks(teamId: teamId);
          showToast(msg: 'Task Done', backgroundColor: Colors.green);
        }
      },
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              title: Text('$teamTitle Team'),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios)),
            ),
            floatingActionButton: leaderId == userId
                ? FloatingActionButton(
                    onPressed: () {
                      navigateTo(
                          context: context,
                          screen: AddTask(
                            teamId: teamId,
                          ));
                    },
                    child: Icon(Icons.add),
                  )
                : Container(),
            body: cubit.teamTasks.isEmpty
                ? Center(
                    child: Text('There is no tasks'),
                  )
                : state is ToDoGetTeamTasksLoadingState
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.separated(
                            itemBuilder: (context, index) => TaskItem(
                                  cubit: cubit,
                                  task: cubit.teamTasks[index],
                                  teamTasks: true,
                                  edit: () {
                                    navigateTo(
                                      context: context,
                                      screen: EditTask(
                                        task: cubit.teamTasks[index],
                                        teamId: teamId,
                                      ),
                                    );
                                  },
                                  remove: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Center(
                                                  child: Text('Delete task')),
                                              content: Text(
                                                'Are you sure to delete this task?',
                                                textAlign: TextAlign.center,
                                              ),
                                              titleTextStyle:
                                                  GoogleFonts.adamina(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              contentPadding: EdgeInsets.only(
                                                  bottom: 5, top: 15),
                                              actionsAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      'Cancel',
                                                      style:
                                                          GoogleFonts.adamina(
                                                              color:
                                                                  Colors.blue),
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      ToDoCubit.get(context)
                                                          .deleteTask(
                                                              data: cubit
                                                                      .teamTasks[
                                                                  index]);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      'Delete',
                                                      style:
                                                          GoogleFonts.adamina(
                                                              color:
                                                                  Colors.red),
                                                    ))
                                              ],
                                            ));
                                  },
                                ),
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                            itemCount: cubit.teamTasks.length),
                      ));
      },
    );
  }
}
