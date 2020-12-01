class Mensagem {
  final String sala;
  final String mensagem;
  final String momento;
  final String clientId;
  final String clientNome;

  Mensagem(this.sala, this.mensagem, this.momento, this.clientId, this.clientNome);

  Map<String, dynamic> toJson() {
    return {'sala': this.sala, 'mensagem': this.mensagem, 'momento': this.momento, 'clientId': this.clientId, 'clientNome': this.clientNome};
  }
}
