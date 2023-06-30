import 'package:allamvizsga/models/question_model.dart';
import 'package:allamvizsga/services/api_service.dart';
import 'package:allamvizsga/services/shared_service.dart';
import 'package:flutter/material.dart';

import 'models/quiz_results_model.dart';
import 'models/statistic_model.dart';

class QuizViewModel extends ChangeNotifier {
  bool uploadStatisticStatus = false;
  bool uploadResultStatus = false;


  double _score = 0;
  int _index = 0;
  List<String> yourAnswers = [];

  late List<bool> active = List.generate(15, (index) => false);
  List<Question> data = [];

  QuizViewModel(){
    _score = 0;
    _index = 0;
    yourAnswers = [];
  }

  setLoadingStatistic(bool loadingStatistic){
    uploadStatisticStatus = loadingStatistic;
    notifyListeners();
  }
  setLoadingResult(bool loadingResult){
    uploadStatisticStatus = loadingResult;
    notifyListeners();
  }

  void init() {
    _score = 0;
    _index = 0;
    yourAnswers = [];
  }

  void changeColor(int index) {
    active[index] = !active[index];
    notifyListeners();
  }

  int getSize() {
    return data.length;
  }

  int getIndex() {
    return _index;
  }

  double getScore() {
    return _score;
  }

  void nextIndex(int length) {
    if (_index + 1 < length) {
      _index++;
    }
    for (int i = 0; i < 15; i++) {
      active[i] = false;
    }

    yourAnswers = [];
    notifyListeners();
  }

  int calculate(int type, List<String> answers) {
    if (type == 1) {
      if (typeOneResult(answers) == 1) {
        _score = _score + 1;
        return 1;
      } else {
     
        return 0;
      }
    }
    if (type == 2) {
      _score = _score + typeTwoResult(answers);
      return 0;
    }

    return 0;
  }

  double typeTwoResult(List<String> correctAnswer) {
    //check if answer list partiali complete or not
   /* String first, second;
    double score = 0;
    if (yourAnswers.isEmpty) {
      return 0;
    }
    for (int i = 0; i < correctAnswer.length; i++) {
      first = correctAnswer[i].split('-').first;
      second = correctAnswer[i].split('-').last;
      if (yourAnswers[i] == first && yourAnswers[i + 1] == second) {
        score++;
      }
      if (yourAnswers[i] == second && yourAnswers[i + 1] == first) {
        score++;
      }
      i++;
      if(i >= yourAnswers.length){
        
      }
    }
    return score / (correctAnswer.length - 1); NEM JO */

    return 0; 
  }

  int typeOneResult(List<String> correctAnswer) {
    if (yourAnswers.isNotEmpty && yourAnswers[0] == correctAnswer[0]) {
      return 1;
    } else {
      return 0;
    }
  }

  void backIndex() {
    if (_index - 1 >= 0) {
      _index--;
      notifyListeners();
    }
  }

  Question getQuestion(int index) {
    return data[index];
  }
  uploadStatistic(int id,int quizID,String answer) async {
    setLoadingStatistic(true);
    await APIService.createStat(StatisticsModel(
                questionId: id,
                userId: SharedService.userId,
                quizId: quizID,
                yourAnswers: answer,
                date: DateTime.now().toString()
              )).then((value) {
             
              });
   setLoadingStatistic(false);
}

 updateResults(String subject,int id,int score,int length) async {
    setLoadingResult(true);
     await APIService.createResult(QuizResult(
          quizId: id,
          date: DateTime.now().toString(),
          score: score,
          length: length,
          userId: SharedService.userId!,
          subject: subject)).then((value) {
          });
    setLoadingResult(false);
  
}
}
