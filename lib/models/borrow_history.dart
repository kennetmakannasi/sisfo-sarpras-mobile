import 'item.dart';

class BorrowHistory {
  final int id;
  final int quantity;
  final String status;
  final String dueDate;
  final Item item;

  BorrowHistory({
    required this.id,
    required this.quantity,
    required this.status,
    required this.dueDate,
    required this.item,
  });

  factory BorrowHistory.fromJson(Map<String, dynamic> json) {
    return BorrowHistory(
      id: json['id'],
      quantity: json['quantity'],
      status: json['status'],
      dueDate: json['due_date'],
      item: Item.fromJson(json['item']),
    );
  }
}
