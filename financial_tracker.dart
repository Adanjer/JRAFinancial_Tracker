import 'dart:io';
import 'package:riverpod/riverpod.dart';
import '../lib/models/transaction.dart';
import '../lib/services/transaction_service.dart';
import '../lib/providers/transaction_provider.dart';
import 'package:uuid/uuid.dart';

final container = ProviderContainer();
final uuid = Uuid();

void main() {
  TransactionService transactionService =
      container.read(transactionServiceProvider);

  while (true) {
    print('--------------------Financial-Tracker--------------------');
    print('1. Add a transaction');
    print('2. Remove a transaction');
    print('3. View all transactions');
    print('4. View balance');
    print('5. View transactions by category');
    print('6. View transactions as bar chart'); // New Option for the bar chart
    print('7. Exit');

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        _addTransaction(transactionService);
        break;
      case '2':
        _removeTransaction(transactionService);
        break;
      case '3':
        _viewTransactions(transactionService);
        break;
      case '4':
        _viewBalance(transactionService);
        break;
      case '5':
        _viewTransactionsByCategory(transactionService);
        break;
      case '6': // New case for viewing the bar chart
        _viewTransactionsAsBarChart(transactionService);
        break;
      case '7':
        exit(0);
      default:
        print('Invalid option');
    }
  }
}

// Function to display transactions as bar chart (ASCII-based)
void _viewTransactionsAsBarChart(TransactionService transactionService) {
  if (transactionService.transactions.isEmpty) {
    print('No transactions available.');
  } else {
    transactionService.displayTransactionsGraph(); // Calling the graph method
  }
}

void _addTransaction(TransactionService transactionService) {
  print('Enter transaction type (income/expense):');
  String? typeInput = stdin.readLineSync();
  TransactionType? type;

  if (typeInput == 'income') {
    type = TransactionType.income;
  } else if (typeInput == 'expense') {
    type = TransactionType.expense;
  } else {
    print('Invalid transaction type.');
    return;
  }

  print('Enter amount:');
  double? amount = double.tryParse(stdin.readLineSync() ?? '');
  if (amount == null) {
    print('Invalid amount.');
    return;
  }

  print('Enter category:');
  String? category = stdin.readLineSync();

  print('Enter description:');
  String? description = stdin.readLineSync();

  // New: Input the date
  print('Enter transaction date (YYYY-MM-DD):');
  String? dateInput = stdin.readLineSync();
  DateTime? date;
  try {
    date = DateTime.parse(dateInput ?? '');
  } catch (e) {
    print('Invalid date format. Please use YYYY-MM-DD.');
    return;
  }

  if (category != null && description != null) {
    transactionService.addTransaction(Transaction(
      id: uuid.v4(), // Generating a valid, unique ID
      type: type,
      amount: amount,
      category: category,
      description: description,
      date: date, // Adding the date
    ));
    print('Transaction added successfully.');
  } else {
    print('Failed to add transaction. Please try again.');
  }
}

void _removeTransaction(TransactionService transactionService) {
  print('Enter the transaction ID to remove:');
  String? id = stdin.readLineSync();

  if (id != null && transactionService.removeTransaction(id)) {
    print('Transaction removed successfully.');
  } else {
    print('Transaction not found.');
  }
}

void _viewTransactions(TransactionService transactionService) {
  if (transactionService.transactions.isEmpty) {
    print('No transactions available.');
  } else {
    for (var transaction in transactionService.transactions) {
      print(
          'ID: ${transaction.id}, Type: ${transaction.type}, Amount: ${transaction.amount}, Category: ${transaction.category}, Description: ${transaction.description}, Date: ${transaction.date.toIso8601String()}');
    }
  }
}

void _viewBalance(TransactionService transactionService) {
  print('Current balance: ${transactionService.getBalance()}');
}

void _viewTransactionsByCategory(TransactionService transactionService) {
  print('Enter the category:');
  String? category = stdin.readLineSync();

  var transactions =
      transactionService.getTransactionsByCategory(category ?? '');

  if (transactions.isNotEmpty) {
    for (var transaction in transactions) {
      print(
          'ID: ${transaction.id}, Type: ${transaction.type}, Amount: ${transaction.amount}, Description: ${transaction.description}, Date: ${transaction.date.toIso8601String()}');
    }
  } else {
    print('No transactions found for this category.');
  }
}
