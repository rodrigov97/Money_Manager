class Gastos {
  int id;
  String nome;
  double valor;
  String tipo;
  String data;

  Gastos({
    this.id,
    this.nome,
    this.valor,
    this.tipo,
    this.data,
  });

  factory Gastos.fromMap(Map<String, dynamic> json) => Gastos(
        id: json["id"],
        nome: json["nome"],
        valor: json["valor"],
        tipo: json["tipo"],
        data: json["data"]
      );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "nome": nome,
      "valor": valor,
      "tipo": tipo,
      "data": data
    };

    if (id != null) map["id"] = id;

    return map;
  }
}

class GastosHistorico {
  int id;
  String nome;
  double valor;
  String tipo;
  String data;

  GastosHistorico({
    this.id,
    this.nome,
    this.valor,
    this.tipo,
    this.data,
  });

  factory GastosHistorico.fromMap(Map<String, dynamic> json) => GastosHistorico(
        id: json["id"],
        nome: json["nome"],
        valor: json["valor"],
        tipo: json["tipo"],
        data: json["data"]
      );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "nome": nome,
      "valor": valor,
      "tipo": tipo,
      "data": data
    };

    if (id != null) map["id"] = id;

    return map;
  }
}

