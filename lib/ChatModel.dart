import 'package:scoped_model/scoped_model.dart';
import './Usuario.dart';
import './Mensagem.dart';

class ChatModel extends Model {
  Usuario usuarioAtual;
  String idAtual;
  List<Usuario> usuarios = List<Usuario>();
  List<Usuario> listaAmigos = List<Usuario>();
  List<Mensagem> messages = List<Mensagem>();

  //=============================================================================================================================

  void init() {
    atualizaUsuarios();
  }

  void atualizaUsuarios() {
    if (usuarios.length > 0) {
      usuarioAtual = usuarios.where((usuario) => usuario.idUsuario == idAtual).first;
      listaAmigos = usuarios.where((usuario) => usuario.idUsuario != idAtual).toList();
      notifyListeners();
    }
  }

  //=============================================================================================================================

  List<Mensagem> getMessagesForChatID(String chatID) {
    return messages.where((msg) => msg.clientId == chatID || msg.sala == chatID).toList();
  }

  //=============================================================================================================================
}
