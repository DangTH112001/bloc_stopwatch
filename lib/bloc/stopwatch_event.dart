part of 'stopwatch_bloc.dart';

abstract class StopwatchEvent {
  const StopwatchEvent();
}

class StopwatchStarted extends StopwatchEvent {
  final int time;
  final List<int> timeLap;
  const StopwatchStarted({required this.time, required this.timeLap});
}

class StopwatchPaused extends StopwatchEvent {}

class StopwatchResumed extends StopwatchEvent {}

class StopwatchReset extends StopwatchEvent {}

class StopwatchLapped extends StopwatchEvent {}

class StopwatchTicked extends StopwatchEvent {
  final int time;
  const StopwatchTicked({required this.time});
}
