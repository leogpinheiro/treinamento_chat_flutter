import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:testechatleo/telaAcesso.dart';
import './ChatModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: ChatModel(),
        child: MaterialApp(
          title: 'Chat no Flutter',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MyHomePage(title: 'Websockets Chat no Flutter'),
        ));
  }
}
