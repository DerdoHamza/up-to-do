import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_to_do/models/user_model.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class ChangePassword extends StatelessWidget {
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final UserModel user;
  ChangePassword({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is ToDoGetUserDataSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Change Password'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: passwordController,
                    label: 'New Password',
                    prefix: Icon(Icons.lock_outline),
                    type: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 20),
                  state is ToDoUpdateUserInfoLoadingState
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : FilledButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              user.password = passwordController.text;
                              cubit.updateUserPassword(
                                  password: passwordController.text);
                              cubit.updateUserInfo(userInfo: user);
                            }
                          },
                          child: Text('Update Password'),
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
