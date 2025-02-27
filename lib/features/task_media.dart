import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_to_do/features/pdf_viewer.dart';
import 'package:up_to_do/features/photo_viewer.dart';
import 'package:up_to_do/features/video_player.dart';
import 'package:up_to_do/models/get_tasks_media_model.dart';
import 'package:up_to_do/services/component.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';

class TaskMedia extends StatelessWidget {
  final int id;
  const TaskMedia({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is ToDoPicFileErrorState) {
          showToast(
            msg: state.error,
            backgroundColor: Colors.red,
          );
        }
        if (state is ToDoPicFileSuccessState) {
          showToast(
            msg: 'File added successfully',
            backgroundColor: Colors.green,
          );
        }
      },
      builder: (context, state) {
        var cubit = ToDoCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Media'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              cubit.picFile(id: id);
            },
            child: Icon(Icons.add),
          ),
          body: state is ToDoPicFileLoadingState ||
                  state is ToDoGetTasksMediLoadingState
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: cubit.tasksMedia.isEmpty
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        cubit.tasksMedia.isEmpty
                            ? Text('No Tasks Media')
                            : Expanded(
                                child: ListView.separated(
                                  itemBuilder: (context, index) => MediaItem(
                                    media: cubit.tasksMedia[index],
                                  ),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 10),
                                  itemCount: cubit.tasksMedia.length,
                                ),
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

class MediaItem extends StatelessWidget {
  const MediaItem({
    super.key,
    required this.media,
  });
  final GetTasksMediaModel media;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (['jpeg', 'jpg', 'png'].contains(media.extension)) {
          navigateTo(
            context: context,
            screen: PhotoViewer(url: media.path),
          );
        } else if (['mp4', 'avi', 'mkv'].contains(media.extension)) {
          navigateTo(
            context: context,
            screen: VideoPlayers(url: media.path),
          );
        } else if (['pdf'].contains(media.extension)) {
          navigateTo(
            context: context,
            screen: PdfViwer(url: media.path),
          );
        }
      },
      child: Card(
        elevation: 5,
        color: Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    media.fileName,
                    style: GoogleFonts.adamina(
                      fontSize: 16,
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    media.extension,
                    style: GoogleFonts.adamina(
                      fontSize: 16,
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
