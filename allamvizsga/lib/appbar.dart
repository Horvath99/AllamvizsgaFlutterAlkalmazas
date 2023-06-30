

import 'package:allamvizsga/appbar_view_model.dart';

import 'package:allamvizsga/services/api_service.dart';
import 'package:allamvizsga/services/shared_service.dart';
import 'package:allamvizsga/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  List<Widget> _buildHearts(int lives) {
    List<Widget> hearts = [];
    for (int i = 0; i < lives; i++) {
      hearts.add(
        const Icon(
          Icons.favorite,
          color: Colors.red,
        ),
      );
    }
    return hearts;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: APIService.getLives(SharedService.userId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Provider.of<AppBarViewModel>(context).lives = snapshot.data as int;
            int lives = context.watch<AppBarViewModel>().lives;
            return Consumer<AppBarViewModel>(
              builder: (context, value, child) {
                return AppBar(
                    backgroundColor: BACKGROUND_COLOR,
                    title: const Text("Quiz"),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: Row(children: _buildHearts(lives)),
                      ),
                    ]);
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
