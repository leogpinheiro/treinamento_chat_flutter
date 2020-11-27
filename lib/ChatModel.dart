import 'package:scoped_model/scoped_model.dart';
import './Usuario.dart';
import './Sala.dart';
import './Mensagem.dart';

class ChatModel extends Model {
  Usuario usuarioAtual;
  String idAtual;
  List<Usuario> listaAmigos = List<Usuario>();
  List<Sala> salas = List<Sala>();

  //=============================================================================================================================

  void init() {
    adicionaSala('Geral');
  }

  //=============================================================================================================================

  void atualizaPontas(nomeSala) {
    Sala salaAtual = salas.firstWhere((sala) => sala.nome == nomeSala);
    if (salaAtual.usuarios.length > 0 && idAtual != "" && idAtual != null) {
      usuarioAtual = salaAtual.usuarios.firstWhere((usuario) => usuario.idUsuario == idAtual && usuario.sala == nomeSala);
      listaAmigos = salaAtual.usuarios.where((usuario) => usuario.idUsuario != idAtual && usuario.sala == nomeSala)?.toList();
    }
    notifyListeners();
  }

  //=============================================================================================================================

  void adicionaUsuario(dados) {
    Usuario instanciaUsuario = new Usuario(dados["nome"], dados["clientId"], dados["sala"]);
    Sala salaAtual = salas.firstWhere((sala) => sala.nome == dados["sala"]);
    if (salaAtual != null) {
      if (!salaAtual.usuarios.contains(instanciaUsuario)) {
        print("\n\n>>>>>> Usuário adicionado:");
        print(instanciaUsuario.idUsuario);
        print("\n\n");
        salaAtual.usuarios.add(instanciaUsuario);
        salaAtual?.usuarios?.add(instanciaUsuario);
      }
    }
    atualizaPontas(dados["sala"]);
  }

  //=============================================================================================================================

  void adicionaSala(nomeSala) {
    Sala instanciaSala = new Sala(nomeSala);
    if (!salas.contains(instanciaSala)) {
      salas.add(instanciaSala);
    }
  }

  //=============================================================================================================================

  void adicionaMensagem(dados) {
    Mensagem instanciaMensagem = new Mensagem(dados['sala'], dados['mensagem'], dados['momento'], dados['clientId']);
    if (salas != null && salas.length > 0) {
      Sala salaAlvo = salas.firstWhere((sala) => sala.nome == instanciaMensagem.sala);
      salaAlvo?.mensagens?.add(instanciaMensagem);
    }
    atualizaPontas(dados['sala']);
  }

  //=============================================================================================================================

  List<Mensagem> pegaMensagensNaSala(String nomeSala) {
    if (salas != null && salas.length > 0) {
      Sala salaAlvo = salas.firstWhere((sala) => sala.nome == nomeSala);
      return salaAlvo?.mensagens?.toList();
    } else {
      return null;
    }
  }

  List<Usuario> pegaUsuariosNaSala(String nomeSala) {
    if (salas != null && salas.length > 0) {
      Sala salaAlvo = salas.firstWhere((sala) => sala.nome == nomeSala);
      return salaAlvo?.usuarios?.toList();
    } else {
      return null;
    }
  }

  //=============================================================================================================================
}
