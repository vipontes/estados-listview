class Estado {
  String estadoId;
  String estadoNome;
  String estadoSigla;

  Estado(this.estadoId, this.estadoNome, this.estadoSigla);

  Estado.fromJson(Map<String, dynamic> json) {
    estadoId = json['estado_id'];
    estadoNome = json['estado_nome'];
    estadoSigla = json['estado_sigla'];
  }
}
