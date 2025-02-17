import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_to_do/features/login.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class ForgetPassword extends StatelessWidget {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is ToDoForgetPasswordSuccessState) {
          showToast(
            msg: 'Link has been sent succefully to yor email !!!',
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
          appBar: AppBar(
            title: Text('Reset password'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
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
                    prefix: Icon(Icons.email_outlined),
                    type: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  state is ToDoForgetPasswordLoadingState
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : CustomElevatedButton(
                          color: Colors.indigoAccent,
                          onPress: () {
                            if (formKey.currentState!.validate()) {
                              cubit.forgetPassword(
                                  email: emailController.text
                                      .toLowerCase()
                                      .trim());
                            }
                          },
                          text: 'Supmit',
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
