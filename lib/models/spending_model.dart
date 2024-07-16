class SpendingModel {
  int? id;
  double amount;
  String date;
  String note;
  String colorTile;

  SpendingModel({
    this.id,
    required this.amount,
    required this.date,
    required this.note,
    required this.colorTile,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date,
      'note': note,
      'color': colorTile,
    };
  }

  factory SpendingModel.fromMap(Map<String, dynamic> map) {
    return SpendingModel(
      id: map['id'],
      amount: map['amount'],
      date: map['date'],
      note: map['note'],
      colorTile: map['color'],
    );
  }
}
