import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'SocketControl.dart';
import 'Mensagem.dart';
import 'ChatModel.dart';
import 'dart:convert';

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
    });
  }

//=================================================================================================

  Widget buildSingleMessage(Mensagem mensagem) {
    return Container(
      alignment: mensagem.clientId == _channel.meuId ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      child: Text(mensagem.mensagem),
    );
  }

//=================================================================================================

  Widget buildChatList() {
    return ScopedModelDescendant<ChatModel>(
      builder: (context, child, model) {
        _channel.chatModel = model;
        model.idAtual = _channel.meuId;
        _minhasMensagens = model.pegaMensagensNaSala(widget.salaChat);
        return Container(
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
