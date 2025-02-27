import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_to_do/features/core_home.dart';
import 'package:up_to_do/features/login.dart';
import 'package:up_to_do/services/cache_helper.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/constant.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 3),
      () {
        if (mounted) {
          navigateAndReplace(
            context: context,
            screen: navigation(),
          );
        }
      },
    );
    super.initState();
  }

  Widget navigation() {
    userId = CacheHelper.getCacheData(key: 'userId');
    Widget start;
    if (userId != null) {
      ToDoCubit.get(context).getAllTasks();
      start = CoreHome();
    } else {
      start = Login();
    }
    return start;
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
