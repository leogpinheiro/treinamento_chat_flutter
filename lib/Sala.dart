import 'Mensagem.dart';
import 'Usuario.dart';

class Sala {
  final String nome;
  List<Usuario> usuarios;
  List<Mensagem> mensagens;
  Sala(this.nome);
}
