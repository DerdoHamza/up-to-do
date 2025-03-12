import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_to_do/features/add_task.dart';
import 'package:up_to_do/features/all_teams.dart';
import 'package:up_to_do/features/teams/creat_teams.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class CoreHome extends StatelessWidget {
  const CoreHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is ToDoGetAllTeamsSuccessState) {
          navigateTo(context: context, screen: AllTeams());
        }
      },
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            actions: [
              if (cubit.currentIndex == 1)
                IconButton(
                    onPressed: () {
                      cubit.getAllTeams();
                    },
                    icon: Icon(Icons.add_circle_outline))
            ],
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.only(right: 10, left: 10, bottom: 10),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
            child: BottomNavigationBar(
              items: cubit.items,
              onTap: (value) {
                cubit.changeBottomNavBarIndex(index: value);
              },
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              backgroundColor: Colors.blueGrey,
              elevation: 5,
              selectedItemColor: const Color.fromARGB(255, 48, 10, 113),
              unselectedItemColor: Colors.white,
            ),
          ),
          floatingActionButton: cubit.currentIndex < 2
              ? FloatingActionButton(
                  onPressed: () {
                    if (cubit.currentIndex == 0) {
                      navigateTo(
                        context: context,
                        screen: AddTask(),
                      );
                    } else if (cubit.currentIndex == 1) {
                      navigateTo(
                        context: context,
                        screen: CreatTeams(),
                      );
                    }
                  },
                  child: Icon(Icons.add),
                )
              : Container(),
          body: cubit.screens[cubit.currentIndex],
        );
      },
    );
  }
}
