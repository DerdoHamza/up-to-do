import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class TaskMedia extends StatelessWidget {
  final int id;
  const TaskMedia({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Media'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              cubit.picFile(id: id);
            },
            child: Icon(Icons.add),
          ),
          body: state is ToDoPicFileLoadingState
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: cubit.tasksMedia.isEmpty
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      cubit.tasksMedia.isEmpty
                          ? Text('No Tasks Media')
                          : Container(
                              child: Text(cubit.tasksMedia[0].fileName),
                            ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
