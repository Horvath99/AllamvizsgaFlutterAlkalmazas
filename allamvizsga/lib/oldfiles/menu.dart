import 'package:flutter/material.dart';
import 'menu_components.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade900,
        body: Container(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                titleSection,
                logo,
                playButton(context),
                options,
                statistic,
                exit
              ],
              ),
          )
        ),
      ),
    );
  }
}

