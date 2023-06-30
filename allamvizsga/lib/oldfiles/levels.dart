import 'package:flutter/material.dart';

class Levels extends StatelessWidget {
  const Levels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blue.shade900,
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Flexible(
            child: GridView.builder(
                itemCount: 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 2,
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 30.0),
                itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/gameScreen');
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.brown.shade800,
                      child: Text("Basics"),
                    ),
                  );

                })),
      ),
    ));
  }
}
