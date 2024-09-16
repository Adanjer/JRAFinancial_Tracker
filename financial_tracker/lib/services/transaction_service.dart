import '../models/transaction.dart';

class TransactionService {
  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => List.unmodifiable(_transactions);

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
  }

  bool removeTransaction(String id) {
    // Count the number of transactions before removing
    int beforeCount = _transactions.length;

    // Remove transactions with matching id
    _transactions.removeWhere((transaction) => transaction.id == id);

    // Count the number of transactions after removing
    int afterCount = _transactions.length;

    // Return true if any transactions were removed, false otherwise
    return beforeCount != afterCount;
  }

  // Function to display transactions in a graph (bar chart) manner
  void displayTransactionsGraph() {
    print('Income and Expense Bar Chart:');

    for (var transaction in _transactions) {
      String typeLabel =
          transaction.type == TransactionType.income ? 'Income' : 'Expense';
      int barLength =
          (transaction.amount / 100).round(); // Adjust scale for larger numbers

      // Create the bar using ASCII characters
      String bar = List.filled(barLength, '|').join();
      print(
          '$typeLabel - ${transaction.category}: $bar (\$${transaction.amount.toStringAsFixed(2)}) - Date: ${transaction.date.toIso8601String()}');
    }
  }

  double getBalance() {
    double income = _transactions
        .where((transaction) => transaction.type == TransactionType.income)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

    double expense = _transactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

    return income - expense;
  }

  List<Transaction> getTransactionsByCategory(String category) {
    return _transactions
        .where((transaction) => transaction.category == category)
        .toList();
  }
}
