
import 'package:flutter/cupertino.dart';

class QuizMenuViewModel extends ChangeNotifier{
  String _subject = "";
  int _subjectId=-1;
  int _chapterId= -1;
  String _chapter = "";
  bool subjectReady = false;
  List<bool> active = List.generate(15, (index) => false);

  void changeColor(int index) {
    for(int i=0; i<active.length;i++){
      if(active[i]==true){
        active[i]=false;
      }
    }
    active[index]=!active[index];
    notifyListeners();
  }
  void setSbujectId(int id){
    _subjectId=id;
    notifyListeners();
  }
  int getSubjectId(){
    return _subjectId;
  }
  void setChapterId(int id){
    _chapterId=id;
  }
  int getChapterId(){
    return _chapterId;
  }
  void setSubject(String subject){
    _subject= subject;
    subjectReady = true;
    notifyListeners();
  }
  void setChapter(String chapter){
    _subject= chapter;
  }
  String getSubject(){
    return _subject;
  }
  String getChapter(){
    return _chapter;
  }
}