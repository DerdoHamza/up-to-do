import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_to_do/features/forget_password.dart';
import 'package:up_to_do/features/home.dart';
import 'package:up_to_do/features/sign_up.dart';
import 'package:up_to_do/services/cache_helper.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class Login extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is ToDoLogInErrorState) {
          showToast(
            msg: state.error,
            backgroundColor: Colors.red,
          );
        }
        if (state is ToDoLogInSuccessState) {
          showToast(
            msg: 'Wellcome name in Up To Do app',
            backgroundColor: Colors.green,
          ).then((value) {
            CacheHelper.saveCacheData(
              key: 'userId',
              value: state.userId,
            );
            if (context.mounted) {
              navigateAndReplace(context: context, screen: Home());
            }
          });
        }
      },
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/images/app_icon.png')),
                      Text(
                        'Up To Do',
                        style: GoogleFonts.adamina(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        controller: emailController,
                        label: 'Email',
                        type: TextInputType.emailAddress,
                        prefix: Icon(Icons.email_outlined),
                      ),
                      SizedBox(height: 16),
                      CustomTextFormField(
                        controller: passwordController,
                        label: 'Password',
                        type: TextInputType.visiblePassword,
                        prefix: Icon(Icons.lock_outline),
                        isvisible: cubit.loginVisibility,
                        sufix: IconButton(
                            onPressed: () {
                              cubit.changeLoginVisibility();
                            },
                            icon: cubit.loginVisibility
                                ? Icon(Icons.visibility_outlined)
                                : Icon(Icons.visibility_off_outlined)),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            navigateTo(
                              context: context,
                              screen: ForgetPassword(),
                            );
                          },
                          child: Text(
                            'Forget passwrd ?',
                            style: GoogleFonts.besley(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account ?',
                            style: GoogleFonts.besley(),
                          ),
                          Transform.translate(
                            offset: Offset(-5, 0),
                            child: TextButton(
                              onPressed: () {
                                navigateTo(
                                  context: context,
                                  screen: SignUp(),
                                );
                              },
                              child: Text(
                                'SignUp',
                                style: GoogleFonts.besley(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      state is ToDoLogInLoadingState
                          ? Center(child: CircularProgressIndicator())
                          : CustomElevatedButton(
                              onPress: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.logIn(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              color: Colors.indigoAccent,
                              text: 'LOGIN',
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
