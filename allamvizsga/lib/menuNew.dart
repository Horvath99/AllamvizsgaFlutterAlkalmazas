

import 'package:allamvizsga/appbar_view_model.dart';
import 'package:allamvizsga/oldfiles/chapter_service.dart';
import 'package:allamvizsga/models/subject_model.dart';
import 'package:allamvizsga/quiz_menu_view_model.dart';
import 'package:allamvizsga/quiz_view_model.dart';
import 'package:allamvizsga/screens/game_screen.dart';
import 'package:allamvizsga/services/api_service.dart';
import 'package:allamvizsga/appbar.dart';

import 'package:allamvizsga/services/shared_service.dart';
import 'package:allamvizsga/utils/colors.dart';
import 'package:allamvizsga/widgets.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:provider/provider.dart';

import 'models/chapter_model.dart';

class QuizMenu extends StatefulWidget {
  const QuizMenu({Key? key}) : super(key: key);
  @override
  State<QuizMenu> createState() => _QuizMenuState();
}

class _QuizMenuState extends State<QuizMenu> {

  int lives=0;

@override
void initState() {
    super.initState();
    APIService.getLives(SharedService.userId!).then((value) {
      setState(() {
        lives=value;
      });
      
    });
  }
   
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 34, 42, 53),
            appBar: MyAppBar(),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(children: lives > 0 ? [
                const TitleSection(text: "Subjects"),
                CarSlider(),
                const TitleSection(text: "Chapters"),
                ChapterList(),
              ] : [
                const CustomText(shadows:
                 [
                  BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 5,
                    color: Colors.blue
                  )
                 ], 
                 text: "Elfogytak az eleteid,gyere vissza kesobb", 
                 fontSize: 30)
              ]
              ),
            )));
  }
}

class CarSlider extends StatefulWidget {
  CarSlider({Key? key}) : super(key: key);

  @override
  State<CarSlider> createState() => _CarSliderState();
}

class _CarSliderState extends State<CarSlider> {
  Color subjectColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    var item = context.watch<QuizMenuViewModel>();
    return Container(
      color: BACKGROUND_COLOR,
      child: FutureBuilder<List<Subject>>(
          future: APIService.getSubjects(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Consumer<QuizMenuViewModel>(
                builder: (context, value, child) {
                  return CarouselSlider.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index, realIndex) {
                        return InkWell(
                            onTap: () async {
                              item.setSubject(snapshot.data![index].name);
                              item.setSbujectId(snapshot.data![index].id);
                              item.changeColor(index);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: item.active[index]
                                          ? Colors.blueGrey
                                          : subjectColor,
                                      blurRadius: 5,
                                      spreadRadius: 2)
                                ],
                              ),
                              margin: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Center(
                                child: Text(
                                  snapshot.data![index].name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ));
                      },
                      options: CarouselOptions());
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class ChapterList extends StatefulWidget {
  ChapterList({Key? key}) : super(key: key);

  @override
  State<ChapterList> createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  @override
  Widget build(BuildContext context) {
    var item = context.watch<QuizMenuViewModel>();
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.9,
      child: FutureBuilder<List<Chapter>>(
        future: APIService.getChapters(item.getSubjectId()),
        builder: (context, snapshot) {
          if (snapshot.hasData && item.subjectReady == true) {
            return Consumer<QuizMenuViewModel>(
                builder: (context, value, child) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return Container(
                        padding: const EdgeInsets.all(5),
                        child: CustomButton(
                            onTap: () async {
                              int? quizID =
                                  await APIService.getMaxQuizIdforUser(
                                      SharedService.userId!);
                              if(quizID == null){
                                quizID = 1;
                              }else{
                                quizID++;
                              }
                              
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => GameScreen(
                                          subjectId: item.getSubjectId(),
                                          chapterId:
                                              snapshot.data![index].id,
                                              quizId: quizID!,
                                              subject: item.getSubject(),))));
                            },
                            text: snapshot.data![index].name));
                  });
            });
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({Key? key, required this.text}) : super(key: key);
  final text;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 34, 42, 53),
        ),
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: CustomText(
              text: text,
              fontSize: 30,
              shadows: const [Shadow(blurRadius: 40, color: Colors.blue)]),
        ));
  }
}
