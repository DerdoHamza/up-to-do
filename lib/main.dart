import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:up_to_do/features/splash.dart';
import 'package:up_to_do/services/cache_helper.dart';
import 'package:up_to_do/services/cubit/bloc_observe.dart';
import 'package:up_to_do/services/cubit/to_do_cubit.dart';
import 'package:up_to_do/services/cubit/to_do_states.dart';
import 'package:up_to_do/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Future.wait([
    CacheHelper.init(),
    NotificationService.init(),
    Supabase.initialize(
      url: 'https://aywzdekqfwpwewosksty.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF5d3pkZWtxZndwd2V3b3Nrc3R5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk2OTYzODAsImV4cCI6MjA1NTI3MjM4MH0.1r6NIidaY5JwsfBOILoNNZzvIPHEAeJyIwCOtm35GGs',
    ),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoCubit(ToDoInitialState()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.dark,
        home: Splash(),
      ),
    );
  }
}
