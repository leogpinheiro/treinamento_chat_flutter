import 'package:scoped_model/scoped_model.dart';
import './Usuario.dart';
import './Sala.dart';
import './Mensagem.dart';

class ChatModel extends Model {
  Usuario usuarioAtual;
  String idAtual;
  String sala;
  List<Usuario> usuarios = List<Usuario>();
  List<Usuario> listaAmigos = List<Usuario>();
  List<Mensagem> messages = List<Mensagem>();
  List<Sala> salas = List<Sala>();

  //=============================================================================================================================

  void init() {
    atualizaUsuarios();
  }

  //=============================================================================================================================

  void atualizaUsuarios() {
    if (usuarios.length > 0) {
      usuarioAtual = usuarios.firstWhere((usuario) => usuario.idUsuario == idAtual && usuario.sala == sala);
      listaAmigos = usuarios.where((usuario) => usuario.idUsuario != idAtual && usuario.sala == sala).toList();
    }
    notifyListeners();
  }

  //=============================================================================================================================

  void adicionaUsuario(dados) {
    Usuario instanciaUsuario = new Usuario(dados["nome"], dados["clientId"], dados["sala"]);
    usuarios.add(instanciaUsuario);
    Sala salaAlvo = salas.firstWhere((sala) => sala.nome == instanciaUsuario.sala);
    salaAlvo.usuarios.add(instanciaUsuario);
    atualizaUsuarios();
  }

  //=============================================================================================================================

  void adicionaSala(nomeSala) {
    Sala instanciaSala = new Sala(nomeSala);
    instanciaSala.usuarios = usuarios.where((usuario) => usuario.sala == sala).toList();
    salas.add(instanciaSala);
    atualizaUsuarios();
  }

  //=============================================================================================================================

  void adicionaMensagem(dados) {
    print("dados adicionados:");
    print(dados);
    Mensagem instanciaMensagem = new Mensagem(dados['sala'], dados['mensagem'], dados['momento'], dados['clientId']);
    messages.add(instanciaMensagem);
    atualizaUsuarios();
  }

  //=============================================================================================================================

  List<Mensagem> getMessagesForChatID(String chatID) {
    return messages.where((msg) => msg.clientId == chatID || msg.sala == chatID).toList();
  }

  //=============================================================================================================================
}
