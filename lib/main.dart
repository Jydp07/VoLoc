import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voloc/core/themes/app_theme.dart';
import 'package:voloc/views/screens/tab_screen.dart';
import 'logic/cubit/tab_index_cubit.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
          create: (context) => TabIndexCubit(),
          child: const TabScreen(),
        ),
        theme: theme,
        darkTheme: darkTheme,
        );
  }
}
