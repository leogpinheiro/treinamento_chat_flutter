import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/io.dart';
import 'ChatModel.dart';

class SocketControl {
  //
  IOWebSocketChannel socket;
  String meuId = '';
  String nomeUsuario;
  ChatModel chatModel;

  //...............................................................................................................................

  SocketControl(this.nomeUsuario) {
    print(">>>>>>>>> Fui chamado");
    this.socket = IOWebSocketChannel.connect('ws://192.168.0.179:3000');
    this.socket.sink.add(json.encode({'info': 'chat_join_room', 'nome': this.nomeUsuario, 'sala': 'Geral'}));

    this.socket.stream.listen((message) {
      print("\n\n>>>>>> Messagem recebida:");
      print(message);
      Map<String, dynamic> data = json.decode(message);
      switch (data['info']) {
        case 'chat_update_status':
          {
            if (this.meuId == '' || this.meuId == null) {
              this.meuId = data['clientId'];
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
      }
    });
  }

  //...............................................................................................................................

  void enviaMensagem(jsonData) {
    if (this.socket != null) {
      Map<String, dynamic> decoded = jsonDecode(jsonData);
      final minhaData = new DateFormat.yMd().add_Hm().format(DateTime.now());
      this.socket.sink.add(json.encode({'info': 'chat_send_message', 'sala': 'Geral', 'mensagem': decoded['mensagem'], 'momento': minhaData, 'clientId': this.meuId}));
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
