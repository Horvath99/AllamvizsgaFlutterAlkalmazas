import 'package:allamvizsga/models/quiz_results_model.dart';
import 'package:allamvizsga/models/statistic_model.dart';
import 'package:allamvizsga/services/api_service.dart';
import 'package:allamvizsga/services/shared_service.dart';
import 'package:allamvizsga/utils/colors.dart';
import 'package:allamvizsga/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../appbar_view_model.dart';
import '../models/question_model.dart';
import '../quiz_view_model.dart';

class ResultScreen extends StatefulWidget {
  final int quizId;
  ResultScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<Question> correctQuestions = [], wrongQuestions = [];
  List<StatisticsModel>? stats;
  
  @override
  void initState() {
    super.initState();
    APIService.getRecentQuiz(SharedService.userId!, widget.quizId)
        .then((value) {
      setState(() {
        stats = value;
        //print("bejott");
        for (StatisticsModel temp in stats!) {
          late Question question;
          APIService.getQuestionByID(temp.questionId!).then((value) {
            setState(() {
              question = value;
              if (question.correctAnswers[0] == temp.yourAnswers) {
                correctQuestions.add(question);
                print("Question:" + question.question);
              } else {
                wrongQuestions.add(question);
              }
            });
          });
        }
        
      });
      
    }).catchError((error) {
      print("Error : $error");
    });
   
  }
  
  @override
  Widget build(BuildContext context) {
    var item = context.watch<QuizViewModel>();
    var appBarState = context.watch<AppBarViewModel>();

    return SafeArea(
        child: Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      appBar: AppBar(
        backgroundColor: BACKGROUND_COLOR,
      ),
      //atirni scrollviewra,hogy ha tobb minden lesz,gorduljon majd lefele
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CustomText(
                text: "Az eredményed: ${item.getScore()}",
                fontSize: 20,
                shadows: const [
                  BoxShadow(color: Colors.blue, blurRadius: 10, spreadRadius: 2)
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    item.init();
                    appBarState.streak = 0;
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/home", (route) => false);
                  },
                  child: const CustomText(
                    text: "Vissza a menübe",
                    fontSize: 20,
                    shadows: [
                      BoxShadow(
                          color: Colors.blue, blurRadius: 10, spreadRadius: 2)
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              CustomText(
                  shadows: const [
                    BoxShadow(
                        blurRadius: 10, spreadRadius: 2, color: Colors.blue)
                  ],
                  text: "Megmaradt életek száma:\n${appBarState.getLives()}",
                  fontSize: 20),
              const SizedBox(
                height: 20,
              ),
              const CustomText(shadows: [
                BoxShadow(color: Colors.blue, spreadRadius: 2, blurRadius: 10)
              ], text: "Ellenőrizd válaszaidat:", fontSize: 20),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const CustomText(shadows: [
                        BoxShadow(
                            color: Colors.redAccent,
                            spreadRadius: 10,
                            blurRadius: 5)
                      ], text: "Helytelen", fontSize: 20),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ListView.builder(
                          itemCount: wrongQuestions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: (() {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        StatisticsModel? stat;
                                        for (StatisticsModel? e in stats!) {
                                          if (e?.questionId ==
                                              wrongQuestions[index].id) {
                                            stat = e;
                                          }
                                        }
                                        return _popUpQuestion(
                                            context,
                                            "Helytelen",
                                            wrongQuestions[index],
                                            stat);
                                      });
                                }),
                                child: CustomListItem(
                                  text: wrongQuestions[index].question,
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(children: [
                    const CustomText(shadows: [
                      BoxShadow(
                          color: Colors.green, spreadRadius: 10, blurRadius: 5)
                    ], text: "Helyes", fontSize: 20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ListView.builder(
                        itemCount: correctQuestions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: (() {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      StatisticsModel? stat;
                                      for (StatisticsModel? e in stats!) {
                                        if (e?.questionId ==
                                            correctQuestions[index].id) {
                                          stat = e;
                                        }
                                      }
                                      return _popUpQuestion(context, "Helyes",
                                          correctQuestions[index], stat);
                                    });
                              }),
                              child: CustomListItem(
                                text: correctQuestions[index].question,
                                color: Colors.green,
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ])
                ],
              ),
            ],
          )),
    ));
  }
}

Widget _popUpQuestion(BuildContext context, String type, Question question,
    StatisticsModel? stat) {
  return AlertDialog(
    backgroundColor: BACKGROUND_COLOR,
    title: Center(child: Text(type)),
    titleTextStyle:
        TextStyle(color: type == "Helyes" ? Colors.green : Colors.red),
    content: Column(children: [
      CustomText(shadows: const [
        BoxShadow(color: Colors.blue, spreadRadius: 5, blurRadius: 10),
      ], text: question.question, fontSize: 20),
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          child: GridView.builder(
              itemCount: question.answers.length - 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 80,
                  crossAxisCount: int.parse(question.type),
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: CustomListItem(
                    color: question.answers[index] == stat?.yourAnswers
                        ? (question.correctAnswers[0] == stat?.yourAnswers
                            ? Colors.green
                            : Colors.red)
                        : (question.answers[index] == question.correctAnswers[0]
                            ? Colors.green
                            : Colors.grey),
                    text: question.answers[index],
                    fontSize: 20,
                  ),
                );
              }))
    ]),
  );
}
