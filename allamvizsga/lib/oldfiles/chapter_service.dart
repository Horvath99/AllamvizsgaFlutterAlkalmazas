import 'package:allamvizsga/models/chapter_model.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:allamvizsga/models/subject_model.dart';
import 'package:http/http.dart' as http;
import 'package:allamvizsga/models/question_model.dart';

Future<List<Chapter>> getChapters(int chapterId) async{
    List<Chapter> chapters = [];
   
    final response = await http.get(Uri.parse('http://192.168.1.4:8000/api/v1/chapter/$chapterId'));

    if(response.statusCode==200){
      final body= json.decode(response.body);
      body.forEach((e)=>{
        chapters.add(Chapter.fromJson(e))
      });
    }
   
    return chapters;
  }