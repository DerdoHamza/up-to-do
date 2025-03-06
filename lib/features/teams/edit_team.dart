import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_to_do/models/get_team_model.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/constant.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class EditTeam extends StatelessWidget {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final GetTeamModel team;
  EditTeam({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is ToDoGetMyJoinedTeamSuccessState) {
          showToast(
                  msg: 'Team edited successfully',
                  backgroundColor: Colors.green)
              .then((value) {
            if (context.mounted) {
              Navigator.pop(context);
            }
          });
        }
      },
      builder: (context, state) {
        titleController.text = team.title;
        descriptionController.text = team.description;
        var cubit = ToDoCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Team'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: titleController,
                    label: 'Team title',
                    type: TextInputType.text,
                    prefix: Icon(Icons.add_task_outlined),
                  ),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    controller: descriptionController,
                    label: 'Team Description',
                    type: TextInputType.text,
                    lines: 5,
                    prefix: Icon(Icons.description_outlined),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        team.title = titleController.text;
                        team.description = descriptionController.text;
                        team.dateUpdated = DateTime.now().toIso8601String();
                        team.updatedBy = userId!;
                        cubit.updateTeam(teamId: team.id, team: team);
                      }
                    },
                    child: Text('Edit Team'),
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
