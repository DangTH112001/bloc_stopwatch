part of 'stopwatch_bloc.dart';

abstract class StopwatchState {
  final int time;
  final List<int> timeLapList;
  StopwatchState({
    required this.time,
    required this.timeLapList,
  });
}

class StopwatchInitial extends StopwatchState {
  StopwatchInitial(int time, List<int> timeLapList)
      : super(time: time, timeLapList: timeLapList);
}

class StopwatchRunInProgress extends StopwatchState {
  StopwatchRunInProgress(int time, List<int> timeLapList)
      : super(time: time, timeLapList: timeLapList);
}

class StopwatchRunPause extends StopwatchState {
  StopwatchRunPause(int time, List<int> timeLapList)
      : super(time: time, timeLapList: timeLapList);
}
