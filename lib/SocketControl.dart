import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/io.dart';

class SocketControl {
  IOWebSocketChannel socket;
  String meuId;
  String nomeUsuario;

  SocketControl(this.nomeUsuario) {
    print(">>>>>>>>> Fui chamado");
    this.socket = IOWebSocketChannel.connect('ws://192.168.0.179:3000');
    this.socket.sink.add(json.encode({'info': 'chat_join_room', 'nome': this.nomeUsuario, 'sala': 'Geral'}));

    this.socket.stream.listen((message) {
      print("\n>>>>>> Messagem recebida:");
      print(message);
      Map<String, dynamic> data = json.decode(message);
      switch (data['info']) {
        case 'chat_update_status':
          {
            meuId = data['clientId'];
          }
          break;
      }
    });
  }

  void enviaMensagem(jsonData) {
    if (this.socket != null) {
      Map<String, dynamic> decoded = jsonDecode(jsonData);
      this.socket.sink.add(json.encode({'info': 'chat_send_message', 'sala': 'Geral', 'mensagem': decoded['mensagem'], 'momento': new DateFormat.yMd().add_Hm().toString(), 'clientId': this.meuId}));
    }
  }

  _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }

  _destroySocket() {
    if (this.socket != null) {
      this.socket.sink.close();
    }
  }
}
