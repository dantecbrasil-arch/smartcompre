class Estabelecimento {
  final String id;
  final String nome;
  final String endereco;
  final String cidade;
  final String tipo;

  final String? placeId;

  final double? latitude;
  final double? longitude;

  Estabelecimento({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.cidade,
    required this.tipo,
    this.placeId,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'cidade': cidade,
      'tipo': tipo,
      'placeId': placeId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Estabelecimento.fromMap(
    Map<String, dynamic> map,
  ) {
    return Estabelecimento(
      id: map['id'],
      nome: map['nome'],
      endereco: map['endereco'],
      cidade: map['cidade'],
      tipo: map['tipo'],
      placeId: map['placeId'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}