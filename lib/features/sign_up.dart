import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_to_do/features/login.dart';
import 'package:up_to_do/models/user_model.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class SignUp extends StatelessWidget {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is ToDoSignUpErrorState) {
          showToast(
            msg: state.error,
            backgroundColor: Colors.red,
          );
        }
        if (state is ToDoSignUpSuccessState) {
          showToast(
            msg: 'SignUp done successfully',
            backgroundColor: Colors.green,
          ).then((value) {
            if (context.mounted) {
              Navigator.pop(context);
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
                        controller: nameController,
                        label: 'Name',
                        type: TextInputType.name,
                        prefix: Icon(Icons.person_2_outlined),
                      ),
                      SizedBox(height: 16),
                      CustomTextFormField(
                        controller: phoneController,
                        label: 'Phone',
                        type: TextInputType.phone,
                        prefix: Icon(Icons.call_outlined),
                      ),
                      SizedBox(height: 16),
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
                        isvisible: cubit.signUpVisibility,
                        sufix: IconButton(
                            onPressed: () {
                              cubit.changeSignUpVisibility();
                            },
                            icon: cubit.signUpVisibility
                                ? Icon(Icons.visibility_outlined)
                                : Icon(Icons.visibility_off_outlined)),
                      ),
                      SizedBox(height: 16),
                      CustomTextFormField(
                        controller: confirmPasswordController,
                        label: 'Confirm Password',
                        type: TextInputType.visiblePassword,
                        prefix: Icon(Icons.lock_outline),
                        isvisible: cubit.signUpVisibility,
                        sufix: IconButton(
                            onPressed: () {
                              cubit.changeSignUpVisibility();
                            },
                            icon: cubit.signUpVisibility
                                ? Icon(Icons.visibility_outlined)
                                : Icon(Icons.visibility_off_outlined)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Allready have an account ?',
                            style: GoogleFonts.besley(),
                          ),
                          Transform.translate(
                            offset: Offset(-5, 0),
                            child: TextButton(
                              onPressed: () {
                                navigateTo(context: context, screen: Login());
                              },
                              child: Text(
                                'Login',
                                style: GoogleFonts.besley(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      state is ToDoSignUpLoadingState
                          ? Center(child: CircularProgressIndicator())
                          : CustomElevatedButton(
                              onPress: () {
                                if (formKey.currentState!.validate()) {
                                  if (passwordController.text.trim() !=
                                      confirmPasswordController.text.trim()) {
                                    showToast(
                                      msg:
                                          'Password field not equal confirm password field',
                                      backgroundColor: Colors.red,
                                    );
                                  } else {
                                    UserModel user = UserModel(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      image: 'assets/images/app_icon.png',
                                    );
                                    cubit.signUp(user: user);
                                  }
                                }
                              },
                              color: Colors.indigoAccent,
                              text: 'SIGN UP',
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
