import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Importa el paquete intl
import 'package:smart_wallet_wise/extensions/sizer.dart';
import 'package:smart_wallet_wise/models/transaction.dart';
import 'dart:io'; // Para detectar la plataforma (Android o iOS)

import '../bloc/transaction_bloc.dart';
import 'add_transacion.dart';
import 'average_screen.dart';

class TransactionList extends StatelessWidget {
  TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF263238), Color(0xFF303030)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(
            'Mis Finanzas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.w,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: Stack(
        children: [
          // Fondo con degradado blanco
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  const Color(0xFF212121),
                  Color(0xFF424242)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          BlocProvider(
            create: (_) =>
                context.read<TransactionBloc>()..add(LoadTransactions()),
            child: Column(
              children: [
                // Balance Resumen
                BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, state) {
                    double totalBalance = 0;
                    if (state is TransactionsLoaded) {
                      totalBalance = state.transactions
                          .fold(0.0, (sum, item) => sum + item.amount);

                      return Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blueGrey[900]!, Colors.grey[850]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Balance Total',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 18.w,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '\$${totalBalance.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36.w,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSummaryCard(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ExpenseChartScreen(isIncome: true),
                                      ),
                                    );
                                  },
                                  title: 'Ingresos',
                                  amount: state.transactions
                                      .where((tx) => tx.amount > 0)
                                      .fold(0.0,
                                          (sum, item) => sum + item.amount),
                                  color: Colors.green,
                                ),
                                _buildSummaryCard(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ExpenseChartScreen(isIncome: false),
                                      ),
                                    );
                                  },
                                  title: 'Gastos',
                                  amount: state.transactions
                                      .where((tx) => tx.amount < 0)
                                      .fold(0.0,
                                          (sum, item) => sum + item.amount),
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    return CircularProgressIndicator.adaptive();
                  },
                ),
                SizedBox(height: 20.h),
                // Lista de Transacciones
                Expanded(
                  child: BlocBuilder<TransactionBloc, TransactionState>(
                    builder: (context, state) {
                      if (state is TransactionsLoaded) {
                        return ListView.builder(
                          itemCount: state.transactions.length,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemBuilder: (context, index) {
                            final transaction = state.transactions[index];
                            bool isExpense = transaction.amount < 0;

                            // Formatear la fecha usando intl
                            String formattedDate = DateFormat('dd MMM yyyy')
                                .format(transaction.date);

                            // Descripción truncada
                            String description =
                                transaction.description.length > 50
                                    ? transaction.description.substring(0, 50) +
                                        '...'
                                    : transaction.description;

                            return Card(
                              margin: EdgeInsets.only(bottom: 12.h),
                              elevation: 8, // Sombra más fuerte
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.grey[850]!,
                                      Colors.grey[800]!,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12.w, horizontal: 12.h),
                                  leading: Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color:
                                          isExpense ? Colors.red : Colors.green,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black45,
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      isExpense
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  title: Text(
                                    transaction.title,
                                    style: TextStyle(
                                      fontSize: 18.w,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formattedDate, // Fecha formateada
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14.w,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        description, // Descripción truncada
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 14.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    children: [
                                      Text(
                                        '\$${transaction.amount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: isExpense
                                              ? Colors.red
                                              : Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.w,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(
                                              context, transaction);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is TransactionError) {
                        return Center(child: Text(state.message));
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionScreen()),
          );
        },
        backgroundColor: Colors
            .transparent, // Mantén el fondo transparente para usar el gradiente
        elevation: 4, // Sombra para darle profundidad
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.grey[900]!
              ], // Usamos los mismos colores que el fondo
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(14.0),
            child: Icon(
              Icons.add,
              size: 28.w,
              color: Colors
                  .white, // Ícono blanco para destacarlo sobre el fondo oscuro
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, TransactionModel transaction) {
    // Muestra un diálogo de confirmación antes de borrar
    showDialog(
      context: context,
      builder: (context) {
        return Platform.isAndroid
            ? AlertDialog(
                title: Text("Eliminar Transacción"),
                content: Text(
                    "¿Estás seguro de que deseas eliminar esta transacción?"),
                actions: <Widget>[
                  TextButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
                    },
                  ),
                  TextButton(
                    child: Text("Eliminar"),
                    onPressed: () {
                      context
                          .read<TransactionBloc>()
                          .add(DeleteTransaction(transaction.id!));
                      Navigator.of(context).pop(); // Cierra el diálogo
                    },
                  ),
                ],
              )
            : CupertinoAlertDialog(
                title: Text("Eliminar Transacción"),
                content: Text(
                    "¿Estás seguro de que deseas eliminar esta transacción?"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text("Eliminar"),
                    onPressed: () {
                      context
                          .read<TransactionBloc>()
                          .add(DeleteTransaction(transaction.id!));
                      Navigator.of(context).pop(); // Cierra el diálogo
                    },
                  ),
                ],
              );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.w,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14.w,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 20.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
