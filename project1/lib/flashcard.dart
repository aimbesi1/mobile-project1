class FlashCard {
  final int? id;
  final String front;
  final String back;
  final int? setId;

  FlashCard({
    this.id,
    required this.front,
    required this.back,
    this.setId
  });

  Map<String, dynamic> toMap() {
    return {
      '_cid': id,
      'front': front,
      'back': back,
      'sid': setId
    };
  }

  @override
  String toString() {
    return 'id: $id, front: $front, back: $back, setId: $setId';
  }
}