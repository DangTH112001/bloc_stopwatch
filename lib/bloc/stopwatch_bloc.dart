import 'dart:async';

import 'package:bloc_stopwatch/ticker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'stopwatch_event.dart';
part 'stopwatch_state.dart';

class StopwatchBloc extends Bloc<StopwatchEvent, StopwatchState> {
  final Ticker _ticker;
  static const int _initialTime = 0;
  StreamSubscription<int>? _stopwatchSubscription;

  StopwatchBloc({required Ticker ticker})
      : _ticker = ticker,
        super(StopwatchInitial(_initialTime, <int>[])) {
    on<StopwatchStarted>(_onStarted);
    on<StopwatchPaused>(_onPaused);
    on<StopwatchResumed>(_onResumed);
    on<StopwatchReset>(_onReset);
    on<StopwatchTicked>(_onTicked);
    on<StopwatchLapped>(_onLapped);
  }

  @override
  Future<void> close() {
    _stopwatchSubscription?.cancel();
    return super.close();
  }

  void _onStarted(StopwatchStarted event, Emitter<StopwatchState> emit) {
    emit(StopwatchRunInProgress(event.time, event.timeLap));
    _stopwatchSubscription?.cancel();
    _stopwatchSubscription = _ticker
        .tick(time: event.time)
        .listen((time) => add(StopwatchTicked(time: time)));
  }

  void _onPaused(StopwatchPaused event, Emitter<StopwatchState> emit) {
    if (state is StopwatchRunInProgress) {
      _stopwatchSubscription?.pause();
      emit(StopwatchRunPause(state.time, state.timeLapList));
    }
  }

  void _onResumed(StopwatchResumed event, Emitter<StopwatchState> emit) {
    if (state is StopwatchRunPause) {
      _stopwatchSubscription?.resume();
      emit(StopwatchRunInProgress(state.time, state.timeLapList));
    }
  }

  void _onReset(StopwatchReset event, Emitter<StopwatchState> emit) {
    if (state is StopwatchRunInProgress || state is StopwatchRunPause) {
      _stopwatchSubscription?.cancel();
      emit(StopwatchInitial(_initialTime, <int>[]));
    }
  }

  void _onLapped(StopwatchLapped event, Emitter<StopwatchState> emit) {
    if (state is StopwatchRunInProgress) {
      state.timeLapList.add(state.time);
      emit(StopwatchRunInProgress(
        state.time,
        state.timeLapList,
      ));
    }
  }

  void _onTicked(StopwatchTicked event, Emitter<StopwatchState> emit) {
    emit(StopwatchRunInProgress(event.time, state.timeLapList));
  }
}
