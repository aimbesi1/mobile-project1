class CardSet {
  int? id;
  String name;

  CardSet({
    this.id,
    required this.name
  });

  Map<String, dynamic> toMap() {
    return {
      '_sid': id,
      'name': name
    };
  }

  @override
  String toString() {
    return 'id: $id, name: $name';
  }
}