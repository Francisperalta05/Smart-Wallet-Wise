part of 'transaction_bloc.dart';

abstract class TransactionEvent {}

class LoadTransactions extends TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final TransactionModel transaction;
  AddTransaction(this.transaction);
}

class DeleteTransaction extends TransactionEvent {
  final int id;
  DeleteTransaction(this.id);
}

class UpdateTransaction extends TransactionEvent {
  final TransactionModel transaction;
  UpdateTransaction(this.transaction);
}
