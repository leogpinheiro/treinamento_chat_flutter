import 'package:flutter/material.dart';
import 'package:testechatleo/TelaChat.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController myTextController = TextEditingController();

  void goToMainPage(String nomeUsuario, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TelaChat(nomeUsuario)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color(0xfffae800),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Seja bem-vindo ao chat!'),
              TextFormField(
                controller: myTextController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: "Nome",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  fillColor: Colors.black,
                  hoverColor: Colors.black,
                  focusColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xfffae800),
          onPressed: () => goToMainPage(myTextController.text, context),
          tooltip: 'Acessar',
          child: Icon(
            Icons.arrow_forward,
            color: Colors.black,
          ),
        ),
      );
}
