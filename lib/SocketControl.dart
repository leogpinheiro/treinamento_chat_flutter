import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

class SocketControl {
  SocketIO socketIO;

  fazConexao() {
    this.socketIO = SocketIOManager().createSocketIO("http://192.168.0.179:3000", "");
    this.socketIO.init();
    this.socketIO.connect();
  }

  _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }

  _subscribes() {
    if (this.socketIO != null) {
      this.socketIO.subscribe("chat_direct", _onReceiveChatMessage);
    }
  }

  void _onReceiveChatMessage(dynamic message) {
    print("Message from UFO: " + message);
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
}
