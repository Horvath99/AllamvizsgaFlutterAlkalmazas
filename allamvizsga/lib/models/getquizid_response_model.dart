class GetQuizIdResponseModel {
  int? mAXQuizId;

  GetQuizIdResponseModel({this.mAXQuizId});

  GetQuizIdResponseModel.fromJson(Map<String, dynamic> json) {
    mAXQuizId = json['MAX(quizId)'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MAX(quizId)'] = this.mAXQuizId;
    return data;
  }
}