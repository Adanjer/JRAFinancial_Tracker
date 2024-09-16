import 'package:riverpod/riverpod.dart';
import '../services/transaction_service.dart';

// Provider for TransactionService
final transactionServiceProvider = Provider<TransactionService>((ref) {
  return TransactionService();
});
