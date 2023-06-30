import 'package:allamvizsga/services/api_service.dart';
import 'package:allamvizsga/services/shared_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarViewModel extends ChangeNotifier{
  bool decreaseLivesStatus = false;

  bool increaseLivesStatus = true;

  int lives = 0;
  int streak = 0;

   setLoadingDecrease(bool loadingDecrease){
    decreaseLivesStatus = loadingDecrease;
    notifyListeners();
  }
  setLoadingIncrease(bool increaseLives){
    increaseLivesStatus = increaseLives;
    notifyListeners();
  }


  void decreaseLives() async{
    setLoadingDecrease(false);
    lives--;
    streak=0;
    await APIService.updateLives(SharedService.userId!,lives);
    setLoadingDecrease(true);
    
  }
  void increaseLives() async{
    setLoadingIncrease(false);
    lives++;
    streak=0;
     await APIService.updateLivesWithOne(SharedService.userId!);
    setLoadingIncrease(true);
  }
  int getLives(){
    return lives;
  }

}