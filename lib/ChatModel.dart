import 'package:localstorage/localstorage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Objetos/Usuario.dart';
import 'Objetos/Sala.dart';
import 'Objetos/Mensagem.dart';
import 'dart:convert';
import 'dart:math';

class ChatModel extends Model {
  List<Sala> salas = List<Sala>();
  LocalStorage myLocalStorage;

//=============================================================================================================================

  void init() {
    adicionaSala('Geral');
    storageUpdateMensagens();
  }

//=============================================================================================================================

  void storageSetUsuario(Usuario usuarioAlvo) {
    final String meuJson = json.encode({'id': usuarioAlvo.idUsuario, 'nome': usuarioAlvo.nomeUsuario});
    print('\n meuJson:');
    print(meuJson);

    myLocalStorage.setItem('usuario', meuJson);
    print('\n\n Cheguei aqui usuario \n\n');
  }

  //

  storageGetUsuario() {
    return myLocalStorage.getItem('usuario');
  }

//=============================================================================================================================

  // A função abaixo (storageSetSalas) deve ser chamada quando o app encerrar
  void storageSetMensagens() {
    final List<Sala> minhasSalas = new List<Sala>.from([...salas]);
    String conjuntoMensagens = '';

    if (minhasSalas.length > 0) {
      print('\n >>>>>>>>>>>> Entrei na funcao storageSetSalas <<<<<<< \n\n');

      minhasSalas.forEach((sala) {
        final List<Mensagem> rangeMensagensAlvo = coletaUltimasMensagens(sala.mensagens, 10);

        String mensagensNaSala = '';

        rangeMensagensAlvo.forEach((mensagem) {
          //final String mensagemAlvo = json.encode();
          mensagensNaSala += json.encode({'mensagem': mensagem.mensagem, 'momento': mensagem.momento, 'clientId': mensagem.clientId, 'clientNome': mensagem.clientNome}) + ",";
        });
        conjuntoMensagens += '{"' + sala.nome + '": [' + mensagensNaSala.substring(0, mensagensNaSala.length - 1) + ']},';
      });

      conjuntoMensagens = conjuntoMensagens.replaceAll('\\', '');
      conjuntoMensagens = '{"Salas": [' + conjuntoMensagens.substring(0, conjuntoMensagens.length - 1) + ']}';

      print('jsonConjuntoMensagens:');
      print(conjuntoMensagens);

      myLocalStorage.deleteItem('mensagens');
      myLocalStorage.setItem('mensagens', conjuntoMensagens);
      //storageUpdateMensagens();
    }
  }

  //

  Future<void> storageUpdateMensagens() async {
    bool estouPronto = await myLocalStorage?.ready ?? false;

    if (estouPronto) {
      final String retornoMensagensJson = await myLocalStorage?.getItem('mensagens') ?? '';

      print('\n\n>>>>>>>> retornoMensagensJson: > $retornoMensagensJson < \n\n');

      if (retornoMensagensJson != '' && retornoMensagensJson != null) {
        final Map conjuntoRetorno = json.decode(retornoMensagensJson);
        final List<dynamic> listaSalas = conjuntoRetorno['Salas'];

        print('>>>>>>>> ${listaSalas.runtimeType} : $listaSalas');

        listaSalas.asMap().forEach((chave, conjuntoAlvo) {
          print('>>>>>>>> ${conjuntoAlvo.runtimeType} : $conjuntoAlvo');

          final Map conjuntoMensagens = conjuntoAlvo;

          for (final String nomeSala in conjuntoMensagens.keys) {
            adicionaSala(nomeSala);
            final dados = conjuntoMensagens[nomeSala];
            //adicionaMensagem(dados['sala'], dados['mensagem'], dados['momento'], dados['clientId'], dados['nome']);
            print('>>>>>>> Nome sala: $nomeSala e conteudo = ${conjuntoMensagens[nomeSala]}');
            print('>>>>>>> ${dados.runtimeType} : $dados');
          }
        });
        notifyListeners();
      }
    }
  }

  //

  List<Mensagem> coletaUltimasMensagens(List<Mensagem> mensagens, int qtdDesejada) {
    final qtdMensagens = mensagens.length;
    final indiceMinimo = max(0, qtdMensagens - qtdDesejada);
    return new List<Mensagem>.from(mensagens.getRange(indiceMinimo, qtdMensagens));
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
