import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:up_to_do/features/calendar.dart';
import 'package:up_to_do/features/favorite.dart';
import 'package:up_to_do/features/home.dart';
import 'package:up_to_do/features/profile.dart';
import 'package:up_to_do/features/teams.dart';
import 'package:up_to_do/models/add_tasks_media_model.dart';
import 'package:up_to_do/models/get_task_model.dart';
import 'package:up_to_do/models/get_tasks_media_model.dart';
import 'package:up_to_do/models/get_team_model.dart';
import 'package:up_to_do/models/task_model.dart';
import 'package:up_to_do/models/user_model.dart';
import 'package:up_to_do/services/cache_helper.dart';
import 'package:up_to_do/services/constant.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

import '../../models/add_team_model.dart';

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
      getUserData();
    }).catchError((error) {
      emit(ToDoLogInErrorState(error.message.toString()));
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

  List<GetTaskModel> allTasks = [];
  List<GetTaskModel> searchTasks = [];
  void getAllTasks() {
    allTasks = [];
    searchTasks = [];
    emit(ToDoGetAllTaskLoadingState());
    Supabase.instance.client
        .from('tasks')
        .select('*')
        .eq('userId', userId!)
        .eq('active', true)
        .isFilter('teamId', null)
        .then((value) {
      for (var element in value) {
        allTasks.add(GetTaskModel.fromJson(element));
        searchTasks.add(GetTaskModel.fromJson(element));
      }
      emit(ToDoGetAllTaskSuccessState());
    }).catchError((error) {
      emit(ToDoGetAllTaskErrorState(error.toString()));
    });
  }

  void search({
    required String text,
  }) {
    emit(ToDoSearchLoadingState());
    if (text.isNotEmpty) {
      searchTasks = allTasks.where((element) {
        return (element.title
            .toLowerCase()
            .trim()
            .contains(text.toLowerCase().trim()));
      }).toList();
    } else {
      getAllTasks();
    }
    emit(ToDoSearchSuccessState());
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
      emit(ToDoAddTaskErrorState(error.toString()));
    });
  }

  void editTask({
    required String title,
    required String description,
    required int id,
    int? teamId,
    String done = '',
  }) {
    emit(ToDoEditTaskLoadingState());
    Supabase.instance.client
        .from('tasks')
        .update({
          'title': title,
          'description': description,
          'dateUpdated': DateTime.now().toIso8601String(),
          'updatedBy': userId,
          'done': done,
        })
        .eq('id', id)
        .then((value) {
          if (teamId != null) {
            getTeamTasks(teamId: teamId);
          }
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
          getFavorite();
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

  void updateScheduled({
    required int id,
  }) {
    emit(ToDoUpdateScheduledLoadingState());
    Supabase.instance.client
        .from('tasks')
        .update({
          'scheduledNotification': selectedDate!.toIso8601String(),
          'updatedBy': userId,
          'dateUpdated': DateTime.now().toIso8601String(),
        })
        .eq('id', id)
        .then((value) {
          getAllTasks();
          emit(ToDoUpdateScheduledSuccessState());
        })
        .catchError((error) {
          ToDoUpdateScheduledErrorState(error.toString());
        });
  }

  void picFile({
    required int id,
  }) {
    emit(ToDoPicFileLoadingState());
    FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'jpeg',
        'jpg',
        'png',
        'pdf',
        'doc',
        'mp4',
        'avi',
        '3gp',
        'mkv',
      ],
    ).then((value) {
      if (value != null) {
        final file = File(value.files.first.path!);
        final fileName = value.files.first.name;
        AddTasksMediaModel media;
        Supabase.instance.client.storage
            .from('taskMedia')
            .upload(
              fileName,
              file,
            )
            .then((value) {
          final String url = Supabase.instance.client.storage
              .from('taskMedia')
              .getPublicUrl(fileName);
          final String extension = fileName.split('.').last;
          late String snapshotUrl;
          if (['mp4', 'avi', 'mkv'].contains(extension)) {
            VideoThumbnail.thumbnailData(
              video: url,
              imageFormat: ImageFormat.JPEG,
              maxWidth: 128,
              quality: 25,
            ).then((value) {
              Uint8List uint8list = value;
              Supabase.instance.client.storage
                  .from('taskMedia')
                  .uploadBinary(
                    'snapshot_$fileName',
                    uint8list,
                  )
                  .then((value) {
                snapshotUrl = Supabase.instance.client.storage
                    .from('taskMedia')
                    .getPublicUrl('snapshot_$fileName');

                media = AddTasksMediaModel(
                  fileName: fileName.split('.').first,
                  taskId: id,
                  extension: extension,
                  active: true,
                  dateAdded: DateTime.now().toIso8601String(),
                  addedBy: userId!,
                  dateUpdated: '',
                  updatedBy: userId!,
                  path: url,
                  snapshotUrl: snapshotUrl,
                );
                Supabase.instance.client
                    .from('tasks_media')
                    .insert(
                      media.toMap(),
                    )
                    .then((value) {
                  getTasksMedia(id: id);
                  emit(ToDoPicFileSuccessState());
                }).catchError((error) {
                  emit(ToDoPicFileErrorState(error.toString()));
                });
              });
            });
          } else {
            media = AddTasksMediaModel(
              fileName: fileName.split('.').first,
              taskId: id,
              extension: extension,
              active: true,
              dateAdded: DateTime.now().toIso8601String(),
              addedBy: userId!,
              dateUpdated: '',
              updatedBy: userId!,
              path: url,
              snapshotUrl: '',
            );
            Supabase.instance.client
                .from('tasks_media')
                .insert(
                  media.toMap(),
                )
                .then((value) {
              getTasksMedia(id: id);
              emit(ToDoPicFileSuccessState());
            }).catchError((error) {
              emit(ToDoPicFileErrorState(error.toString()));
            });
          }
        }).catchError((error) {
          emit(ToDoPicFileErrorState(error.toString()));
        });
      }
    }).catchError((error) {
      emit(ToDoPicFileErrorState(error.toString()));
    });
  }

  List<GetTasksMediaModel> tasksMedia = [];
  void getTasksMedia({
    required int id,
  }) {
    tasksMedia = [];
    emit(ToDoGetTasksMediLoadingState());
    Supabase.instance.client
        .from('tasks_media')
        .select('*')
        .eq('taskId', id)
        .eq('active', true)
        .then((value) {
      for (var element in value) {
        tasksMedia.add(GetTasksMediaModel.fromJson(element));
      }
      emit(ToDoGetTasksMediSuccessState());
    }).catchError((error) {
      emit(ToDoGetTasksMediErrorState(error.toString()));
    });
  }

  void deleteMediaFile({
    required int id,
    required int taskId,
  }) {
    emit(ToDoDeleteMediaFileLoadingState());
    Supabase.instance.client
        .from('tasks_media')
        .update({
          'active': false,
          'dateUpdated': DateTime.now().toIso8601String(),
          'updatedBy': userId,
        })
        .eq('id', id)
        .then((value) {
          emit(ToDoDeleteMediaFileSuccessState());
          getTasksMedia(id: taskId);
        })
        .catchError((error) {
          emit(ToDoDeleteMediaFileErrorState(error.toString()));
        });
  }

  List<GetTeamModel> teams = [];
  void createTeam({
    required AddTeamModel team,
  }) {
    teams = [];
    emit(ToDoCreatTeamLoadingState());
    Supabase.instance.client.from('teams').insert(team.toMap()).then((value) {
      getMyTeams();
      getMyJoinedTeam(msg: 'Team created successfully');
    }).catchError((error) {
      emit(ToDoCreatTeamErrorState(error.toString()));
    });
  }

  List<GetTeamModel> allTeams = [];
  void getAllTeams() {
    emit(ToDoGetAllTeamsLoadingState());
    allTeams = [];
    Supabase.instance.client
        .from('teams')
        .select('*')
        .eq('active', true)
        .then((value) {
      for (var element in value) {
        allTeams.add(GetTeamModel.fromJson(element));
      }

      emit(ToDoGetAllTeamsSuccessState());
    }).catchError((error) {
      emit(ToDoGetAllTeamsErrorState(error.toString()));
    });
  }

  void getAllMyTeams() {
    emit(ToDoGetAllMyTeamsLoadingState());
    getMyTeams();
    getMyJoinedTeam();
  }

  List<GetTeamModel> myTeams = [];
  void getMyTeams() {
    myTeams = [];
    emit(ToDoGetMyTeamsLoadingState());
    Supabase.instance.client
        .from('teams')
        .select('*')
        .eq('leaderId', userId!)
        .eq('active', true)
        .then((value) {
      for (var element in value) {
        myTeams.add(GetTeamModel.fromJson(element));
      }
      emit(ToDoGetMyTeamsSuccessState());
    }).catchError((error) {
      emit(ToDoGetMyTeamsErrorState(error.toString()));
    });
  }

  void updateTeam({
    required int teamId,
    required GetTeamModel team,
  }) {
    emit(ToDoUpdateTeamLoadingState());
    Supabase.instance.client
        .from('teams')
        .update(team.toMap())
        .eq('id', teamId)
        .eq('active', true)
        .then((value) {
      getMyTeams();
      getMyJoinedTeam(msg: 'Team edited successfully');
      // emit(ToDoUpdateTeamSuccessState());
    }).catchError((error) {
      emit(ToDoUpdateTeamErrorState(error.toString()));
    });
  }

  void removeTeam({
    required int teamId,
  }) {
    emit(ToDoDeleteTeamLoadingState());
    Supabase.instance.client
        .from('teams')
        .update(
          {
            'active': false,
            'dateUpdated': DateTime.now().toIso8601String(),
            'updatedBy': userId,
          },
        )
        .eq('id', teamId)
        .then((value) {
          getMyTeams();
          getMyJoinedTeam(msg: 'Team deleted successfully');
          // emit(ToDoDeleteTeamSuccessState());
        })
        .catchError((error) {
          emit(ToDoDeleteTeamErrorState(error.toString()));
        });
  }

  GetTeamModel? team;
  void getTeam({
    required int teamId,
  }) {
    emit(ToDoGetTeamLoadingState());
    Supabase.instance.client
        .from('teams')
        .select('*')
        .eq('id', teamId)
        .then((value) {
      team = GetTeamModel.fromJson(value.first);
      emit(ToDoGetTeamSuccessState());
    }).catchError((error) {
      emit(ToDoGetTeamErrorState(error.toString()));
    });
  }

  List<int> teamIds = [];
  List<GetTeamModel> myJoinedTeam = [];
  void getMyJoinedTeam({
    String? msg,
  }) {
    teamIds = [];
    myJoinedTeam = [];
    emit(ToDoGetMyJoinedTeamLoadingState());
    Supabase.instance.client
        .from('users_teams')
        .select('*')
        .eq('userId', userId!)
        .then((value) {
      for (var element in value) {
        teamIds.add(element['teamId']);
      }
      Supabase.instance.client
          .from('teams')
          .select('*')
          .inFilter('id', teamIds)
          .eq('active', true)
          .then((value) {
        for (var element in value) {
          myJoinedTeam.add(GetTeamModel.fromJson(element));
        }

        emit(ToDoGetMyJoinedTeamSuccessState(msg));
      }).catchError((error) {
        emit(ToDoGetMyJoinedTeamErrorState(error.toString()));
      });
    }).catchError((error) {
      log(error.toString());
      emit(ToDoGetMyJoinedTeamErrorState(error.toString()));
    });
  }

  void addTaskToTeam({
    required int teamId,
    required TaskModel task,
  }) {
    emit(ToDoAddTaskToTeamLoadingState());
    task.teamId = teamId;
    Supabase.instance.client.from('tasks').insert(task.toMap()).then((value) {
      emit(ToDoAddTaskToTeamSuccessState());
    }).catchError((error) {
      emit(ToDoAddTaskToTeamErrorState(error.toString()));
    });
  }

  List<GetTaskModel> teamTasks = [];
  void getTeamTasks({
    required int teamId,
  }) {
    emit(ToDoGetTeamTasksLoadingState());
    teamTasks = [];
    Supabase.instance.client
        .from('tasks')
        .select('*')
        .eq('teamId', teamId)
        .eq('active', true)
        .then((value) {
      for (var element in value) {
        teamTasks.add(GetTaskModel.fromJson(element));
      }
      emit(ToDoGetTeamTasksSuccessState());
    }).catchError((error) {
      emit(ToDoGetTeamTasksErrorState(error.toString()));
    });
  }

  void joinTeam({
    required int teamId,
  }) {
    emit(ToDoJoinTeamLoadingState());
    Supabase.instance.client
        .from('users_teams')
        .select('*')
        .eq('userId', userId!)
        .eq('teamId', teamId)
        .then((value) {
      if (value.isEmpty) {
        Supabase.instance.client.from('users_teams').insert({
          'userId': userId,
          'teamId': teamId,
        }).then((value) {
          getMyJoinedTeam(msg: 'You are joined team successfully');
          // getMyTeams();
        });
      } else {
        emit(ToDoJoinTeamErrorState('you already joined this team !'));
      }
    }).catchError((error) {
      emit(ToDoJoinTeamErrorState(error.toString()));
    });
  }

  void leaveTeam({
    required int teamId,
  }) {
    emit(ToDoLeaveTeamLoadingState());
    Supabase.instance.client
        .from('users_teams')
        .select()
        .eq('userId', userId!)
        .eq('teamId', teamId)
        .then((value) {
      if (value.isNotEmpty) {
        Supabase.instance.client
            .from('users_teams')
            .delete()
            .eq('userId', userId!)
            .eq('teamId', teamId)
            .then((value) {
          emit(ToDoLeaveTeamSuccessState());
        }).catchError((error) {
          emit(ToDoLeaveTeamErrorState(error.toString()));
        });
      }
    }).catchError((error) {
      emit(ToDoLeaveTeamErrorState('You are not a member of this team !'));
    });
  }

  void logOut() {
    CacheHelper.removeCacheData(key: 'userId');
    currentIndex = 0;
    emit(ToDoLogOutState());
  }

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.person_2_square_stack), label: 'Teams'),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.calendar), label: 'Calendar'),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.square_favorites_alt), label: 'Favorite'),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.profile_circled), label: 'Profile'),
  ];
  List<String> titles = [
    'Home Screen',
    'Teams',
    'Calendar',
    'Favorite',
    'Profile',
  ];
  List<Widget> screens = [
    Home(),
    Teams(),
    Calendar(),
    Favorite(),
    Profile(),
  ];
  int currentIndex = 0;
  void changeBottomNavBarIndex({required int index}) {
    currentIndex = index;
    emit(ToDoChangeBottomNavBarIndexState());
  }

  void updateUserEmail({
    required String email,
  }) {
    emit(ToDoUpdateUserEmailLoadingState());
    Supabase.instance.client.auth
        .updateUser(UserAttributes(
      email: email.toLowerCase().trim(),
    ))
        .then((value) {
      emit(ToDoUpdateUserEmailSuccessState());
    }).catchError((error) {
      log(error.toString());
      emit(ToDoUpdateUserEmailErrorState(error.toString()));
    });
  }

  void updateUserPassword({required String password}) {
    emit(ToDoUpdateUserPasswordLoadingState());
    Supabase.instance.client.auth
        .updateUser(UserAttributes(
      password: password,
    ))
        .then((value) {
      emit(ToDoUpdateUserPasswordSuccessState());
    }).catchError((error) {
      emit(ToDoUpdateUserPasswordErrorState(error.toString()));
    });
  }

  void updateUserInfo({
    required UserModel userInfo,
  }) {
    emit(ToDoUpdateUserInfoLoadingState());
    Supabase.instance.client.auth
        .updateUser(UserAttributes(
      data: userInfo.toMap(),
    ))
        .then((value) {
      getUserData();
      // emit(ToDoUpdateUserInfoSuccessState());
    }).catchError((error) {
      emit(ToDoUpdateUserInfoErrorState(error.toString()));
    });
  }

  UserModel? user;
  void getUserData() {
    emit(ToDoGetUserDataLoadingState());
    Supabase.instance.client.auth.getUser().then((value) {
      user = UserModel.fromJson(value.user!.userMetadata!);
      log(value.user!.userMetadata!.toString());
      emit(ToDoGetUserDataSuccessState(user!.name));
    }).catchError((error) {
      emit(ToDoGetUserDataErrorState(error.toString()));
    });
  }

  File? image;
  void picImage({
    required UserModel user,
  }) {
    emit(ToDoPicImageLoadingState());

    ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        image = File(value.path);
        Supabase.instance.client.storage
            .from('profile-images')
            .upload(
              Uri.file(image!.path).pathSegments.last,
              image!,
            )
            .then((value) {
          user.image = Supabase.instance.client.storage
              .from('profile-images')
              .getPublicUrl(Uri.file(image!.path).pathSegments.last);

          updateUserInfo(userInfo: user);
        });
      } else {
        image = null;
      }

      emit(ToDoPicImageSuccessState());
    }).catchError((error) {
      emit(ToDoPicImageErrorState(error.toString()));
    });
  }

  void inFavoriteTask({
    required GetTaskModel task,
  }) {
    emit(ToDoInFavoriteTaskLoadingState());
    Supabase.instance.client
        .from('tasks')
        .update({
          'isFavorite': !task.isFavorite,
          'dateUpdated': DateTime.now().toIso8601String(),
        })
        .eq('id', task.id)
        .then((value) {
          getFavorite();
          getAllTasks();
          // emit(ToDoInFavoriteTaskSuccessState());
        })
        .catchError((error) {
          emit(ToDoInFavoriteTaskErrorState(error.toString()));
        });
  }

  List<GetTaskModel> favorite = [];
  void getFavorite() {
    favorite = [];
    emit(ToDoGetFavoriteLoadingState());
    Supabase.instance.client
        .from('tasks')
        .select('*')
        .eq('userId', userId!)
        .eq('active', true)
        .isFilter('teamId', null)
        .eq('isFavorite', true)
        .then((value) {
      for (var element in value) {
        favorite.add(GetTaskModel.fromJson(element));
      }
      emit(ToDoGetFavoriteSuccessState());
    }).catchError((error) {
      emit(ToDoGetFavoriteErrorState(error.toString()));
    });
  }

  List<GetTaskModel> calendarTasks = [];
  void calendar() {
    calendarTasks = [];
    emit(ToDoCalendarTasksLoadingState());
    Supabase.instance.client
        .from('tasks')
        .select('*')
        .eq('userId', userId!)
        .eq('active', true)
        .isFilter('teamId', null)
        .neq('scheduledNotification', '')
        .then((value) {
      for (var element in value) {
        calendarTasks.add(GetTaskModel.fromJson(element));
      }
      emit(ToDoCalendarTasksSuccessState());
    }).catchError((error) {
      emit(ToDoCalendarTasksErrorState(error.toString()));
    });
  }

  DateTime? selectedDay;
  void dateSelected({
    required DateTime day,
  }) {
    selectedDay = day;
    emit(ToDoDateSelectedSuccessState());
  }
}
