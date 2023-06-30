



import 'package:flutter/material.dart';
import 'package:allamvizsga/quiz_view_model.dart';




Widget titleSection =  Container(
  child:  const Text(
    'AllamVizsga',
    style: TextStyle(
      fontSize: 40,
      fontFamily: 'Proxima Nova',
    ),
  ),
);

Widget logo = Container(
  width: 200,
  height: 200,
  child: Image.asset('images/majom.png'),
);

Widget playButton(BuildContext context){ 
  //GameGenerator game = GameGenerator(context);
  return  Container(
  width: 150,
  child: ElevatedButton(
    style: OutlinedButton.styleFrom(
    backgroundColor: Colors.grey, //<-- SEE HERE
  ),
    onPressed: (){
      Navigator.of(context).pushNamed('/levels');
      //game.init();
    },
    child: const Text('Play'),
  )
);
}

Widget options = Container(
  width: 150,
  
  child: OutlinedButton(
    style: OutlinedButton.styleFrom(
    backgroundColor: Colors.grey, 
  ),
    onPressed: (){},
    child: const Text('Options'),
  )
);

Widget statistic = Container(
  width: 150,
  child: OutlinedButton(
    style: OutlinedButton.styleFrom(
    backgroundColor: Colors.grey, 
  ),
    onPressed: (){},
    child: const Text('Statistic'),
  )
);

Widget exit = Container(
  width: 100,
  child: OutlinedButton(
    style: OutlinedButton.styleFrom(
    backgroundColor: Colors.grey, 
  ),
    onPressed: (){},
    child: const Text('Exit'),
  )
);