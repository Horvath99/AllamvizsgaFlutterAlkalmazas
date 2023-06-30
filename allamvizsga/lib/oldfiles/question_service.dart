import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:allamvizsga/models/question_model.dart';

Future<List<Question>> getQuestions(int subjectId,int chatperId) async{
    List<Question> questions = [];
  
    final response = await http.get(Uri.parse('http://192.168.1.4:8000/api/v1/question/$subjectId/$chatperId'));

    if(response.statusCode==200){
      final body= json.decode(response.body);
      body.forEach((e)=>{
        questions.add(Question.fromJson(e))
      });
    }
   
    return questions;
  }