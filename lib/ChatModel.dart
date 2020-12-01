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

  void atualizaUsuarios(usuarios, String nomeSalaAlvo) {
    Sala salaAtual = salas.firstWhere((sala) => sala.nome == nomeSalaAlvo);

    if (salaAtual != null) {
      salaAtual.usuarios.clear();
      usuarios.forEach((key, usuarioAlvo) {
        salaAtual.usuarios.add(new Usuario(usuarioAlvo["nome"], key.toString(), nomeSalaAlvo));
      });
      print("\n}}}}}}} Usuários atualizados \n");
    }
    notifyListeners();
  }

  //=============================================================================================================================

  void adicionaSala(String nomeSala) {
    Sala instanciaSala = new Sala(nomeSala);
    if (!salas.contains(instanciaSala)) {
      salas.add(instanciaSala);
    }
  }

  //=============================================================================================================================

  void adicionaMensagem(dados) {
    Mensagem instanciaMensagem = new Mensagem(dados['sala'], dados['mensagem'], dados['momento'], dados['clientId'], dados['nome']);
    if (salas != null && salas.length > 0) {
      Sala nomeSalaAlvo = salas.firstWhere((sala) => sala.nome == instanciaMensagem.sala);
      nomeSalaAlvo?.mensagens?.add(instanciaMensagem);
    }
    notifyListeners();
  }

  //=============================================================================================================================

  List<Mensagem> pegaMensagensNaSala(String nomeSala) {
    if (salas != null && salas.length > 0) {
      print('Sala nome alvo:');
      print(nomeSala);
      salas.forEach((sala) {
        print('Sala nome item:');
        print(sala.nome);
      });
      Sala nomeSalaAlvo = salas?.firstWhere((sala) => sala.nome == nomeSala);
      return nomeSalaAlvo?.mensagens?.toList();
    } else {
      return null;
    }
  }

  //=============================================================================================================================

  List<Usuario> pegaUsuariosNaSala(String nomeSala) {
    if (salas != null && salas.length > 0) {
      Sala nomeSalaAlvo = salas.firstWhere((sala) => sala.nome == nomeSala);
      return nomeSalaAlvo?.usuarios?.toList();
    } else {
      return null;
    }
  }

  //=============================================================================================================================

  void trocaDeSala(Usuario usuarioAlvo, String nomeSalaAtual, String nomeSalaAlvo) {
    //Sala salaAtual = salas.firstWhere((sala) => sala.nome == nomeSalaAtual);
    adicionaSala(nomeSalaAlvo);
    Sala salaAlvo = salas.firstWhere((sala) => sala.nome == nomeSalaAlvo);
    if (salas != null && salas.length > 0) {
      salaAlvo?.usuarios?.remove(usuarioAlvo);
      salaAlvo?.usuarios?.add(usuarioAlvo);
    }
    notifyListeners();
  }

  //=============================================================================================================================
}
