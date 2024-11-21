import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/transaction.dart';
import '../services/database_helper.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  TransactionBloc() : super(TransactionInitial()) {
    // Asociar eventos con sus métodos
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
  }

  // Cargar todas las transacciones
  Future<void> _onLoadTransactions(
      LoadTransactions event, Emitter<TransactionState> emit) async {
    try {
      final transactions = await _dbHelper.getTransactions();
      emit(TransactionsLoaded(transactions)); // Actualizar el estado
    } catch (e) {
      emit(TransactionError('Error al cargar las transacciones. $e'));
    }
  }

  // Agregar una transacción
  Future<void> _onAddTransaction(
      AddTransaction event, Emitter<TransactionState> emit) async {
    try {
      await _dbHelper.addTransaction(event.transaction);
      emit(TransactionAdded());
      Future.delayed(Durations.medium4, () => add(LoadTransactions()));
      // Recargar las transacciones después de agregar
    } catch (e) {
      emit(TransactionError('Error al agregar la transacción. $e'));
    }
  }

  // Eliminar una transacción
  Future<void> _onDeleteTransaction(
      DeleteTransaction event, Emitter<TransactionState> emit) async {
    try {
      await _dbHelper.deleteTransaction(event.id);
      emit(TransactionDeleted());
      add(LoadTransactions()); // Recargar las transacciones después de eliminar
    } catch (e) {
      emit(TransactionError('Error al eliminar la transacción.'));
    }
  }

  // Actualizar una transacción
  Future<void> _onUpdateTransaction(
      UpdateTransaction event, Emitter<TransactionState> emit) async {
    try {
      await _dbHelper.updateTransaction(event.transaction);
      emit(TransactionUpdated());
      add(LoadTransactions()); // Recargar las transacciones después de actualizar
    } catch (e) {
      emit(TransactionError('Error al actualizar la transacción.'));
    }
  }
}
