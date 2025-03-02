import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_to_do/features/teams/creat_teams.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class Teams extends StatelessWidget {
  const Teams({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Teams'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.add_circle_outline),
              )
            ],
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight * 1.25),
            child: FloatingActionButton(
              onPressed: () {
                navigateTo(
                  context: context,
                  screen: CreatTeams(),
                );
              },
              child: Icon(Icons.add),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.separated(
              itemBuilder: (context, index) => Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueGrey.withValues(alpha: 0.6)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(cubit.myTeams[index].title),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(cubit.myTeams[index].description),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              'Edit',
                              style: TextStyle(color: Colors.blue),
                            )),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              'Remove',
                              style: TextStyle(color: Colors.red),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemCount: cubit.myTeams.length,
            ),
          ),
        );
      },
    );
  }
}
