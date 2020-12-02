import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'SocketControl.dart';
import 'Objetos/Mensagem.dart';
import 'ChatModel.dart';
import 'dart:convert';
import 'Objetos/Usuario.dart';

//=================================================================================================
class TelaChat extends StatefulWidget {
  final String nomeMeuUsuario;
  final idMeuUsuario;
  final LocalStorage myLocalStorage;
  TelaChat(this.nomeMeuUsuario, this.idMeuUsuario, this.myLocalStorage);

  @override
  _TelaChatState createState() => _TelaChatState();
}

//=================================================================================================
class _TelaChatState extends State<TelaChat> {
  final TextEditingController textEditingController = TextEditingController();
  LocalStorage meuStorage;
  List<Mensagem> _minhasMensagens;
  List<Usuario> _meusUsuarios;
  SocketControl _channel;
  String salaChat = 'Geral';
  String amigoAtual;

  @override
  void initState() {
    super.initState();
    ScopedModel.of<ChatModel>(context, rebuildOnChange: false).init();
    _channel = new SocketControl(widget.nomeMeuUsuario, widget.idMeuUsuario);
    meuStorage = widget.myLocalStorage;
  }

  void _atualizaLista(model) {
    setState(() {
      print('Atualizando lista de mensagens de: ');
      print(salaChat);
      _minhasMensagens = model.pegaMensagensNaSala(salaChat);
      _meusUsuarios = model.pegaUsuariosNaSala(salaChat);
    });
  }

//=================================================================================================

  Widget buildSingleMessage(Mensagem mensagem) {
    bool souEu = mensagem.clientId == _channel.meuUsuario.idUsuario;

    return Container(
      decoration: BoxDecoration(
        color: souEu ? Color(0xffeeeeee) : Color(0xfffff670),
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
          RichText(
              text: TextSpan(
            text: souEu ? 'Eu' : mensagem.clientNome,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
            children: <TextSpan>[
              TextSpan(
                text: " [" + mensagem.momento + "]",
                style: TextStyle(
                  color: Colors.black38,
                ),
              ),
            ],
          )),
          SizedBox(height: 10.0),
          Text(
            mensagem?.mensagem ?? '',
            textAlign: souEu ? TextAlign.left : TextAlign.right,
          ),
        ],
      ),
    );
  }

//=================================================================================================

  Widget buildSingleUser(Usuario usuarioItem) {
    bool souEu = usuarioItem.idUsuario == _channel.meuUsuario.idUsuario;
    return ListTile(
      onTap: () {
        if (!souEu) {
          amigoAtual = usuarioItem.nomeUsuario;
          Usuario usuarioAlvo = _meusUsuarios.firstWhere((usuario) => usuario.idUsuario == usuarioItem.idUsuario);
          String salaDestino = _channel.meuUsuario.idUsuario + "+" + usuarioAlvo.idUsuario;
          _channel.chatModel.trocaDeSala(_channel.meuUsuario, salaChat, salaDestino);
          _minhasMensagens.clear();
          salaChat = salaDestino;
          _trocaMeDeSala(usuarioItem.nomeUsuario, salaChat);
        }
        Navigator.pop(context);
      },
      title: Text(
        souEu ? 'Eu' : usuarioItem.nomeUsuario,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

//=================================================================================================

  Widget buildChatList() {
    return ScopedModelDescendant<ChatModel>(
      builder: (context, child, model) {
        model.myLocalStorage = widget.myLocalStorage;
        _channel.chatModel = model;
        _minhasMensagens = model.pegaMensagensNaSala(salaChat);
        _meusUsuarios = model.pegaUsuariosNaSala(salaChat);
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

  Widget buildChatDrawerTopo() {
    return ScopedModelDescendant<ChatModel>(
      builder: (context, child, model) {
        String enunciado = salaChat.contains('+') ? 'Conversando com ' + amigoAtual : '${_meusUsuarios?.length ?? 0}' + ' - Usuários ativos em "' + salaChat + '"';
        return Container(
          height: 154.0,
          child: DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  enunciado,
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 15),
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                  child: TextButton(
                    child: Text("Sala Geral", style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      salaChat = 'Geral';
                      _trocaMeDeSala('Geral', salaChat);
                      _atualizaLista(model);
                    },
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(color: Color(0xfffae800)),
          ),
        );
      },
    );
  }

  Widget buildChatDrawerItens() {
    return ScopedModelDescendant<ChatModel>(
      builder: (context, child, model) {
        return Container(
          padding: EdgeInsets.all(10.0),
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
            itemCount: _meusUsuarios?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return buildSingleUser(_meusUsuarios[index]);
            },
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
        title: Text(
          widget.nomeMeuUsuario,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xfffae800),
        actions: [
          IconButton(
              icon: new Icon(Icons.exit_to_app),
              tooltip: 'Sair do Chat',
              onPressed: () {
                limpezaDeDados();
                Navigator.pop(context);
              })
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            buildChatDrawerTopo(),
            buildChatDrawerItens(),
          ],
        ),
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

  void _trocaMeDeSala(nomeAmigo, salaDestino) {
    print('\n\n salaDestino :');
    print(salaDestino);
    _channel.trocaDeSala(json.encode({'info': 'chat_change_sala', 'clientId': _channel.meuUsuario.idUsuario, 'nome': widget.nomeMeuUsuario, 'nomeAmigo': nomeAmigo, 'sala': salaDestino}));
  }

  //=================================================================================================

  void _sendMessage(model) {
    if (textEditingController.text.isNotEmpty) {
      print('\n\n Enviando mensagem para a sala');
      print(_channel.salaAtual);
      _channel.enviaMensagem(json.encode({'mensagem': textEditingController.text, 'clientId': _channel.meuUsuario.idUsuario, 'sala': _channel.salaAtual}));
      _atualizaLista(model);
    }
  }

  //=================================================================================================

  void limpezaDeDados([LocalStorage meuStorage]) async {
    _meusUsuarios.clear();
    _minhasMensagens.clear();
    _channel.chatModel.storageSetMensagens();
    _channel.destroySocket();
    await meuStorage?.clear();
  }

  @override
  void dispose() {
    limpezaDeDados(meuStorage);
    super.dispose();
  }
}
