abstract class ToDoStates {}

class ToDoInitialState extends ToDoStates {}

class ToDoLoginVisibilityState extends ToDoStates {}

class ToDoSignUpVisibilityState extends ToDoStates {}

class ToDoSignUpLoadingState extends ToDoStates {}

class ToDoSignUpSuccessState extends ToDoStates {}

class ToDoSignUpErrorState extends ToDoStates {
  final String error;
  ToDoSignUpErrorState(this.error);
}

class ToDoLogInLoadingState extends ToDoStates {}

class ToDoLogInSuccessState extends ToDoStates {
  final String userId;
  ToDoLogInSuccessState(this.userId);
}

class ToDoLogInErrorState extends ToDoStates {
  final String error;
  ToDoLogInErrorState(this.error);
}

class ToDoSignOutLoadingState extends ToDoStates {}

class ToDoSignOutSuccessState extends ToDoStates {}

class ToDoSignOutErrorState extends ToDoStates {
  final String error;
  ToDoSignOutErrorState(this.error);
}

class ToDoForgetPasswordLoadingState extends ToDoStates {}

class ToDoForgetPasswordSuccessState extends ToDoStates {}

class ToDoForgetPasswordErrorState extends ToDoStates {
  final String error;
  ToDoForgetPasswordErrorState(this.error);
}

class ToDoGetAllTaskLoadingState extends ToDoStates {}

class ToDoGetAllTaskSuccessState extends ToDoStates {}

class ToDoGetAllTaskErrorState extends ToDoStates {
  final String error;
  ToDoGetAllTaskErrorState(this.error);
}

class ToDoSearchLoadingState extends ToDoStates {}

class ToDoSearchSuccessState extends ToDoStates {}

class ToDoSearchErrorState extends ToDoStates {
  final String error;
  ToDoSearchErrorState(this.error);
}

class ToDoAddTaskLoadingState extends ToDoStates {}

class ToDoAddTaskSuccessState extends ToDoStates {}

class ToDoAddTaskErrorState extends ToDoStates {
  final String error;
  ToDoAddTaskErrorState(this.error);
}

class ToDoEditTaskLoadingState extends ToDoStates {}

class ToDoEditTaskErrorState extends ToDoStates {
  final String error;
  ToDoEditTaskErrorState(this.error);
}

class ToDoDeleteTaskLoadingState extends ToDoStates {}

class ToDoDeleteTaskErrorState extends ToDoStates {
  final String error;
  ToDoDeleteTaskErrorState(this.error);
}

class ToDoUpdateScheduledLoadingState extends ToDoStates {}

class ToDoUpdateScheduledSuccessState extends ToDoStates {}

class ToDoUpdateScheduledErrorState extends ToDoStates {
  final String error;
  ToDoUpdateScheduledErrorState(this.error);
}

class ToDoPicFileLoadingState extends ToDoStates {}

class ToDoPicFileSuccessState extends ToDoStates {}

class ToDoPicFileErrorState extends ToDoStates {
  final String error;
  ToDoPicFileErrorState(this.error);
}

class ToDoTaskDateState extends ToDoStates {}

class ToDoGetTasksMediLoadingState extends ToDoStates {}

class ToDoGetTasksMediSuccessState extends ToDoStates {}

class ToDoGetTasksMediErrorState extends ToDoStates {
  final String error;
  ToDoGetTasksMediErrorState(this.error);
}

class ToDoDeleteMediaFileLoadingState extends ToDoStates {}

class ToDoDeleteMediaFileSuccessState extends ToDoStates {}

class ToDoDeleteMediaFileErrorState extends ToDoStates {
  final String error;
  ToDoDeleteMediaFileErrorState(this.error);
}
