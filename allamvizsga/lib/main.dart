





import 'package:allamvizsga/appbar_view_model.dart';
import 'package:allamvizsga/provider/online_quiz_provider.dart';
import 'package:allamvizsga/provider/room_data_provider.dart';
import 'package:allamvizsga/quiz_menu_view_model.dart';
import 'package:allamvizsga/quiz_view_model.dart';
import 'package:allamvizsga/screens/create_room_screen.dart';
import 'package:allamvizsga/screens/flash_quiz_screen.dart';
import 'package:allamvizsga/screens/flashquizScreen.dart';
import 'package:allamvizsga/screens/game_over_screen.dart';
import 'package:allamvizsga/screens/game_screen.dart';
import 'package:allamvizsga/oldfiles/levels.dart';
import 'package:allamvizsga/oldfiles/menu.dart';
import 'package:allamvizsga/menuNew.dart';
import 'package:allamvizsga/screens/joing_room_screen.dart';
import 'package:allamvizsga/screens/leaderboard_screen.dart';
import 'package:allamvizsga/screens/login_screen.dart';
import 'package:allamvizsga/screens/online_game_screen.dart';
import 'package:allamvizsga/screens/online_quiz_room_screen.dart';
import 'package:allamvizsga/screens/profile_screen.dart';
import 'package:allamvizsga/screens/register_screen.dart';
import 'package:allamvizsga/screens/result_screen.dart';
import 'package:allamvizsga/screens/statistics_screen.dart';
import 'package:allamvizsga/screens/test_screen.dart';
import 'package:allamvizsga/services/shared_service.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';


Widget _defaultHome = const LoginScreen();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool _result = await SharedService.isLoggedIn();

  if(_result == true && SharedService.userId != null){
    print("Loged In"+SharedService.userId.toString());
    _defaultHome = const HomeScreen();
  }

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => OQuizViewModel()),
          ChangeNotifierProvider(create: (context) => RoomDataProvider()),
          ChangeNotifierProvider(create: (context) => QuizViewModel()),
          ChangeNotifierProvider(create: (context)=> AppBarViewModel()),
          ChangeNotifierProvider(create: (context) =>  QuizMenuViewModel())
        ],
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) =>  _defaultHome,
            '/home':(context) => const HomeScreen(),
            '/register': (context) => const RegisterScreen(),
            '/startQuiz':(context) => QuizMenu(),
            '/levels': (context) => Levels(),
            '/profile':(context) => Profile(),
            '/statistics':(context) => Statisctics(),
            '/enterRoom':(context) => const EnterRoomScreen(),
            CreateRoomScreen.routName:(context) => const CreateRoomScreen(),
            JoinRoomScreen.routName:(context) => const JoinRoomScreen(),
            OnlineGameScreen.routName:(context) => const OnlineGameScreen(),
            LeaderboardScreen.routName:(context) => const LeaderboardScreen(),
            GameOver.routName:(context) => const GameOver(),
            FlashQuizScreen.routName:(context) => const FlashQuizScreen(),
            //'/resultScreen' :(context) => ResultScreen()
           
          },
        )),
  );
}
