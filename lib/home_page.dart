import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teste'),
      ),
      body: Center(
          child: GestureDetector(
        child: Text('Contador: $count', style: TextStyle(fontSize: 26)),
        onTap: () {
          setState(() {
            count++;
          });
        },
      )),
    );
  }
}
