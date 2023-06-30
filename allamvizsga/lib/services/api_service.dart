import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:allamvizsga/models/create_stat_response_model.dart';
import 'package:allamvizsga/models/flash_quiz_model.dart';
import 'package:allamvizsga/models/getquizid_response_model.dart';
import 'package:allamvizsga/models/leaderboard_model.dart';
import 'package:allamvizsga/models/login_request_model.dart';
import 'package:allamvizsga/models/login_response_model.dart';
import 'package:allamvizsga/models/quiz_results_model.dart';
import 'package:allamvizsga/models/register_request_model.dart';
import 'package:allamvizsga/models/register_response_model.dart';
import 'package:allamvizsga/models/statistic_model.dart';
import 'package:allamvizsga/services/shared_service.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/chapter_model.dart';
import '../models/lives_model.dart';
import '../models/question_model.dart';
import '../models/subject_model.dart';

class APIService {
  static var client = http.Client();

  static Future<bool> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      /*'Connection':'keep-alive',
      'Accept-Encoding':'gzip,deflate,br'*/
    };

    var url = Uri.http(Config.apiURL, Config.loginAPI);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));

    if (response.statusCode == 200) {
      print("status code"+response.body);
      //SHARED
      await SharedService.setLoginDetails(loginResponseJson(response.body));
      return true;
    } else {
      print("status code ${response.statusCode}");
      return false;
    }
  }

  static Future<RegisterResponseModel> register(
      RegisterRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, Config.registerAPI);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(response.body.toString());
    return registerResponseModel(response.body);
  }

  static Future<String> getUserProfile() async {
    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Autharization': 'Bearer ${loginDetails!.token}'
    };

    var url = Uri.http(Config.apiURL, Config.getUsersAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
    }
  }

  static Future<int> getLives(int userId) async {
    List<Lives> lives = [];
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url =
        Uri.http(Config.apiURL, Config.getLivesByUserAPI + userId.toString());
    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      final body = json.decode(response.body);
      body.forEach((e) => {lives.add(Lives.fromJson(e))});
    }

    return lives[0].livesNumber;
  }

  static Future<String> updateLives(int userId, int lives) async {
    /*Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };*/
    var url =
        Uri.http(Config.apiURL, Config.getLivesByUserAPI + "/$userId/$lives");
    var response = await client.put(
      url,
      
    );

    //print(response.body.toString());
    //final body= json.decode(response.body);
    return response.body.toString();
  }

  static Future<List<Subject>> getSubjects() async {
    List<Subject> subjects = [];
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, Config.getSubjectsAPI);
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      body.forEach((e) => {subjects.add(Subject.fromJson(e))});
    }

    return subjects;
  }

  static Future<List<Chapter>> getChapters(int chapterId) async {
    List<Chapter> chapters = [];
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.http(Config.apiURL, Config.getChaptersAPI + "/$chapterId");
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      body.forEach((e) => {chapters.add(Chapter.fromJson(e))});
    }

    return chapters;
  }

  

  static Future<List<Question>> getQuestions(
      int subjectId, int chatperId) async {
    List<Question> questions = [];

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.http(
        Config.apiURL, Config.getQuestionsBySubjectAndChapterAPI + "/$subjectId/$chatperId");

    for (int i = 0; i < 3; i++) {
      try {
        try {
          var response = await client.get(
            url,
            headers: requestHeaders,
          );

          if (response.statusCode == 200) {
            final body = json.decode(response.body);
            body.forEach((e) => {questions.add(Question.fromJson(e))});
          } else {
            throw Exception('Failed to load data');
          }
          return questions;
        } on SocketException {
          throw Exception('No Internet connection');
        }
      } catch (e) {
        print('Request failed, retrying...');
      }
      
    }
    throw Exception('Failed to load data after 3 retries');
    
  }

  static Future<String> updateLivesWithOne(int userId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.http(Config.apiURL, Config.getLivesByUserAPI + "/$userId");
    var response = await client.put(
      url,
      headers: requestHeaders,
    );

    //print(response.body.toString());
    //final body= json.decode(response.body);
    return response.body.toString();
  }

  static Future<int?> getMaxQuizIdforUser(int userId) async{
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.http(Config.apiURL, Config.maxQuizIdAPI + "/$userId");
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

      final body = json.decode(response.body)[0];
      int? quizId = body['MAX(quizId)'];
      return quizId;

      /*List<dynamic> jsonData = json.decode(response.body);
      return jsonData[0];*/
  }

  static Future<CreateStatResponseModel> createStat(StatisticsModel model) async{
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, Config.createStatAPI);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print("Create stat answer:"+createStatResponseModel(response.body).status.toString());
    return createStatResponseModel(response.body);
  }

  static Future<List<StatisticsModel>> getRecentQuiz(int userId,int quizId) async {
    List<StatisticsModel> stats = [];
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.http(Config.apiURL, Config.getLatestQuizAPI + "/$userId/$quizId");
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      body.forEach((e) => {stats.add(StatisticsModel.fromJson(e))});
    }else{
      throw Exception('Failed to get latest question results');
    }

    return stats;
  }

   static Future<Question> getQuestionByID(int questionId) async {
    List<Question> question = [];
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.http(Config.apiURL, Config.getQuestionByIdAPI + "/$questionId");
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      body.forEach((e) => {question.add(Question.fromJson(e))});
      //question = Question.fromJson(body);
    }
  print(question.toString());
    if(question.isEmpty){
      question[0] = Question(id: 1, question: "", answers: [], correctAnswers: [], type: "", categorie: 1);
    }
   
    return question[0];
  }

  static Future<String> createResult(QuizResult model) async{
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, Config.createResultAPI);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print("Return ${response.body.toString()} ");
    return response.body.toString();
  }

  static Future<List<QuizResult>> getAllResults() async{
    List<QuizResult> results = [];
     Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, Config.getAllResultAPI);
    var response = await client.get(
            url,
            headers: requestHeaders,
          );
     if (response.statusCode == 200) {
            final body = json.decode(response.body);
            body.forEach((e) => {results.add(QuizResult.fromJson(e))});
          }
    return results;
  }

  static Future<List<QuizResult>> getUsersResults(int userId) async{
    List<QuizResult> results = [];
     Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiURL, "${Config.getUserResultsAPI}/$userId");
    var response = await client.get(
            url,
            headers: requestHeaders,
          );
     if (response.statusCode == 200) {
            final body = json.decode(response.body);
            body.forEach((e) => {results.add(QuizResult.fromJson(e))});
          }
    print("AAAAAAAAAAA"+response.body);
    return results;
  }

  static Future<List<LeaderboardModel>> getLeaderboardStats() async{
     List<LeaderboardModel> results = [];
     Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.http(Config.apiURL, Config.getLeaderBoardAPI);
    var response = await client.get(
            url,
            headers: requestHeaders,
          );
     if (response.statusCode == 200) {
            final body = json.decode(response.body);
            body.forEach((e) => {results.add(LeaderboardModel.fromJson(e))});
          }
    print("AAAAAAAAAAA"+response.body);
    return results;
  }

  static Future<List<FlashQuizModel>> getFlashQuizes() async{
    List<FlashQuizModel> results = [];
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.http(Config.apiURL, Config.getFlashQuizAPI);
    var response = await client.get(
            url,
            headers: requestHeaders,
          );
    if (response.statusCode == 200) {
            final body = json.decode(response.body);
            body.forEach((e) => {results.add(FlashQuizModel.fromJson(e))});
          }
    print("AAAAAAAAAAA"+response.body);
    return results;      
  }

  static Future<List<Question>> getQuestionByIDs(List<int> ids) async{
    List<Question> results = [];
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.http(Config.apiURL, Config.getQuestionByIDs);
    var response = await client.post(
            url,
            headers: requestHeaders,
            body:jsonEncode({'ids':ids})
          );
    if (response.statusCode == 200) {
            print(response);
            final body = json.decode(response.body);
            body.forEach((e) => {results.add(Question.fromJson(e))});
          }
    print("AAAAAAAAAAA"+response.body);
    return results;    
  }

  static Future<List<Question>> getQuestionsFromStats(int userId,int quizId) async{
    List<Question> results = [];
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
   var url = Uri.http(Config.apiURL,'${Config.getQuestionsFromStats}/$userId/$quizId');
    var response = await client.get(
            url,
            headers: requestHeaders,
          );
    if (response.statusCode == 200) {
            final body = json.decode(response.body);
            body.forEach((e) => {results.add(Question.fromJson(e))});
          }
    print("AAAAAAAAAAA"+response.body);
    return results;   
  }

  
}


