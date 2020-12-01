import 'dart:convert';
import 'constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:testechatleo/TelaChat.dart';

//========================================================================================================================================
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//========================================================================================================================================
class _MyHomePageState extends State<MyHomePage> {
  static LocalStorage storage = new LocalStorage(Constants.LOCALSTORAGE_DAFEULT);
  final TextEditingController myTextController = TextEditingController();
  String idUsuarioAlvo = "";
  var usuarioAlvo;

//========================================================================================================================================

  void goToMainPage(String nomeUsuario, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TelaChat(nomeUsuario, idUsuarioAlvo)));
  }

//========================================================================================================================================

  Future<bool> localstoragePronto() async {
    return await storage.ready;
  }

//========================================================================================================================================

  Widget telaDeAcesso() {
    return Scaffold(
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

//========================================================================================================================================

  Widget carregando() {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            'Carregando...',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

//========================================================================================================================================

  @override
  Widget build(BuildContext context) {
//
    localstoragePronto().then((retorno) {
//
      usuarioAlvo = storage.getItem('usuario');

      if (usuarioAlvo != null) {
        idUsuarioAlvo = json.decode(usuarioAlvo)['id'];
        String nomeUsuarioAlvo = json.decode(usuarioAlvo)['nome'];

        print('\n idUsuarioAlvo \n');
        print(idUsuarioAlvo);
        print('\n nomeUsuarioAlvo \n');
        print(nomeUsuarioAlvo);

        goToMainPage(nomeUsuarioAlvo, context);
        return null;
//
      } else {
        return telaDeAcesso();
      }
    }, onError: (error) {
      return telaDeAcesso();
    });
    return carregando();
  }
}
