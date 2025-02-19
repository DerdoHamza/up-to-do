import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:up_to_do/models/get_task_model.dart';
import 'package:up_to_do/models/task_model.dart';
import 'package:up_to_do/models/user_model.dart';
import 'package:up_to_do/services/constant.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class ToDoCubit extends Cubit<ToDoStates> {
  ToDoCubit(super.initialState);
  static ToDoCubit get(context) => BlocProvider.of(context);
  bool loginVisibility = false;
  void changeLoginVisibility() {
    loginVisibility = !loginVisibility;
    emit(ToDoLoginVisibilityState());
  }

  bool signUpVisibility = false;
  void changeSignUpVisibility() {
    signUpVisibility = !signUpVisibility;
    emit(ToDoSignUpVisibilityState());
  }

  void signUp({
    required UserModel user,
  }) {
    emit(ToDoSignUpLoadingState());
    Supabase.instance.client.auth
        .signUp(
      email: user.email.toLowerCase().trim(),
      password: user.password.trim(),
      data: user.toMap(),
    )
        .then((value) {
      emit(ToDoSignUpSuccessState());
    }).catchError((error) {
      emit(ToDoSignUpErrorState(error.message.toString()));
    });
  }

  void logIn({
    required String email,
    required String password,
  }) {
    emit(ToDoLogInLoadingState());
    Supabase.instance.client.auth
        .signInWithPassword(
      email: email.toLowerCase().trim(),
      password: password.trim(),
    )
        .then((value) {
      emit(ToDoLogInSuccessState(value.user!.id));
    }).catchError((error) {
      emit(ToDoLogInErrorState(error.message.toString()));
    });
  }

  void signOut() {
    emit(ToDoSignOutLoadingState());
    Supabase.instance.client.auth.signOut().then((value) {
      emit(ToDoSignOutSuccessState());
    }).catchError((error) {
      emit(ToDoSignOutErrorState(error.message.toString()));
    });
  }

  void forgetPassword({
    required String email,
  }) {
    emit(ToDoForgetPasswordLoadingState());
    Supabase.instance.client.auth.resetPasswordForEmail(email).then((value) {
      emit(ToDoForgetPasswordSuccessState());
    }).catchError((error) {
      emit(ToDoForgetPasswordErrorState(error.toString()));
    });
  }

  // Tasks Crud
  List<GetTaskModel> allTasks = [];
  void getAllTasks() {
    allTasks = [];
    emit(ToDoGetAllTaskLoadingState());
    Supabase.instance.client
        .from('tasks')
        .select('*')
        .eq('userId', userId!)
        .eq('active', true)
        .then((value) {
      for (var element in value) {
        allTasks.add(GetTaskModel.fromJson(element));
      }
      emit(ToDoGetAllTaskSuccessState());
    }).catchError((error) {
      emit(ToDoGetAllTaskErrorState(error.toString()));
    });
  }

  void addTask({
    required TaskModel data,
  }) {
    emit(ToDoAddTaskLoadingState());
    Supabase.instance.client
        .from('tasks')
        .insert(
          data.toMap(),
        )
        .then((value) {
      getAllTasks();
    }).catchError((error) {
      log(error.toString());
      emit(ToDoAddTaskErrorState(error.toString()));
    });
  }

  void editTask({
    required String title,
    required String description,
    required int id,
  }) {
    emit(ToDoEditTaskLoadingState());
    Supabase.instance.client
        .from('tasks')
        .update({
          'title': title,
          'description': description,
          'dateUpdated': DateTime.now().toIso8601String(),
          'updatedBy': userId,
        })
        .eq('id', id)
        .then((value) {
          getAllTasks();
        })
        .catchError((error) {
          emit(ToDoEditTaskErrorState(error.toString()));
        });
  }

  void deleteTask({
    required GetTaskModel data,
  }) {
    emit(ToDoDeleteTaskLoadingState());
    Supabase.instance.client
        .from('tasks')
        .update({
          'active': false,
          'dateUpdated': DateTime.now().toIso8601String(),
          'updatedBy': userId,
        })
        .eq(
          'id',
          data.id,
        )
        .then((value) {
          getAllTasks();
        })
        .catchError((error) {
          emit(ToDoDeleteTaskErrorState(error.toString()));
        });
  }

  DateTime? selectedDate;
  void taskDate({
    DateTime? date,
  }) {
    selectedDate = date;
    emit(ToDoTaskDateState());
  }
}
