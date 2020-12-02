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
    Navigator.push(context, MaterialPageRoute(builder: (context) => TelaChat(nomeUsuario, idUsuarioAlvo, storage)));
  }

//========================================================================================================================================

  Future<bool> localstoragePronto() async {
    final bool estouPronto = await storage.ready;
    return estouPronto;
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

  Widget telaCarregamento(bool redireciona, String nomeUsuarioAlvo) {
    Future.delayed(const Duration(seconds: 3), () => {redireciona ? goToMainPage(nomeUsuarioAlvo, context) : null});
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("- Carregando -"),
              SizedBox(height: 10.0),
              Text(redireciona ? "Entrando no chat na sala Geral" : "Abrindo tela de acesso"),
              SizedBox(height: 30.0),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

//========================================================================================================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: localstoragePronto(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              usuarioAlvo = storage.getItem('usuario');

              if (usuarioAlvo != null) {
                idUsuarioAlvo = json.decode(usuarioAlvo)['id'];
                String nomeUsuarioAlvo = json.decode(usuarioAlvo)['nome'];

                print('\n idUsuarioAlvo \n');
                print(idUsuarioAlvo);
                print('\n nomeUsuarioAlvo \n');
                print(nomeUsuarioAlvo);

                return telaCarregamento(true, nomeUsuarioAlvo);
              } else {
                return telaDeAcesso();
              }
            } else {
              return telaDeAcesso();
            }
          } else {
            return telaDeAcesso();
          }
        },
      ),
    );
  }
}
