import 'dart:developer';

import 'package:allamvizsga/models/question_model.dart';
import 'package:allamvizsga/quiz_view_model.dart';
import 'package:allamvizsga/services/api_service.dart';
import 'package:allamvizsga/utils/colors.dart';
import 'package:allamvizsga/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/game_grid.dart';
import 'game_screen.dart';

class FlashQuizGameScreen extends StatefulWidget {
  static String routName = "flashQuizGameScreen";
  final List<int> questionIds;
  final int quizId;
  final String quizName;
  const FlashQuizGameScreen(
      {super.key, required this.quizId, required this.questionIds,required this.quizName});

  @override
  State<FlashQuizGameScreen> createState() => _FlashQuizGameScreenState();
}

class _FlashQuizGameScreenState extends State<FlashQuizGameScreen> {

  List<Question> questions = [];
  late int index;
  late int aspectRatio = 1;

  @override
  Widget build(BuildContext context) {
    QuizViewModel quizViewModel = context.watch<QuizViewModel>();
    return SafeArea(
        child: SizedBox(
      child: Scaffold(
        backgroundColor: BACKGROUND_COLOR,
        appBar: AppBar(
            title:  CustomText(
          text: "Flash Quiz -${widget.quizName}",
          shadows: const [
            BoxShadow(color: Colors.blue, spreadRadius: 5, blurRadius: 2)
          ],
          fontSize: 25,
        )),
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: FutureBuilder<List<Question>>(
            future: APIService.getQuestionByIDs(widget.questionIds),
            builder: (context,snapshot){
              if(snapshot.hasData){
                return Consumer<QuizViewModel>(
                builder: ((context, value, child) {
                    questions = snapshot.data!;
                    index = quizViewModel.getIndex();
                    quizViewModel.data = questions;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height:10),
                            CustomText(
                              shadows: const [
                                BoxShadow(
                                  color: Colors.blue,
                                  blurRadius: 10,
                                  spreadRadius: 10,
                                )
                              ], 
                              text: questions[index].question, 
                              fontSize: 25),
                            GameGridView(aspectRatio: aspectRatio,question:questions[index]),
                            NextButton(length: questions.length,question:questions[index],quizId:widget.quizId,subject: "flashquiz")
                          ],
                        ),
                      );
              }),
            );
              }
              return Center(child: const CircularProgressIndicator());
            },
          
          ),
        ),
      ),
    ));
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

