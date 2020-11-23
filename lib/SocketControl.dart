import 'dart:developer';

//import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketControl {
  IO.Socket socket;

  fazConexao() {
    this.socket = IO.io('http://192.168.0.179:3000', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'} // optional
    });

    this.socket.connect();

    print(">>>>>>>> Cheguei aqui");

    this.socket.on('chat_share_message', _onReceiveChatMessage);
    this.socket.emit("chat_send_message", {'sala': 'minhaSala', 'mensagem': 'meuTexto', 'momento': '2020-11-23 17:43', 'clientId': '123456789'});
  }

  void _onReceiveChatMessage(dynamic message) {
    print("\n >>>>>> Messagem recebida: ");
    inspect(message);
  }

/*
  _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }

  void _sendChatMessage(String msg) async {
    if (this.socketIO != null) {
      String jsonData =
          '{"message":{"type":"Text","content": ${(msg != null && msg.isNotEmpty) ? '"${msg}"' : '"Hello SOCKET IO PLUGIN :))"'},"owner":"589f10b9bbcd694aa570988d","avatar":"img/avatar-default.png"},"sender":{"userId":"589f10b9bbcd694aa570988d","first":"Ha","last":"Test 2","location":{"lat":10.792273999999999,"long":106.6430356,"accuracy":38,"regionId":null,"vendor":"gps","verticalAccuracy":null},"name":"Ha Test 2"},"receivers":["587e1147744c6260e2d3a4af"],"conversationId":"589f116612aa254aa4fef79f","name":null,"isAnonymous":null}';
      this.socketIO.sendMessage("chat_direct", jsonData, _onReceiveChatMessage);
    }
  }

  _destroySocket() {
    if (this.socketIO != null) {
      SocketIOManager().destroySocket(this.socketIO);
    }
  }
  */
}
