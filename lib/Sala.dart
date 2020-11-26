import 'Usuario.dart';
import 'Mensagem.dart';

class Sala {
  final String nome;
  List<Usuario> usuarios = List<Usuario>();
  List<Mensagem> mensagens = List<Mensagem>();
  Sala(this.nome);
}
