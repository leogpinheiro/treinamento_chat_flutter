import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Objetos/Usuario.dart';
import 'Objetos/Sala.dart';
import 'Objetos/Mensagem.dart';

class ChatModel extends Model {
  List<Sala> salas = List<Sala>();
  LocalStorage myLocalStorage;

//=============================================================================================================================

  void init() {
    adicionaSala('Geral');
  }

//=============================================================================================================================

  void storageSetUsuario(Usuario usuarioAlvo) {
    final String meuJson = json.encode({'id': usuarioAlvo.idUsuario, 'nome': usuarioAlvo.nomeUsuario});
    print('\n meuJson:');
    print(meuJson);

    myLocalStorage.setItem('usuario', meuJson);
    print('\n\n Cheguei aqui usuario \n\n');
  }

  //................................................................................................................................

  void storageSetSalas(List<Sala> salasAlvo) {
    //final List<Sala> minhasSalas = new List<Sala>.from([...salasAlvo]);
    //final Map mapaUsuarios = {};
    //final Map mapaMensagens = {};
    /*
    minhasSalas.forEach((sala) {
      final qtdMensagens = sala.mensagens.length;
      final indiceMinimo = max(0, qtdMensagens - 10);
      final mensagensRangeAlvo = new List<Mensagem>.from(sala.mensagens.getRange(indiceMinimo, qtdMensagens));
      sala.mensagens = mensagensRangeAlvo;
      sala.jsonMensagens = jsonEncode(mensagensRangeAlvo);
    });

    myLocalStorage.deleteItem('salas');
    myLocalStorage.setItem('salas', jsonEncode(minhasSalas));
    */
    salas = salasAlvo;
  }

  //................................................................................................................................

  storageGetUsuario() {
    return myLocalStorage.getItem('usuario');
  }

  //................................................................................................................................

  void storageUpdateSalas() {
    salas = json.decode(myLocalStorage.getItem('salas'))?.toList() ?? salas;
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

  checaSalaExiste(String nomeSala) {
    bool retorno = false;
    salas.forEach((sala) {
      if (sala.nome == nomeSala) retorno = true;
    });
    return retorno;
  }

  void adicionaSala(String nomeSala) {
    Sala instanciaSala = new Sala(nomeSala);
    if (!checaSalaExiste(nomeSala)) {
      salas.add(instanciaSala);
    }
    print('\n\n Cheguei aqui 1 \n\n');
    storageSetSalas(salas);
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
