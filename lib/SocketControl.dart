import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/io.dart';
import 'ChatModel.dart';
import 'Objetos/Usuario.dart';

class SocketControl {
  //
  final String nomeUsuario;
  final String idPrevio;
  final String salaGeral = 'Geral';
  IOWebSocketChannel socket;
  Usuario meuUsuario;
  String salaAtual;
  ChatModel chatModel;

  //...............................................................................................................................

  SocketControl(this.nomeUsuario, this.idPrevio) {
//
    this.socket = IOWebSocketChannel.connect('ws://192.168.0.179:3000');
    this.salaAtual = salaGeral;
    if (idPrevio != null) {
      this.socket.sink.add(json.encode({'info': 'chat_join_room', 'nome': this.nomeUsuario, 'sala': 'Geral', 'clientId': idPrevio}));
    } else {
      this.socket.sink.add(json.encode({'info': 'chat_join_room', 'nome': this.nomeUsuario, 'sala': 'Geral'}));
    }

    this.socket.stream.listen((message) {
//
      print("\n\n>>>>>> Messagem recebida:");
      print(message);
//
      Map<String, dynamic> data = json.decode(message);
//
      switch (data['info']) {
//
        case 'chat_update_status':
          {
            if (this.meuUsuario == null) {
              this.meuUsuario = new Usuario(data['nome'], data['clientId'], data['sala']);
              print('\n meuUsuario id');
              print(data['clientId']);
              print('\n');
              if (this.chatModel != null) this.chatModel.storageSetUsuario(this.meuUsuario);
            }
          }
          break;

        case 'chat_users_inside':
          {
            if (this.chatModel != null) {
              this.chatModel.adicionaSala(data['sala']);
              this.chatModel.atualizaUsuarios(data['usuarios'], data['sala']);
            }
          }
          break;

        case 'chat_share_message':
          {
            //if (data['sala'] == salaAtual) recebeMensagem(data);
            recebeMensagem(data);
          }
          break;

        case 'chat_changing_room':
          {
            final meuId = meuUsuario.idUsuario;

            print("Usuário trocando de sala para " + data['sala']);
            final mensagens = json.decode(json.encode(data['mensagens']));

            if (data['ordem'].contains(meuId)) {
              final usuariosAlvo = data['ordem'].split("+");
              final usuarioRemetente = usuariosAlvo[0];
              final usuarioDestinatario = usuariosAlvo[1];

              if (usuarioDestinatario == meuId) {
                //$('#listaNome_' + usuarioRemetente).addClass('newmessage');

              } else if (usuarioRemetente == meuId) {
                salaAtual = data['sala'];
                if (mensagens.length > 0) mensagens.forEach((mensagem) => {chatModel.adicionaMensagem(mensagem)});
              }
            } else {
              salaAtual = salaGeral;
              //sufixo = 'na sala ' + salaGeral;
              if (mensagens.length > 0) mensagens.forEach((mensagem) => {chatModel.adicionaMensagem(mensagem)});
            }
          }
          break;
      }
    });
  }

  //...............................................................................................................................

  void trocaDeSala(jsonData) {
    if (this.socket != null) {
      Map<String, dynamic> decoded = jsonDecode(jsonData);
      this.socket.sink.add(json.encode({'info': 'chat_change_sala', 'clientId': decoded['clientId'], 'nome': decoded['nome'], 'nomeAmigo': decoded['nomeAmigo'], 'sala': decoded['sala']}));
    }
  }

  void enviaMensagem(jsonData) {
    if (this.socket != null) {
      Map<String, dynamic> decoded = jsonDecode(jsonData);
      final minhaData = new DateFormat.yMd().add_Hm().format(DateTime.now());
      print('Próximo passo para enviar mensagem para a sala:');
      print(salaAtual);
      this.socket.sink.add(json.encode({'info': 'chat_send_message', 'sala': salaAtual ?? 'Geral', 'mensagem': decoded['mensagem'], 'momento': minhaData, 'clientId': meuUsuario.idUsuario}));
    }
  }

  void recebeMensagem(jsonData) {
    print("\n\n>>>>>>>> Recebi uma mensagem do Chat de fora <<<<<<<<< em \n");
    print(salaAtual);
    print(jsonData);
    if (this.chatModel != null) {
      print('Adicionando mensagem');
      this.chatModel.adicionaMensagem(jsonData);
    }
  }

  //...............................................................................................................................

  socketStatus(dynamic data) {
    print("Socket status: " + data);
  }

  //...............................................................................................................................

  destroySocket() {
    if (this.socket != null) {
      this.chatModel.salas.clear();
      this.socket.sink.close();
    }
  }
}
