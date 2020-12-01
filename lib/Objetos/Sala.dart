import 'Usuario.dart';
import 'Mensagem.dart';

class Sala {
  final String nome;
  List<Usuario> usuarios = List<Usuario>();
  List<Mensagem> mensagens = List<Mensagem>();

  Sala(this.nome);

  Map<String, dynamic> toJson() {
    return {'nome': this.nome, 'usuarios': this.usuarios, 'mensagens': this.mensagens};
  }
}
