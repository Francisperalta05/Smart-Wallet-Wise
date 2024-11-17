import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/transaction_bloc.dart';
import 'add_transacion.dart';

class TransactionList extends StatelessWidget {
  TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey[900]!, Colors.grey[850]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            'Mis Finanzas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
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
                colors: [Colors.black, Colors.grey[900]!, Colors.grey[800]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          BlocProvider(
            create: (_) => TransactionBloc()..add(LoadTransactions()),
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
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blueGrey[900]!, Colors.grey[850]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(30)),
                          boxShadow: const [
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
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${totalBalance.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSummaryCard(
                                  title: 'Ingresos',
                                  amount: state.transactions
                                      .where((tx) => tx.amount > 0)
                                      .fold(0.0,
                                          (sum, item) => sum + item.amount),
                                  color: Colors.green,
                                ),
                                _buildSummaryCard(
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
                const SizedBox(height: 20),
                // Lista de Transacciones
                Expanded(
                  child: BlocBuilder<TransactionBloc, TransactionState>(
                    builder: (context, state) {
                      if (state is TransactionsLoaded) {
                        return ListView.builder(
                          itemCount: state.transactions.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            final transaction = state.transactions[index];
                            bool isExpense = transaction.amount < 0;

                            return Card(
                              color: Colors.grey[850],
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color:
                                        isExpense ? Colors.red : Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isExpense
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  transaction.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  "${transaction.date}",
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                trailing: Text(
                                  '\$${transaction.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color:
                                        isExpense ? Colors.red : Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is TransactionError) {
                        return Center(child: Text(state.message));
                      } else {
                        return const Center(child: CircularProgressIndicator());
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
            // shape: BoxShape.circle, // Mantener la forma circular del botón
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: const Icon(
              Icons.add,
              size: 28,
              color: Colors
                  .white, // Ícono blanco para destacarlo sobre el fondo oscuro
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      {required String title, required double amount, required Color color}) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
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
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
