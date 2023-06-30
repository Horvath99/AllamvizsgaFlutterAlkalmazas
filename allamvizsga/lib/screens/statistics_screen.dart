import 'dart:io';
import 'dart:ui';

import 'package:allamvizsga/models/quiz_results_model.dart';
import 'package:allamvizsga/oldfiles/menu_components.dart';
import 'package:allamvizsga/services/api_service.dart';
import 'package:allamvizsga/services/shared_service.dart';
import 'package:allamvizsga/utils/colors.dart';
import 'package:allamvizsga/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../models/question_model.dart';
import '../models/statistic_model.dart';
import '../services/shared_service.dart';

class Statisctics extends StatefulWidget {
  const Statisctics({super.key});

  @override
  State<Statisctics> createState() => _StatiscticsState();
}

class _StatiscticsState extends State<Statisctics> {
  List<QuizResult> results = [];

  @override
  void initState() {
    super.initState();
    APIService.getUsersResults(SharedService.userId!).then((value) {
      setState(
        () {
          results = value;
        },
      );
    }).catchError((error) {
      print("Error : $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: _statisticWidgetUI(context),
    ));
  }

  Widget _statisticWidgetUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: const CustomText(shadows: [
                BoxShadow(color: Colors.blue, spreadRadius: 2, blurRadius: 5)
              ], text: "Statistics", fontSize: 30),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.only(left: 15, bottom: 10),
          alignment: Alignment.centerLeft,
          child: const CustomText(shadows: [
            BoxShadow(color: Colors.blue, spreadRadius: 2, blurRadius: 5)
          ], text: "Szurd az adatokat:", fontSize: 17),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: CarouselSlider(
            options: CarouselOptions(
                height: 50,
                autoPlay: false,
                viewportFraction: 0.35,
                autoPlayInterval: const Duration(seconds: 2),
                autoPlayAnimationDuration: const Duration(milliseconds: 300)),
            items: [
              _filterButton(context, "Tantargy"),
              _filterButton(context, "Datum"),
              _filterButton(context, "Szazalek"),
            ],
          ),
        ),
        //statTablazat
        Container(
          child: Column(
            children: [
              _tableHeader(context),
              Container(
                height: MediaQuery.of(context).size.height*0.6,
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (BuildContext context, index) {
                    return _statItem(
                        context,
                        results[index].date.split(" ")[0],
                        results[index].score.toDouble(),
                        results[index].length,
                        results[index].quizId,
                        results[index].subject);
                  },
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  Widget _filterButton(BuildContext context, String text) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(left: 6, right: 6),
      child: ElevatedButton(
        onPressed: (() {}),
        style: ElevatedButton.styleFrom(
            primary: BACKGROUND_COLOR,
            side: const BorderSide(
              color: Colors.white,
              width: 1,
            )),
        child: Text(text),
      ),
    );
  }
}

Widget _tableHeader(BuildContext context) {
  const TextStyle txtStyle =
      TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold);
  return Container(
    height: 50,
    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
    margin: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
    foregroundDecoration: BoxDecoration(
      border: Border.all(color: Colors.greenAccent, width: 2),
    ),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white, width: 4),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Tantargy |",
            style: txtStyle,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Date |",
            style: txtStyle,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Score |",
            style: txtStyle,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Percentage",
            style: txtStyle,
          )
        ],
      ),
    ),
  );
}

Widget _statItem(BuildContext context, String date, double score,
    int quizLength, int quizNumber,String? subject) {
  double percentage = (score * 100) / quizLength;
  String percentageString = percentage.toStringAsFixed(2);
  TextStyle txtStyle = const TextStyle(color: Colors.white, fontSize: 12);
  List<Question> allQuestions = [];
  List<StatisticsModel>? stats;
  return Container(
    margin: const EdgeInsets.only(left: 10, right: 10),
    width: MediaQuery.of(context).size.width,
    child: GestureDetector(
      onTap: () {
        APIService.getRecentQuiz(SharedService.userId!, quizNumber)
            .then((value) {
          stats = value;
          //print("bejott");
          /*for (StatisticsModel temp in stats!) {
            late Question question;
            APIService.getQuestionByID(temp.questionId!).then((value) {
              question = value;
              allQuestions.add(question);
            });
          }*/
          APIService.getQuestionsFromStats(SharedService.userId!,quizNumber)
          .then((value) {
            allQuestions = value;
            showDialog(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.6,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allQuestions.length,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (BuildContext context, index) {
                      StatisticsModel? stat;
                      for (StatisticsModel? e in stats!) {
                        if (e?.questionId == allQuestions[index].id) {
                          stat = e;
                        }
                      }
                      return _popUpQuestion(
                          context, "Helyes", allQuestions[index], stat);
                    }),
              );
            });
          },);
        });
        
      },
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(15), right: Radius.circular(15))),
        child: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              subject != "" ? "$subject -" : "nincs -",
              style: txtStyle,
            ),
            /*const SizedBox(
              width: 7,
            ),*/
            Text(
              "$date - ",
              style: txtStyle,
            ),
            /*const SizedBox(
              width: 7,
            ),*/
            Text(
              "$score/$quizLength - ",
              style: txtStyle,
            ),
            /*const SizedBox(
              width: 7,
            ),*/
            Text(
              "$percentageString%",
              style: txtStyle,
            )
          ]),
        ),
      ),
    ),
  );
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
          height: MediaQuery.of(context).size.height * 0.5,
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
