class Pessoa {
  int? id;
  String nome;
  String fotoPath;

  Pessoa({this.id, required this.nome, required this.fotoPath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'fotoPath': fotoPath,
    };
  }

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      id: map['id'],
      nome: map['nome'],
      fotoPath: map['fotoPath'],
    );
  }
}
