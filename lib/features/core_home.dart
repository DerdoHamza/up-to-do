import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:up_to_do/features/calendar.dart';
import 'package:up_to_do/features/home.dart';
import 'package:up_to_do/features/profile.dart';
import 'package:up_to_do/features/teams.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class CoreHome extends StatelessWidget {
  const CoreHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: PersistentTabView(
            context,
            screens: [
              Home(),
              Teams(),
              Calendar(),
              Profile(),
            ],
            items: [
              PersistentBottomNavBarItem(
                icon: Icon(CupertinoIcons.home),
                title: ("Home"),
                activeColorPrimary: CupertinoColors.activeBlue,
                inactiveColorPrimary: CupertinoColors.systemGrey,
              ),
              PersistentBottomNavBarItem(
                icon: Icon(CupertinoIcons.person_2_square_stack),
                title: ("Teams"),
                activeColorPrimary: CupertinoColors.activeBlue,
                inactiveColorPrimary: CupertinoColors.systemGrey,
              ),
              PersistentBottomNavBarItem(
                icon: Icon(CupertinoIcons.calendar),
                title: ("Calendar"),
                activeColorPrimary: CupertinoColors.activeBlue,
                inactiveColorPrimary: CupertinoColors.systemGrey,
              ),
              PersistentBottomNavBarItem(
                icon: Icon(CupertinoIcons.profile_circled),
                title: ("Profile"),
                activeColorPrimary: CupertinoColors.activeBlue,
                inactiveColorPrimary: CupertinoColors.systemGrey,
              ),
            ],
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: true,
            hideNavigationBarWhenKeyboardAppears: true,
            popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            backgroundColor: Colors.grey.shade900,
            isVisible: true,
            animationSettings: const NavBarAnimationSettings(
              navBarItemAnimation: ItemAnimationSettings(
                duration: Duration(milliseconds: 400),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: ScreenTransitionAnimationSettings(
                animateTabTransition: true,
                duration: Duration(milliseconds: 200),
                screenTransitionAnimationType:
                    ScreenTransitionAnimationType.fadeIn,
              ),
            ),
            confineToSafeArea: true,
            navBarHeight: kBottomNavigationBarHeight * 1.1,
            navBarStyle: NavBarStyle.style1,
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(30),
              colorBehindNavBar: Colors.transparent,
            ),
            margin: EdgeInsets.only(
              bottom: 10,
              left: 10,
              right: 10,
            ),
          ),
        );
      },
    );
  }
}
