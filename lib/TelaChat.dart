import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'SocketControl.dart';
import 'Mensagem.dart';
import 'ChatModel.dart';
import 'dart:convert';

//=================================================================================================

class TelaChat extends StatefulWidget {
  final String nomeMeuUsuario;
  SocketControl channel;
  TelaChat(this.nomeMeuUsuario);
  List<Mensagem> _minhasMensagens;

  @override
  _TelaChatState createState() => _TelaChatState();
}

//=================================================================================================

class _TelaChatState extends State<TelaChat> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ScopedModel.of<ChatModel>(context, rebuildOnChange: false).init();
    widget.channel = new SocketControl(widget.nomeMeuUsuario);
  }

  void _atualizaLista(model) {
    setState(() {
      widget._minhasMensagens = model.getMessagesForChatID(widget.channel.meuId);
    });
  }

//=================================================================================================

  Widget buildSingleMessage(Mensagem mensagem) {
    return Container(
      alignment: mensagem.clientId == widget.channel.meuId ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      child: Text(mensagem.mensagem),
    );
  }

//=================================================================================================

  Widget buildChatList() {
    return ScopedModelDescendant<ChatModel>(
      builder: (context, child, model) {
        widget.channel.chatModel = model;
        model.idAtual = widget.channel.meuId;
        widget._minhasMensagens = model.getMessagesForChatID(widget.channel.meuId);
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
            itemCount: widget._minhasMensagens.length,
            itemBuilder: (BuildContext context, int index) {
              return buildSingleMessage(widget._minhasMensagens[index]);
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
                widget.channel.destroySocket();
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
      widget.channel.enviaMensagem(json.encode({'mensagem': textEditingController.text, 'clientId': widget.channel.meuId}));
      _atualizaLista(model);
    }
  }

  //=================================================================================================

  @override
  void dispose() {
    widget.channel.destroySocket();
    super.dispose();
  }
}
