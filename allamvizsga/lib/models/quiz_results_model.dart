class QuizResult{
  int quizId;
  String date;
  int score;
  int length;
  int userId;
  String? subject;

  QuizResult({
    required this.quizId,
    required this.date,
    required this.score,
    required this.length,
    required this.userId,
    required this.subject});

  factory QuizResult.fromJson(Map<String,dynamic> json){
    return QuizResult(
      quizId: json['quizId'], 
      date: json['date'], 
      score: json['score'],
      length: json['length'], 
      userId: json['userId'],
      subject: json['subject']);
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['quizId'] = this.quizId;
    data['date'] = this.date;
    data['score'] = this.score;
    data['length'] = this.length;
    data['userId'] = this.userId;
    data['subject'] = this.subject;
    return data;
  }
}