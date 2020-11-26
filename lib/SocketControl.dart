import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/io.dart';
import 'ChatModel.dart';

class SocketControl {
  //
  IOWebSocketChannel socket;
  String meuId;
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
            meuId = data['clientId'];
            if (chatModel != null) chatModel.atualizaUsuarios();
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
      print("minhaData = ");
      print(minhaData);
      this.socket.sink.add(json.encode({'info': 'chat_send_message', 'sala': 'Geral', 'mensagem': decoded['mensagem'], 'momento': minhaData, 'clientId': this.meuId}));
    }
  }

  void recebeMensagem(jsonData) {
    print("Recebi uma mensagem do Chat de fora");
    print(jsonData);
    if (chatModel != null) chatModel.adicionaMensagem(jsonData);
  }

  //...............................................................................................................................

  socketStatus(dynamic data) {
    print("Socket status: " + data);
  }

  //...............................................................................................................................

  destroySocket() {
    if (this.socket != null) {
      this.socket.sink.close();
    }
  }
}
