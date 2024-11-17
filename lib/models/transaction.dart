class TransactionModel {
  int? id;
  String title;
  double amount;
  DateTime date;
  String description;
  String type; // "Ingreso" o "Gasto"

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.description = "",
    required this.type,
  });

  // Convertir de un mapa de la base de datos a un objeto Transaction
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      description: map['description'],
      type: map['type'],
    );
  }

  // Convertir de un objeto Transaction a un mapa para la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'type': type,
    };
  }
}
