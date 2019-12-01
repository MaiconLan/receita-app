import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Produto {
  int idProduto;
  String nome;
  String descricao;
  Tipo tipo;

  Produto();

  Produto.fromJson(Map<String, dynamic> json)
      : idProduto = json['idProduto'],
        nome = json['nome'],
        descricao = json['descricao'],
        tipo = Tipo.fromJson(json['tipo']);

  Map toJson() => {
        'idProduto': idProduto,
        'nome': nome,
        'descricao': descricao,
        'tipo': tipo,
      };
}

class Tipo {
  int idTipo;
  String nome;

  Tipo.fromJson(Map<String, dynamic> json)
      : idTipo = json['idTipo'],
        nome = json['nome'];

  Map toJson() => {
        'idTipo': idTipo,
        'nome': nome,
      };
}
