import 'dart:developer';

import 'package:allamvizsga/models/flash_quiz_model.dart';
import 'package:allamvizsga/screens/flashquizScreen.dart';
import 'package:allamvizsga/services/api_service.dart';
import 'package:allamvizsga/services/shared_service.dart';
import 'package:allamvizsga/utils/colors.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';

import '../widgets.dart';

class FlashQuizScreen extends StatefulWidget {
  static String routName = "/flashQuiz";
  const FlashQuizScreen({super.key});

  @override
  State<FlashQuizScreen> createState() => _FlashQuizScreenState();
}

class _FlashQuizScreenState extends State<FlashQuizScreen> {
  List<FlashQuizModel> flashquizes = [];

  @override
  void initState() {
    super.initState();
    APIService.getFlashQuizes().then((value) {
      setState(() {
        flashquizes = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: SizedBox(child: _createFlashQuizesUI(context, flashquizes)),
    ));
  }
}

Widget _createFlashQuizesUI(
    BuildContext context, List<FlashQuizModel> flashquizes) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _title(context, "Elérhető Flash Quizek"),
        _tableOfQuizes(context, flashquizes)
      ],
    ),
  );
}

Widget _title(BuildContext context, String title) {
  return const Padding(
    padding: EdgeInsets.all(8.0),
    child: CustomText(
      shadows: [BoxShadow(color: Colors.blue, blurRadius: 40, spreadRadius: 5)],
      text: "Elérhető Flash Quizek",
      fontSize: 25,
    ),
  );
}

Widget _tableOfQuizes(BuildContext context, List<FlashQuizModel> flashquizes) {
  List<String> numbersString = [];
  List<int> numbers = [];
  return SingleChildScrollView(
      child: SizedBox(
    height: MediaQuery.of(context).size.height * 0.5,
    child: ListView.builder(
        itemCount: flashquizes.length,
        itemBuilder: (BuildContext context, index) {
          numbersString = flashquizes[index].quizIds.split(',');
          numbers = numbersString.map((string) => int.parse(string)).toList();

          return _flashQuizElement(
              context,
              flashquizes[index].quizName,
              flashquizes[index].startDate,
              flashquizes[index].finishDate,
              numbers);
        }),
  ));
}

Widget _flashQuizElement(BuildContext context, String title, String startDate,
    String endDate, List<int> questionIds) {
  return Container(
    color: Colors.blueGrey,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(title),
        Text(startDate),
        Text(endDate),
        OutlinedButton(
            onPressed: () {
              DateTime dateStart = DateTime.parse(
                  startDate.replaceAll('/', '-').replaceAll(' ', 'T'));
              DateTime dateEnd = DateTime.parse(
                  endDate.replaceAll('/', '-').replaceAll(' ', 'T'));
              DateTime now = DateTime.now();
              if (startDate == "-" || endDate == "-") {
                //gotoscreen
              }
              if (dateStart.compareTo(now) < 0) {
                if (dateEnd.compareTo(now) > 0) {
                  APIService.getMaxQuizIdforUser(SharedService.userId!)
                      .then((value) => {
                            if (value == null)
                              {
                                Navigator.push(
                                    (context),
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            FlashQuizGameScreen(
                                              quizId: 1,
                                              quizName: title,
                                              questionIds: questionIds,
                                            ))))
                              }
                            else
                              {
                                Navigator.push(
                                    (context),
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            FlashQuizGameScreen(
                                              quizId: value + 1,
                                              quizName: title,
                                              questionIds: questionIds,
                                            ))))
                              }
                          });
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                      title: Text(title),
                      content: Text('Ez a gyors kvíz már nem elérhető!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Code to be executed when the "OK" button is pressed.
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                    }
                  );
                }
              }
            },
            child: Text("Start"))
      ],
    ),
  );
}
