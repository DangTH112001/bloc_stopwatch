import 'package:bloc_stopwatch/bloc/stopwatch_bloc.dart';
import 'package:bloc_stopwatch/stopwatch/view/stopwatch_page.dart';
import 'package:bloc_stopwatch/ticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Timer',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(109, 234, 255, 1),
        colorScheme: const ColorScheme.light(
          secondary: Color.fromRGBO(72, 74, 126, 1),
        ),
      ),
      home: BlocProvider(
        create: (_) => StopwatchBloc(ticker: const Ticker()),
        child: const StopwatchPage(),
      ),
    );
  }
}
