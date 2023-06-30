import 'package:allamvizsga/appbar.dart';
import 'package:allamvizsga/appbar_view_model.dart';
import 'package:allamvizsga/models/statistic_model.dart';
import 'package:allamvizsga/quiz_view_model.dart';
import 'package:allamvizsga/models/question_model.dart';
import 'package:allamvizsga/oldfiles/question_service.dart';
import 'package:allamvizsga/screens/game_over_screen.dart';
import 'package:allamvizsga/screens/result_screen.dart';
import 'package:allamvizsga/services/api_service.dart';
import 'package:allamvizsga/services/shared_service.dart';
import 'package:allamvizsga/utils/colors.dart';
import 'package:allamvizsga/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/lives_model.dart';
import '../models/quiz_results_model.dart';
import '../utils/game_grid.dart';

class GameScreen extends StatefulWidget {
  final int subjectId;
  final int chapterId;
  final int quizId;
  final String subject;
  const GameScreen(
      {Key? key,
      required this.subjectId,
      required this.chapterId,
      required this.quizId,
      required this.subject})
      : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int index;
  late List<Question> data;
  late int aspectRatio;
  late int lives;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    QuizViewModel quizViewModel = context.watch<QuizViewModel>();
    lives = Provider.of<AppBarViewModel>(context).getLives();
    return SafeArea(
      child: SizedBox(
        child: Scaffold(
          backgroundColor: BACKGROUND_COLOR,
          appBar: MyAppBar(),
          body: WillPopScope(
            onWillPop: _onBackPressed,
            child: FutureBuilder<List<Question>>(
              future:
                  APIService.getQuestions(widget.subjectId, widget.chapterId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Consumer<QuizViewModel>(
                      builder: (context, value, child) {
                    index = quizViewModel.getIndex();
                    data = snapshot.data!;
                    quizViewModel.data = data;
                    /*if (int.parse(data[index].type) > 1) {
                      aspectRatio = 2;
                    } else {
                      aspectRatio = 1;
                    }*/
                    aspectRatio = 1;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          CustomText(shadows: const [
                            BoxShadow(
                              color: Colors.blue,
                              blurRadius: 10,
                              spreadRadius: 10,
                            )
                          ], text: data[index].question, fontSize: 25),
                          GameGridView(
                              aspectRatio: aspectRatio, question: data[index]),
                          NextButton(
                            length: data.length,
                            question: data[index],
                            quizId: widget.quizId,
                            subject: widget.subject,
                          )
                        ],
                      ),
                    );
                  });
                }
                return Center(child: const CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }

   Future<bool> _onBackPressed() async {
        return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Exit'),
                  content: Text('Biztosan ki akarsz lépni? Az eddigi eredményed elvész'),
                  actions: [
                    TextButton(
                      child: Text('Igen'),
                      onPressed: () {
                        Provider.of<QuizViewModel>(context,listen: false).init();
                        Navigator.of(context).pop(true);
                      },
                    ),
                    TextButton(
                      child: Text('Nem'),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(false); // Prevent back button press
                      },
                    ),
                  ],
                ),
              );
      }
}



class NextButton extends StatefulWidget {
  final int length;
  final Question question;
  final quizId;
  final String subject;
  NextButton(
      {Key? key,
      required this.length,
      required this.question,
      required this.quizId,
      required this.subject})
      : super(key: key);

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  String text = "next";

  @override
  Widget build(BuildContext context) {
    var checkLives = -1;
    var item = context.watch<QuizViewModel>();
    var appBarState = context.watch<AppBarViewModel>();
    if (item.getIndex() == widget.length - 1) {
      text = "Check result";
    }
    return Container(
      child: ElevatedButton(
          onPressed: () async {
            //upload statistics
            if (item.yourAnswers.length > 1) {
              item.uploadStatistic(widget.question.id, widget.quizId,
                  item.yourAnswers.toString());
            } else {
              item.uploadStatistic(
                  widget.question.id, widget.quizId, item.yourAnswers[0]);
            }

            //check result and update lives
            checkLives = item.calculate(int.parse(widget.question.type),
                widget.question.correctAnswers);
            if (checkLives == 0 && widget.subject != "flashquiz" ) {
              appBarState.decreaseLives();
              //print("Eletek"+Provider.of<AppBarViewModel>(context,listen: false).lives.toString());
              
            } else {
              appBarState.streak++;
              if (appBarState.streak == 3) {
                appBarState.increaseLives();
              }
            }

            if (appBarState.lives < 0 && widget.subject != "flashquiz") {
              Navigator.pushNamedAndRemoveUntil(
                  context, GameOver.routName, (route) => false);
            }
            //navigating to next question or to result screen
            if (text == "Check result") {
              item
                  .updateResults(widget.subject, widget.quizId,
                      item.getScore().toInt(), widget.length)
                  .then((value) => {
                        if (item.uploadStatisticStatus == false)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultScreen(
                                        quizId: widget.quizId,
                                      )))
                      });
            }
            item.nextIndex(widget.length);
          },
          child: Text(text)),
    );
  }
}
