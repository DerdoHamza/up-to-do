import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_to_do/features/change_email.dart';
import 'package:up_to_do/features/login.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is ToDoLogOutState) {
          navigateAndReplace(context: context, screen: Login());
        }
      },
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          cubit.picImage(user: cubit.user!);
                        },
                        child: CircleAvatar(
                          radius: 47,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            radius: 45,
                            child: Image(
                              image: NetworkImage(cubit.user!.image),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              cubit.user!.name,
                              style: GoogleFonts.adamina(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              cubit.user!.email,
                              style: GoogleFonts.adamina(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              cubit.user!.phone,
                              style: GoogleFonts.adamina(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                FilledButton(
                    onPressed: () {
                      navigateTo(
                        context: context,
                        screen: ChangeEmail(user: cubit.user!),
                      );
                    },
                    child: Text('Change My Email')),
                FilledButton(
                    onPressed: () {}, child: Text('Change My Password')),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CustomDivider(),
                ),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    cubit.logOut();
                  },
                  child: Text('Log Out'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
