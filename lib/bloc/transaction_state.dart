part of 'transaction_bloc.dart';

abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionsLoaded extends TransactionState {
  final List<TransactionModel> transactions;
  TransactionsLoaded(this.transactions);
}

class TransactionAdded extends TransactionState {}

class TransactionDeleted extends TransactionState {}

class TransactionUpdated extends TransactionState {}

class TransactionError extends TransactionState {
  final String message;
  TransactionError(this.message);
}
