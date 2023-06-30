
class FlashQuizModel{
  int id;
  String quizName;
  String quizIds;
  String startDate;
  String finishDate;

  FlashQuizModel({
    required this.id,
    required this.quizName,
    required this.quizIds,
    required this.startDate,
    required this.finishDate
  });

  factory FlashQuizModel.fromJson(Map<String,dynamic> json){
    return FlashQuizModel(
      id:json['id'],
      quizName: json['quizName'], 
      quizIds: json['quizIds'], 
      startDate: json['startDate'], 
      finishDate: json['finishDate']);
  }
  
}