import 'package:bloc_stopwatch/bloc/stopwatch_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StopwatchPage extends StatelessWidget {
  const StopwatchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Stopwatch')),
      body: Stack(
        children: [
          const Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 100),
                child: const StopwatchText(),
              ),
              const SizedBox(
                height: 20,
              ),
              const Actions(),
              const SizedBox(
                height: 20,
              ),
              const LapList(),
            ],
          ),
        ],
      ),
    );
  }
}

class LapList extends StatelessWidget {
  const LapList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StopwatchBloc, StopwatchState>(
      builder: (context, state) {
        return state.timeLapList.isEmpty
            ? Container()
            : Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                      child: Row(
                        children: const [
                          Flexible(
                            child: Center(
                              child: Text(
                                'Laps',
                                style: TextStyle(fontSize: 26),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Center(
                              child: Text(
                                'Time',
                                style: TextStyle(fontSize: 26),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Center(
                              child: Text(
                                'Total',
                                style: TextStyle(fontSize: 26),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.timeLapList.length,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: Center(
                                      child: Text(
                                        index.toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Center(
                                      child: Text(
                                        _toStopwatchFormat(
                                          state.timeLapList[index] -
                                              (index - 1 < 0
                                                  ? 0
                                                  : state
                                                      .timeLapList[index - 1]),
                                        ),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Center(
                                      child: Text(
                                        _toStopwatchFormat(
                                            state.timeLapList[index]),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }

  String _toStopwatchFormat(int time) {
    final seconds = (time % 60).toString().padLeft(2, '0');
    final minutes = ((time / 60).floor() % 60).toString().padLeft(2, '0');
    final hours = (time / 3600).floor().toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }
}

class Actions extends StatelessWidget {
  const Actions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StopwatchBloc, StopwatchState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (state is StopwatchInitial) ...[
                  FloatingActionButton(
                    onPressed: () => context.read<StopwatchBloc>().add(
                        StopwatchStarted(
                            time: state.time, timeLap: state.timeLapList)),
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.play_arrow),
                  ),
                  const Icon(Icons.flag),
                  const Icon(Icons.restore),
                ],
                if (state is StopwatchRunInProgress) ...[
                  FloatingActionButton(
                    onPressed: () =>
                        context.read<StopwatchBloc>().add(StopwatchPaused()),
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.pause),
                  ),
                  FloatingActionButton(
                    onPressed: () =>
                        context.read<StopwatchBloc>().add(StopwatchLapped()),
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.flag),
                  ),
                  FloatingActionButton(
                    onPressed: () =>
                        context.read<StopwatchBloc>().add(StopwatchReset()),
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.restore),
                  ),
                ],
                if (state is StopwatchRunPause) ...[
                  FloatingActionButton(
                    onPressed: () =>
                        context.read<StopwatchBloc>().add(StopwatchResumed()),
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.play_arrow),
                  ),
                  const Icon(Icons.flag),
                  FloatingActionButton(
                    onPressed: () =>
                        context.read<StopwatchBloc>().add(StopwatchReset()),
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.restore),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade500,
          ],
        ),
      ),
    );
  }
}

class StopwatchText extends StatelessWidget {
  const StopwatchText({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final int time = context.select((StopwatchBloc bloc) => bloc.state.time);
    //final miliseconds10 = (time % 100).toString().padLeft(2, '0');
    final seconds = (time % 60).toString().padLeft(2, '0');
    final minutes = ((time / 60).floor() % 60).toString().padLeft(2, '0');
    final hours = (time / 3600).floor().toString().padLeft(2, '0');

    return Text(
      '$hours:$minutes:$seconds',
      style: const TextStyle(fontSize: 50),
    );
  }
}
