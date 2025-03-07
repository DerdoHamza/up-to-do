import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_to_do/models/task_model.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/constant.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class AddTask extends StatelessWidget {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final int? teamId;
  AddTask({
    super.key,
    this.teamId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is ToDoGetAllTaskSuccessState) {
          if (teamId != null) {
            ToDoCubit.get(context).getTeamTasks(teamId: teamId!);
          }
          showToast(
            msg: 'Task added successfully',
            backgroundColor: Colors.green,
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Add Task'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: title,
                    label: 'Task title',
                    type: TextInputType.text,
                    prefix: Icon(Icons.add_task_outlined),
                  ),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    controller: description,
                    label: 'Task Description',
                    type: TextInputType.text,
                    lines: 5,
                    prefix: Icon(Icons.description_outlined),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        TaskModel data = TaskModel(
                          title: title.text,
                          description: description.text,
                          addedBy: userId!,
                          userId: userId!,
                          teamId: teamId,
                        );
                        cubit.addTask(data: data);
                      }
                    },
                    child: Text('Add Task'),
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
