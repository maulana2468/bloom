import 'package:bloom/features/pomodoro/data/models/pomodoro_model.dart';
import 'package:bloom/features/pomodoro/presentation/bloc/timer/timer_bloc.dart';
import 'package:bloom/features/pomodoro/presentation/widgets/timer_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../bloc/timer/ticker.dart';
import '../widgets/exit_dialog.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as PomodoroModel;

    return BlocProvider(
      create: (context) =>
          TimerBloc(ticker: const Ticker())..add(TimerSet(data)),
      child: Scaffold(
        backgroundColor: yellowLight,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              BackMenu(data: data),
              SizedBox(height: getHeight(16, context)),
              Center(child: Text(data.title, style: mainSubTitle)),
              SizedBox(height: getHeight(4, context)),
              Center(
                child: SessionDisplay(data: data),
              ),
              SizedBox(height: getHeight(48, context)),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 293,
                      height: 293,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: yellowDark,
                      ),
                    ),
                    TimerCircle(earlyTime: data.durationMinutes),
                    Positioned(
                      left: 293 / 2 - 6,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: naturalWhite,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 2),
                              blurRadius: 7,
                              color: Colors.black.withOpacity(0.25),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: getHeight(40, context)),
              Center(
                child: BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      if (state is TimerInitial) {
                        context.read<TimerBloc>().add(
                              TimerStarted(
                                state.duration,
                                state.session,
                              ),
                            );
                      } else if (state is TimerRunInProgress) {
                        context.read<TimerBloc>().add(const TimerPaused());
                      } else if (state is TimerRunPause) {
                        context.read<TimerBloc>().add(const TimerResumed());
                      } else if (state is TimerRunComplete) {
                        if (state.isCompleted && state.session < data.session) {
                          context.read<TimerBloc>().add(TimerSet(data));
                          // context.read<TimerBloc>().add(
                          //       TimerStarted(
                          //         state.duration,
                          //         state.session,
                          //       ),
                          //     );
                        }
                      }
                    },
                    child: Container(
                      width: (state.isCompleted) ? 120 : 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            (state.isCompleted && state.session == data.session)
                                ? yellowLight
                                : naturalBlack,
                      ),
                      child: Center(
                        child: state.isRunning
                            ? Image.asset(
                                "assets/icons/pause.png",
                                width: 32,
                              )
                            : (state.isCompleted &&
                                    state.session < data.session)
                                ? Text(
                                    "Start Next Session",
                                    style: buttonSmall.copyWith(
                                      color: naturalWhite,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                : (state.isCompleted &&
                                        state.session == data.session)
                                    ? Text(
                                        "Finish",
                                        style: buttonLarge.copyWith(
                                          color: naturalBlack,
                                        ),
                                      )
                                    : (state is LoadingState)
                                        ? Container()
                                        : Image.asset(
                                            "assets/icons/play.png",
                                            width: 32,
                                          ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackMenu extends StatelessWidget {
  final PomodoroModel data;
  const BackMenu({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCompleted =
        context.select((TimerBloc bloc) => bloc.state.isCompleted);
    final session = context.select((TimerBloc bloc) => bloc.state.session);

    Future exitDialog() {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const ExitDialog();
        },
      );
    }

    return GestureDetector(
      onTap: () {
        if (isCompleted && session == data.session) {
          Navigator.pop(context);
        } else {
          exitDialog();
        }
      },
      child: Image.asset("assets/icons/arrow_back.png", width: 24),
    );
  }
}

class SessionDisplay extends StatelessWidget {
  final PomodoroModel data;
  const SessionDisplay({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final session = context.select((TimerBloc bloc) => bloc.state.session);
    return Text(
      '$session of ${data.session} sessions',
      style: textParagraph,
    );
  }
}
