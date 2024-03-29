import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'SocketControl.dart';
import 'Mensagem.dart';
import 'ChatModel.dart';
import 'dart:convert';

import 'Usuario.dart';

//=================================================================================================
class TelaChat extends StatefulWidget {
  final String salaChat;
  final String nomeMeuUsuario;
  TelaChat(this.nomeMeuUsuario, this.salaChat);

  @override
  _TelaChatState createState() => _TelaChatState();
}

//=================================================================================================
class _TelaChatState extends State<TelaChat> {
  final TextEditingController textEditingController = TextEditingController();
  List<Mensagem> _minhasMensagens;
  List<Usuario> _meusUsuarios;
  SocketControl _channel;

  @override
  void initState() {
    super.initState();
    ScopedModel.of<ChatModel>(context, rebuildOnChange: false).init();
    _channel = new SocketControl(widget.nomeMeuUsuario);
  }

  void _atualizaLista(model) {
    setState(() {
      _minhasMensagens = model.pegaMensagensNaSala(widget.salaChat);
      _meusUsuarios = model.pegaUsuariosNaSala(widget.salaChat);
    });
  }

//=================================================================================================

  Widget buildSingleMessage(Mensagem mensagem) {
    bool souEu = mensagem.clientId == _channel.meuId;
    Usuario usuarioAutor = _meusUsuarios.firstWhere((usuario) => usuario.idUsuario == mensagem.clientId);

    return Container(
      decoration: BoxDecoration(
        color: souEu ? Colors.green.shade100 : Colors.blue.shade100,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      margin: souEu ? EdgeInsets.only(top: 10.0, bottom: 10.0, left: 100.0) : EdgeInsets.only(top: 10.0, bottom: 10.0, right: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            souEu ? "Eu [" + mensagem.momento + "]" : usuarioAutor.nomeUsuario + " [" + mensagem.momento + "]",
            textAlign: souEu ? TextAlign.left : TextAlign.right,
          ),
          SizedBox(height: 10.0),
          Text(
            mensagem.mensagem,
            textAlign: souEu ? TextAlign.left : TextAlign.right,
          ),
        ],
      ),
    );
  }

//=================================================================================================

  Widget buildChatList() {
    return ScopedModelDescendant<ChatModel>(
      builder: (context, child, model) {
        _channel.chatModel = model;
        model.idAtual = _channel.meuId;
        _minhasMensagens = model.pegaMensagensNaSala(widget.salaChat);
        _meusUsuarios = model.pegaUsuariosNaSala(widget.salaChat);
        return Container(
          padding: EdgeInsets.all(10.0),
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
            itemCount: _minhasMensagens?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return buildSingleMessage(_minhasMensagens[index]);
            },
          ),
        );
      },
    );
  }

//=================================================================================================

  Widget buildChatArea() {
    return ScopedModelDescendant<ChatModel>(
      builder: (context, child, model) {
        return Container(
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: textEditingController,
                ),
              ),
              SizedBox(width: 10.0),
              FloatingActionButton(
                onPressed: () {
                  _sendMessage(model);
                  textEditingController.text = '';
                },
                elevation: 0,
                child: Icon(Icons.send),
              ),
            ],
          ),
        );
      },
    );
  }

  //=================================================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeMeuUsuario),
        actions: [
          IconButton(
              icon: new Icon(Icons.exit_to_app),
              tooltip: 'Sair do Chat',
              onPressed: () {
                _channel.destroySocket();
                Navigator.pop(context);
              })
        ],
      ),
      body: ListView(
        children: <Widget>[
          buildChatList(),
          buildChatArea(),
        ],
      ),
    );
  }

  //=================================================================================================

  void _sendMessage(model) {
    if (textEditingController.text.isNotEmpty) {
      _channel.enviaMensagem(json.encode({'mensagem': textEditingController.text, 'clientId': _channel.meuId}));
      _atualizaLista(model);
    }
  }

  //=================================================================================================

  @override
  void dispose() {
    _channel.destroySocket();
    super.dispose();
  }
}
