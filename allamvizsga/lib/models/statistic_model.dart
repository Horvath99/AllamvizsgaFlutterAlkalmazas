class StatisticsModel {

  int? questionId;
  int? userId;
  int? quizId;
  String? yourAnswers;
  String? date;

  StatisticsModel({
    this.questionId,
    this.userId,
    this.quizId,
    this.yourAnswers,
    this.date
  });

  StatisticsModel.fromJson(Map<String,dynamic> json){
    questionId = json['questionId'];
    userId = json['userId'];
    quizId = json['quizId'];
    yourAnswers = json['yourAnswer'];
    date = json['date'];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['questionId'] = this.questionId;
    data['userId'] = this.userId;
    data['quizId'] = this.quizId;
    data['yourAnswer'] = this.yourAnswers;
    data['date'] = this.date;
    return data;
  }

}