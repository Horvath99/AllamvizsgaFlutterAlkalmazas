import 'dart:convert';
import 'dart:developer';
import 'package:allamvizsga/models/subject_model.dart';
import 'package:http/http.dart' as http;
import 'package:allamvizsga/models/question_model.dart';


Future<List<Subject>> getSubjects() async{
    List<Subject> subjects = [];
  
    final response = await http.get(Uri.parse('http://192.168.1.4:8000/api/v1/subject'));

    if(response.statusCode==200){
      final body= json.decode(response.body);
      body.forEach((e)=>{
        subjects.add(Subject.fromJson(e))
      });
    }
   
    return subjects;
  }