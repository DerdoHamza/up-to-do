import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_to_do/models/get_task_model.dart';
import 'package:up_to_do/models/task_model.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class EditTask extends StatelessWidget {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final GetTaskModel task;
  EditTask({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is ToDoGetAllTaskSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        title.text = task.title;
        description.text = task.description;
        var cubit = ToDoCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Task'),
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
                        cubit.editTask(
                            title: title.text,
                            description: description.text,
                            id: task.id);
                      }
                    },
                    child: Text('Edit Task'),
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
