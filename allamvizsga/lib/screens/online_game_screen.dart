import 'dart:async';

import 'package:allamvizsga/models/question_model.dart';
import 'package:allamvizsga/provider/online_quiz_provider.dart';
import 'package:allamvizsga/provider/room_data_provider.dart';
import 'package:allamvizsga/resources/socket_methods.dart';
import 'package:allamvizsga/services/api_service.dart';
import 'package:allamvizsga/services/shared_service.dart';
import 'package:allamvizsga/utils/colors.dart';
import 'package:allamvizsga/utils/game_grid.dart';
import 'package:allamvizsga/utils/score_board.dart';
import 'package:allamvizsga/utils/waiting_lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../widgets.dart';

class OnlineGameScreen extends StatefulWidget {
  static String routName = '/onlinegame';
  final int subjectId;
  final int chapterId;

  const OnlineGameScreen({Key? key, this.chapterId = 20, this.subjectId = 6})
      : super(key: key);

  @override
  State<OnlineGameScreen> createState() => _OnlineGameScreenState();
}

class _OnlineGameScreenState extends State<OnlineGameScreen> {
  List<Question> questions = [];
  int timeLeft = 20;
  late Timer _timer;
  void resetTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
    setState(() {
      timeLeft = 20;
    });
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (timeLeft < 1) {
            timer.cancel();
            resetTimer();
          } else {
            timeLeft = timeLeft - 1;
          }
        },
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  final SocketMethods _socketMethods = SocketMethods();
  @override
  void initState() {
    super.initState();
    _socketMethods.updateRoomListener(context);
    _socketMethods.updatePlayersStateListener(context);

    APIService.getQuestions(widget.subjectId, widget.chapterId).then((value) {
      setState(() {
        questions = value;
      });
    });
    //startTimer();
  }

  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);
    OQuizViewModel oQuizViewModel = Provider.of<OQuizViewModel>(context);

    oQuizViewModel.setLength(questions.length);
    print(oQuizViewModel.getIndex());

    return SafeArea(
      child: Scaffold(
          backgroundColor: BACKGROUND_COLOR,
          body: roomDataProvider.roomData['capacity'] == 1
              ? const WaitingLobby()
              : Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ScoreBoard(),
                      _countDown(context, timeLeft.toString()),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              CustomText(
                                  shadows: const [
                                    BoxShadow(
                                      color: Colors.blue,
                                      blurRadius: 10,
                                      spreadRadius: 10,
                                    )
                                  ],
                                  text: questions[oQuizViewModel.getIndex()]
                                      .question,
                                  fontSize: 25),
                              const SizedBox(height: 20),
                              GameGridView(
                                  aspectRatio: 1,
                                  question:
                                      questions[oQuizViewModel.getIndex()]),
                              NextButton()
                            ],
                          ))
                    ],
                  ),
                )),
    );
  }
}

Widget _countDown(BuildContext context, String timeLeft) {
  return Container(
    color: Colors.blueAccent,
    child: Text(timeLeft),
  );
}

class NextButton extends StatefulWidget {
  const NextButton({super.key});

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    var item = context.watch<OQuizViewModel>();
    return Container(
      child: CustomButton(
        onTap: () {
          if (item.getIndex() < item.getLength() - 1) {
            setState(() {
              item.nextIndex();
            });
          }
        },
        text: "Next",
      ),
    );
  }
}
