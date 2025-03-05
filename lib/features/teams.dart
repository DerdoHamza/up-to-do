import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_to_do/features/teams/creat_teams.dart';
import 'package:up_to_do/features/teams/edit_team.dart';
import 'package:up_to_do/models/get_team_model.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/constant.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class Teams extends StatelessWidget {
  const Teams({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is ToDoGetMyJoinedTeamSuccessState) {
          showToast(
                  msg: 'Team deleted successfully',
                  backgroundColor: Colors.green)
              .then((vaue) {
            ToDoCubit.get(context).teams = [
              ...ToDoCubit.get(context).myTeams,
              ...ToDoCubit.get(context).myJoinedTeam,
            ];
          });
        }
      },
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        ToDoCubit.get(context).teams = [
          ...ToDoCubit.get(context).myTeams,
          ...ToDoCubit.get(context).myJoinedTeam,
        ];
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
          body: cubit.teams.isEmpty
              ? Center(
                  child: Text('There is no any teams'),
                )
              : state is ToDoDeleteTeamLoadingState
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.separated(
                        itemBuilder: (context, index) => TeamItem(
                          team: cubit.teams[index],
                        ),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemCount: cubit.teams.length,
                      ),
                    ),
        );
      },
    );
  }
}

class TeamItem extends StatelessWidget {
  const TeamItem({
    super.key,
    required this.team,
  });
  final GetTeamModel team;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blueGrey.withValues(alpha: 0.6)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(team.title,
                  style: GoogleFonts.adamina(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text(team.description,
                  style: GoogleFonts.adamina(
                    fontSize: 14,
                  )),
            ],
          ),
          if (team.leaderId == userId) Divider(),
          if (team.leaderId == userId)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      navigateTo(
                          context: context,
                          screen: EditTeam(
                            team: team,
                          ));
                    },
                    child: Text(
                      'Edit',
                      style: TextStyle(color: Colors.blue),
                    )),
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Center(child: Text('Delete team')),
                                content: Text(
                                  'Are you sure to delete this team?',
                                  textAlign: TextAlign.center,
                                ),
                                titleTextStyle: GoogleFonts.adamina(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                contentPadding:
                                    EdgeInsets.only(bottom: 5, top: 15),
                                actionsAlignment:
                                    MainAxisAlignment.spaceBetween,
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.adamina(
                                            color: Colors.blue),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        ToDoCubit.get(context)
                                            .removeTeam(teamId: team.id);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Delete',
                                        style: GoogleFonts.adamina(
                                            color: Colors.red),
                                      ))
                                ],
                              ));
                    },
                    child: Text(
                      'Remove',
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ),
        ],
      ),
    );
  }
}
