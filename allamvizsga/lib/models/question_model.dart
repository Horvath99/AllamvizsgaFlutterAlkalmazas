import 'dart:developer';

import 'package:flutter/material.dart';


/*tedd privata a mezoket*/
class Question {
    int id;
    String question;
    List<String> answers;
    List<String> correctAnswers;
    String type;
    int categorie;

    Question({required this.id,
    required this.question,
    required this.answers,
    required this.correctAnswers,
    required this.type,
    required this.categorie});

    factory Question.fromJson(Map<String,dynamic> json){
      return Question(
        id:json['id'],
        question : json['question'],
        answers: json['answers'].split('#'), 
        correctAnswers: json['correctAnswers'].split('#'), 
        type:json['type'],
        categorie:json['chapter']);
    }

    String getQuestion(){
      return question;
    }
    List<String> getAnswrs(){
      return answers;
    }
    List<String> getCorrectAnswers(){
      return correctAnswers;
    }
    String getType(){
      return type;
    }
    int getCategorie(){
      return categorie;
    }
      
}

