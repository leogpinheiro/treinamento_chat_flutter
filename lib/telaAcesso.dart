import 'package:flutter/material.dart';
import 'package:testechatleo/TelaChat.dart';
import 'SocketControl.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController myTextController = TextEditingController();

  void goToMainPage(String nomeUsuario, BuildContext context) {
    new SocketControl().fazConexao();
    Navigator.push(context, MaterialPageRoute(builder: (context) => TelaChat(nomeUsuario)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Seja bem-vindo ao chat!'),
              TextField(
                controller: myTextController,
                decoration: InputDecoration(labelText: "Nome"),
                onSubmitted: (nomeUsuario) => goToMainPage(nomeUsuario, context),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => goToMainPage(myTextController.text, context),
          tooltip: 'Acessar',
          child: Icon(Icons.arrow_forward),
        ),
      );
}
