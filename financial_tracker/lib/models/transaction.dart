enum TransactionType { income, expense }

class Transaction {
  final String id; // Make sure id is of type String
  final TransactionType type;
  final double amount;
  final String category;
  final String description;
  final DateTime date; // New date field

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.description,
    required this.date, // Initialize the date field
  });
}
