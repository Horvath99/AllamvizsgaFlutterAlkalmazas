import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/question_model.dart';
import '../quiz_view_model.dart';
import '../widgets.dart';

class GameGridView extends StatefulWidget {
  final aspectRatio;
  final Question question;
  const GameGridView(
      {Key? key, required this.aspectRatio, required this.question})
      : super(key: key);

  @override
  State<GameGridView> createState() => _GameGridViewState();
}

class _GameGridViewState extends State<GameGridView> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.50,
        child: /*widget.aspectRatio == 1
            ?*/ GridView.builder(
                itemCount: widget.question.answers.length - 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //childAspectRatio: 2,
                    mainAxisExtent: 80,
                    crossAxisCount: widget.aspectRatio,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0),
                itemBuilder: (context, index) {
                  return AnswerTile(
                    text: widget.question.answers[index],
                    index: index,
                    question: widget.question,
                  );
                })
            /*: DraggableQuestion(
                answers: widget.question.answers,
                correctAnswer: widget.question.correctAnswers,
              )*/);
  }
}

class DraggableQuestion extends StatefulWidget {
  final List<String>? answers;
  final List<String>? correctAnswer;
  const DraggableQuestion({super.key, this.answers, this.correctAnswer});

  @override
  State<DraggableQuestion> createState() => _DraggableQuestionState();
}

class _DraggableQuestionState extends State<DraggableQuestion> {
  final Map<String, String> score = {};
  late Map<int, String> choices;
  late Map<String, String> result = {};
  @override
  void initState() {
    super.initState();
    choices = widget.answers!.asMap();
    for (int i = 0; i < widget.correctAnswer!.length - 1; i++) {
      result[widget.correctAnswer![i].split('-').first] =
          widget.correctAnswer![i].split('-').last;
    }
    print("sdf" + result.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.5,
                  width: MediaQuery.of(context).size.width*0.8,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: result.length,
                      itemBuilder: (BuildContext context, index) {
                        var itemIndex;
                        if (index == 0) {
                          itemIndex = 1;
                        } else {
                          itemIndex = index * 2 + 1;
                        }
                        return _buildTarget("Empty", choices[itemIndex]);
                      }),
                )
              ]),
          Wrap(
            children: choices.keys.map((firstColumn) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.25,
                margin: EdgeInsets.all(5),
                child: Draggable<String>(
                  data: choices[firstColumn],
                  child: FirstColumn(text: choices[firstColumn]!),
                  feedback: FirstColumn(text: choices[firstColumn]!),
                  childWhenDragging: FirstColumn(text: ""),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTarget(target, target2) {
    String target3 = "";
    String target4 = "";
    var item = context.watch<QuizViewModel>();
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DragTarget<String>(
            builder:
                (BuildContext context, List<String?> incoming, List rejected) {
              if (target3 != "") {
                return Container(
                  color: Colors.red,
                  child: Text(target3),
                  alignment: Alignment.center,
                  height: 80,
                  width: 100,
                );
              } else {
                return Container(
                  padding: EdgeInsets.all(30),
                  color: Color.fromARGB(98, 218, 32, 32),
                  child: Text("Empty"),
                );
              }
            },
            onWillAccept: (data) {
              if (target3 == "") {
                target3 = data!;
                return true;
              }
              return false;
            },
            onAccept: (data) {
              target3 = data;
              if (target4 != "") {
                if (target3 != "") {
                  score[target3] = target4;
                  item.yourAnswers = score.entries.map((entry) => '${entry.key}-${entry.value}').toList();
                  
                }
              }
            },
            onLeave: (data) {
              if (target3 == data) {
                target3 = "";
              }
            },
          ),
          SizedBox(
            width: 30,
          ),
          DragTarget<String>(
            builder:
                (BuildContext context, List<String?> incoming, List rejected) {
              if (target4 != "") {
                return Container(
                  color: Colors.red,
                  child: Text(target4),
                  alignment: Alignment.center,
                  height: 80,
                  width: 100,
                );
              } else {
                return Container(
                  padding: EdgeInsets.all(30),
                  color: Color.fromARGB(98, 218, 32, 32),
                  child: Text("Empty"),
                );
              }
            },
            onWillAccept: (data) {
              if (target4 == "") {
                target4 = data!;
                return true;
              }
              return false;
            },
            onAccept: (data) {
              print("Accepted " + data);
              target4 = data;
              if (target3 != "") {
                score[target3] = target4;
                item.yourAnswers = score.entries.map((entry) => '${entry.key}-${entry.value}').toList();
                print(score.toString());
              }
            },
            onLeave: (data) {
              if (target4 == data) {
                target4 = "";
              }
            },
          )
        ],
      ),
    );
  }
}

class FirstColumn extends StatelessWidget {
  const FirstColumn({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.red,
        alignment: Alignment.center,
        //height: 50,
        padding: EdgeInsets.all(10),
        child: Text(
          text,
        ),
      ),
    );
  }
}

class AnswerTile extends StatelessWidget {
  final String text;
  final int index;
  final Question question;

  const AnswerTile(
      {Key? key,
      required this.text,
      required this.index,
      required this.question})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var item = context.watch<QuizViewModel>();
    return GestureDetector(
        onTap: () {
          item.yourAnswers.add(question.answers[index]);
          item.changeColor(index);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: CustomListItem(
            color: item.active[index] ? Colors.blue : Colors.blueGrey,
            text: text,
            fontSize: 14,
          ),
        ));
  }
}
