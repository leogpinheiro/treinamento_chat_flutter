import 'package:flutter/material.dart';
import 'Mensagem.dart';

class TelaChat extends StatefulWidget {
  final String nomeMeuUsuario;
  TelaChat(this.nomeMeuUsuario);

  @override
  _TelaChatState createState() => _TelaChatState();
}

class _TelaChatState extends State<TelaChat> {
  final TextEditingController textEditingController = TextEditingController();

  Widget buildSingleMessage(Mensagem mensagem) {
    return Container(
      alignment: mensagem.clientId == widget.nomeMeuUsuario ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      child: Text(mensagem.mensagem),
    );
  }

/*
  Widget buildChatList() {
    return ScopedModelDescendant<ChatModel>(
      builder: (context, child, model) {
        List<Mensagem> messages = model.getMessagesForChatID(widget.nomeMeuUsuario);

        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              return buildSingleMessage(messages[index]);
            },
          ),
        );
      },
    );
  }

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
                  model.sendMessage('Geral', textEditingController.text, new DateFormat.yMd().add_Hm().toString(), widget.nomeMeuUsuario);
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
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeMeuUsuario),
      ),
      body: ListView(
        children: <Widget>[
          //buildChatList(),
          //buildChatArea(),
        ],
      ),
    );
  }
}
