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
  List<Sala> salas = List<Sala>();

  //=============================================================================================================================

  void init() {
    atualizaPontas();
  }

  //=============================================================================================================================

  void atualizaPontas() {
    if (usuarios.length > 0) {
      usuarioAtual = usuarios.firstWhere((usuario) => usuario.idUsuario == idAtual && usuario.sala == sala);
      listaAmigos = usuarios.where((usuario) => usuario.idUsuario != idAtual && usuario.sala == sala).toList();
    }
    notifyListeners();
  }

  //=============================================================================================================================

  void adicionaUsuario(dados) {
    Usuario instanciaUsuario = new Usuario(dados["nome"], dados["clientId"], dados["sala"]);
    if (!salas.contains(usuarios)) {
      usuarios.add(instanciaUsuario);
      Sala salaAlvo = salas.firstWhere((sala) => sala.nome == instanciaUsuario.sala);
      salaAlvo.usuarios.add(instanciaUsuario);
      atualizaPontas();
    }
  }

  //=============================================================================================================================

  void adicionaSala(nomeSala) {
    Sala instanciaSala = new Sala(nomeSala);
    if (!salas.contains(instanciaSala)) {
      salas.add(instanciaSala);
      atualizaPontas();
    }
  }

  //=============================================================================================================================

  void adicionaMensagem(dados) {
    print("dados adicionados:");
    print(dados);
    Mensagem instanciaMensagem = new Mensagem(dados['sala'], dados['mensagem'], dados['momento'], dados['clientId']);
    if (salas.length > 0) {
      Sala salaAlvo = salas.firstWhere((sala) => sala.nome == instanciaMensagem.sala);
      salaAlvo.mensagens.add(instanciaMensagem);
    }
    atualizaPontas();
  }

  //=============================================================================================================================

  List<Mensagem> pegaMensagensNaSala(String nomeSala) {
    if (salas.length > 0) {
      Sala salaAlvo = salas.firstWhere((sala) => sala.nome == nomeSala);
      return salaAlvo.mensagens.toList();
    } else {
      return null;
    }
  }

  //=============================================================================================================================
}
