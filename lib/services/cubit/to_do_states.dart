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

class ToDoCreatTeamLoadingState extends ToDoStates {}

// class ToDoCreatTeamSuccessState extends ToDoStates {}

class ToDoCreatTeamErrorState extends ToDoStates {
  final String error;
  ToDoCreatTeamErrorState(this.error);
}

class ToDoUpdateTeamLoadingState extends ToDoStates {}

// class ToDoUpdateTeamSuccessState extends ToDoStates {}

class ToDoUpdateTeamErrorState extends ToDoStates {
  final String error;
  ToDoUpdateTeamErrorState(this.error);
}

class ToDoDeleteTeamLoadingState extends ToDoStates {}

// class ToDoDeleteTeamSuccessState extends ToDoStates {}

class ToDoDeleteTeamErrorState extends ToDoStates {
  final String error;
  ToDoDeleteTeamErrorState(this.error);
}

class ToDoGetMyTeamsLoadingState extends ToDoStates {}

class ToDoGetMyTeamsSuccessState extends ToDoStates {}

class ToDoGetMyTeamsErrorState extends ToDoStates {
  final String error;
  ToDoGetMyTeamsErrorState(this.error);
}

class ToDoGetAllMyTeamsLoadingState extends ToDoStates {}

class ToDoGetAllMyTeamsSuccessState extends ToDoStates {}

class ToDoGetAllMyTeamsErrorState extends ToDoStates {
  final String error;
  ToDoGetAllMyTeamsErrorState(this.error);
}

class ToDoGetTeamLoadingState extends ToDoStates {}

class ToDoGetTeamSuccessState extends ToDoStates {}

class ToDoGetTeamErrorState extends ToDoStates {
  final String error;
  ToDoGetTeamErrorState(this.error);
}

class ToDoAddTaskToTeamLoadingState extends ToDoStates {}

class ToDoAddTaskToTeamSuccessState extends ToDoStates {}

class ToDoAddTaskToTeamErrorState extends ToDoStates {
  final String error;
  ToDoAddTaskToTeamErrorState(this.error);
}

class ToDoGetTeamTasksLoadingState extends ToDoStates {}

class ToDoGetTeamTasksSuccessState extends ToDoStates {}

class ToDoGetTeamTasksErrorState extends ToDoStates {
  final String error;
  ToDoGetTeamTasksErrorState(this.error);
}

class ToDoJoinTeamLoadingState extends ToDoStates {}

class ToDoJoinTeamSuccessState extends ToDoStates {}

class ToDoJoinTeamErrorState extends ToDoStates {
  final String error;
  ToDoJoinTeamErrorState(this.error);
}

class ToDoLeaveTeamLoadingState extends ToDoStates {}

class ToDoLeaveTeamSuccessState extends ToDoStates {}

class ToDoLeaveTeamErrorState extends ToDoStates {
  final String error;
  ToDoLeaveTeamErrorState(this.error);
}

class ToDoLogOutState extends ToDoStates {}

class ToDoGetMyJoinedTeamLoadingState extends ToDoStates {}

class ToDoGetMyJoinedTeamSuccessState extends ToDoStates {
  final String? msg;
  ToDoGetMyJoinedTeamSuccessState(this.msg);
}

class ToDoGetMyJoinedTeamErrorState extends ToDoStates {
  final String error;
  ToDoGetMyJoinedTeamErrorState(this.error);
}

class ToDoGetAllTeamsLoadingState extends ToDoStates {}

class ToDoGetAllTeamsSuccessState extends ToDoStates {}

class ToDoGetAllTeamsErrorState extends ToDoStates {
  final String error;
  ToDoGetAllTeamsErrorState(this.error);
}

class ToDoChangeBottomNavBarIndexState extends ToDoStates {}

class ToDoUpdateUserEmailLoadingState extends ToDoStates {}

class ToDoUpdateUserEmailSuccessState extends ToDoStates {}

class ToDoUpdateUserEmailErrorState extends ToDoStates {
  final String error;
  ToDoUpdateUserEmailErrorState(this.error);
}

class ToDoUpdateUserPasswordLoadingState extends ToDoStates {}

class ToDoUpdateUserPasswordSuccessState extends ToDoStates {}

class ToDoUpdateUserPasswordErrorState extends ToDoStates {
  final String error;
  ToDoUpdateUserPasswordErrorState(this.error);
}

class ToDoUpdateUserInfoLoadingState extends ToDoStates {}

class ToDoUpdateUserInfoSuccessState extends ToDoStates {}

class ToDoUpdateUserInfoErrorState extends ToDoStates {
  final String error;
  ToDoUpdateUserInfoErrorState(this.error);
}

class ToDoGetUserDataLoadingState extends ToDoStates {}

class ToDoGetUserDataSuccessState extends ToDoStates {
  final String name;
  ToDoGetUserDataSuccessState(this.name);
}

class ToDoGetUserDataErrorState extends ToDoStates {
  final String error;
  ToDoGetUserDataErrorState(this.error);
}

class ToDoPicImageLoadingState extends ToDoStates {}

class ToDoPicImageSuccessState extends ToDoStates {}

class ToDoPicImageErrorState extends ToDoStates {
  final String error;
  ToDoPicImageErrorState(this.error);
}

class ToDoInFavoriteTaskLoadingState extends ToDoStates {}

class ToDoInFavoriteTaskSuccessState extends ToDoStates {}

class ToDoInFavoriteTaskErrorState extends ToDoStates {
  final String error;
  ToDoInFavoriteTaskErrorState(this.error);
}
