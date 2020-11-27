import 'package:scoped_model/scoped_model.dart';
import './Usuario.dart';
import './Sala.dart';
import './Mensagem.dart';

class ChatModel extends Model {
  List<Usuario> listaAmigos = List<Usuario>();
  List<Sala> salas = List<Sala>();

  //=============================================================================================================================

  void init() {
    adicionaSala('Geral');
  }

  //=============================================================================================================================

  void atualizaUsuarios(usuarios, salaAlvo) {
    Sala salaAtual = salas.firstWhere((sala) => sala.nome == salaAlvo);

    if (salaAtual != null) {
      salaAtual.usuarios.clear();
      usuarios.forEach((key, usuarioAlvo) {
        salaAtual.usuarios.add(new Usuario(usuarioAlvo["nome"], key.toString(), salaAlvo));
      });
      print("\n}}}}}}} Usuários atualizados \n");
    }
    notifyListeners();
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
    Mensagem instanciaMensagem = new Mensagem(dados['sala'], dados['mensagem'], dados['momento'], dados['clientId'], dados['nome']);
    if (salas != null && salas.length > 0) {
      Sala salaAlvo = salas.firstWhere((sala) => sala.nome == instanciaMensagem.sala);
      salaAlvo?.mensagens?.add(instanciaMensagem);
    }
    notifyListeners();
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
