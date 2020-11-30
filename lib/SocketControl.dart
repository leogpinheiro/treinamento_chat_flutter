import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/io.dart';
import 'ChatModel.dart';
import 'Usuario.dart';

class SocketControl {
  //
  IOWebSocketChannel socket;
  Usuario meuUsuario;
  String nomeUsuario;
  final String salaGeral = 'Geral';
  String salaAtual;
  ChatModel chatModel;

  //...............................................................................................................................

  SocketControl(this.nomeUsuario) {
    print(">>>>>>>>> Fui chamado");
    this.socket = IOWebSocketChannel.connect('ws://192.168.0.179:3000');
    this.salaAtual = salaGeral;
    this.socket.sink.add(json.encode({'info': 'chat_join_room', 'nome': this.nomeUsuario, 'sala': 'Geral'}));

    this.socket.stream.listen((message) {
      print("\n\n>>>>>> Messagem recebida:");
      print(message);
      Map<String, dynamic> data = json.decode(message);
      switch (data['info']) {
        case 'chat_update_status':
          {
            if (this.meuUsuario == null) {
              this.meuUsuario = new Usuario(data['nome'], data['clientId'], data['sala']);
            }
          }
          break;

        case 'chat_users_inside':
          {
            if (this.chatModel != null) {
              print("===============================");
              print("data['sala']");
              print(data['sala']);
              print(data['usuarios']);
              this.chatModel.adicionaSala(data['sala']);
              this.chatModel.atualizaUsuarios(data['usuarios'], data['sala']);
            }
          }
          break;

        case 'chat_share_message':
          {
            recebeMensagem(data);
          }
          break;

        case 'chat_changing_room':
          {
            final meuId = meuUsuario.idUsuario;

            print("Usuário trocando de sala para " + data['sala']);
            print("data['ordem'] = " + data['ordem']);
            print("meuId: ");
            print(meuId);

            final usuariosAlvo = data['ordem'].split("+");
            print("1");
            final usuarioRemetente = usuariosAlvo[0];
            print("2");
            final usuarioDestinatario = usuariosAlvo[1];
            print("3");
            final mensagens = data['mensagens'];
            print("4");

            if (data['ordem'].contains(meuId)) {
              print("Algum usuário trocou de sala com sucesso = " + usuarioRemetente);

              if (usuarioDestinatario == meuId) {
                //$('#listaNome_' + usuarioRemetente).addClass('newmessage');

              } else if (usuarioRemetente == meuId) {
                salaAtual = data['sala'];
                print("Mudei para a sala = " + salaAtual);
                mensagens.forEach((mensagem) => {chatModel.adicionaMensagem(mensagem)});
              }
            } else {
              salaAtual = salaGeral;
              //sufixo = 'na sala ' + salaGeral;
              mensagens.forEach((mensagem) => {chatModel.adicionaMensagem(mensagem)});
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
    print("Recebi uma mensagem do Chat de fora");
    print(jsonData);
    if (this.chatModel != null) this.chatModel.adicionaMensagem(jsonData);
  }

  //...............................................................................................................................

  socketStatus(dynamic data) {
    print("Socket status: " + data);
  }

  //...............................................................................................................................

  destroySocket() {
    if (this.socket != null) {
      this.chatModel.salas.clear();
      this.chatModel.listaAmigos.clear();
      this.socket.sink.close();
    }
  }
}
