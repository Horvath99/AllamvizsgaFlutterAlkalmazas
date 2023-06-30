import 'package:flutter/cupertino.dart';


class OQuizViewModel extends ChangeNotifier{
  int _index = 0;
  int _length = 0;

  

  void nextIndex(){
    _index++;
    notifyListeners();
  }
  void setLength(int size){
    if(_length == 0){
      _length=size;
    }
  }
  int getLength(){
    return _length;
  }
  int getIndex(){
    return _index;
  }
}