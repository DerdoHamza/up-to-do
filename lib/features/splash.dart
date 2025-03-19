import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_to_do/features/core_home.dart';
import 'package:up_to_do/features/login.dart';
import 'package:up_to_do/services/cache_helper.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/constant.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    navigation();
    super.initState();
  }

  late Widget start;
  void navigation() {
    userId = CacheHelper.getCacheData(key: 'userId');

    if (userId != null) {
      ToDoCubit.get(context).getUserData();
      ToDoCubit.get(context).getFavorite();
      ToDoCubit.get(context).getAllTasks();
      ToDoCubit.get(context).getAllMyTeams();

      start = CoreHome();
    } else {
      start = Login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is ToDoGetUserDataSuccessState) {
          showToast(
            msg: 'Wellcome ${state.name} in Up To Do App',
            backgroundColor: Colors.green,
          );
        }
        if (state is ToDoGetMyJoinedTeamSuccessState) {
          Future.delayed(Duration(seconds: 2), () {
            if (context.mounted) {
              ToDoCubit.get(context).teams = [
                ...ToDoCubit.get(context).myTeams,
                ...ToDoCubit.get(context).myJoinedTeam,
              ];
              return navigateAndReplace(
                context: context,
                screen: start,
              );
            }
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(image: AssetImage('assets/images/app_icon.png')),
                Text(
                  'Up To Do',
                  style: GoogleFonts.adamina(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
