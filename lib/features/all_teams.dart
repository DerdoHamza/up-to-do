import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_to_do/models/get_team_model.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/constant.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class AllTeams extends StatelessWidget {
  const AllTeams({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is ToDoJoinTeamErrorState) {
          showToast(msg: state.error, backgroundColor: Colors.red);
        }
        if (state is ToDoGetMyJoinedTeamSuccessState) {
          ToDoCubit.get(context).teams = [
            ...ToDoCubit.get(context).myTeams,
            ...ToDoCubit.get(context).myJoinedTeam,
          ];
          showToast(msg: 'kkk', backgroundColor: Colors.green).then((vaue) {
            if (context.mounted) {
              Navigator.pop(context);
            }
          });
        }
      },
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('All teams'),
          ),
          body: cubit.allTeams.isEmpty
              ? Center(
                  child: Text('There is no any teams'),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) => AllTeamItem(
                      team: cubit.allTeams[index],
                      cubit: cubit,
                    ),
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: cubit.allTeams.length,
                  ),
                ),
        );
      },
    );
  }
}

class AllTeamItem extends StatelessWidget {
  const AllTeamItem({
    super.key,
    required this.team,
    required this.cubit,
  });
  final GetTeamModel team;
  final ToDoCubit cubit;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                team.title,
                style: GoogleFonts.adamina(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (team.leaderId == userId) Icon(Icons.vpn_key_outlined),
              if (team.leaderId != userId)
                TextButton(
                    onPressed: () {
                      cubit.joinTeam(teamId: team.id);
                    },
                    child: Text(
                      'Join',
                      style: GoogleFonts.adamina(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
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
        ],
      ),
    );
  }
}
