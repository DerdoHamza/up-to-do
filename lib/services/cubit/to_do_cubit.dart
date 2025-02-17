import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:up_to_do/models/task_model.dart';
import 'package:up_to_do/models/user_model.dart';
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
  List<TaskModel> allTasks = [];
  void addTask({
    required TaskModel data,
  }) {
    emit(ToDoAddTaskLoadingState());
    allTasks.add(data);
    emit(ToDoAddTaskSuccessState());
  }

  void editTask({
    required TaskModel data,
  }) {
    emit(ToDoEditTaskLoadingState());
    for (var element in allTasks) {
      if (element.id == data.id) {
        element.taskTitle = data.taskTitle;
        element.taskDecription = data.taskDecription;
      }
    }
    emit(ToDoEditTaskSuccessState());
  }

  void deleteTask({
    required TaskModel data,
  }) {
    emit(ToDoDeleteTaskLoadingState());
    allTasks = allTasks.where((element) => element.id != data.id).toList();
    emit(ToDoDeleteTaskSuccessState());
  }

  DateTime? selectedDate;
  void taskDate({
    DateTime? date,
  }) {
    selectedDate = date;
    emit(ToDoTaskDateState());
  }
}
