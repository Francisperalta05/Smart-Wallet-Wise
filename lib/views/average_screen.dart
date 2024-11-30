import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_wallet_wise/extensions/sizer.dart';
import '../bloc/transaction_bloc.dart';
import '../models/transaction.dart';

class ExpenseChartScreen extends StatefulWidget {
  final bool isIncome;

  const ExpenseChartScreen({super.key, required this.isIncome});

  @override
  State<ExpenseChartScreen> createState() => _ExpenseChartScreenState();
}

class _ExpenseChartScreenState extends State<ExpenseChartScreen> {
  String selectedPeriod = 'Diario'; // Inicializamos con 'Diario' por defecto
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = _calculateData(
      (context.read<TransactionBloc>().state as TransactionsLoaded)
          .transactions,
    );
  }

  Map<String, dynamic> _calculateData(List<TransactionModel> transactions) {
    final now = DateTime.now();
    List<FlSpot> lineChartData = [];
    List<String> titles = [];
    double maxY = 0;

    // Diariamente
    if (selectedPeriod == 'Diario') {
      final Map<int, double> dailyData = {};
      for (var transaction in transactions) {
        if ((widget.isIncome && transaction.amount > 0) ||
            (!widget.isIncome && transaction.amount < 0)) {
          final day = transaction.date.day;
          final diff = now.difference(transaction.date).inDays;

          if (diff < 5) {
            // Solo los últimos 5 días
            dailyData[day] = (dailyData[day] ?? 0) + transaction.amount.abs();
          }
        }
      }

      dailyData.forEach((day, amount) {
        lineChartData.add(FlSpot(day.toDouble(), amount));
        titles.add(day.toString());
        maxY = maxY < amount ? amount : maxY;
      });
    }
    // Semanalmente
    else if (selectedPeriod == 'Semanal') {
      final Map<int, double> weeklyData = {};
      for (var transaction in transactions) {
        if ((widget.isIncome && transaction.amount > 0) ||
            (!widget.isIncome && transaction.amount < 0)) {
          final week = ((transaction.date.day - 1) / 7).ceil();
          final diff = now.difference(transaction.date).inDays;

          if (diff < 28) {
            // Solo las últimas 4 semanas
            weeklyData[week] =
                (weeklyData[week] ?? 0) + transaction.amount.abs();
          }
        }
      }

      weeklyData.forEach((week, amount) {
        lineChartData.add(FlSpot(week.toDouble(), amount));
        titles.add('Semana $week');
        maxY = maxY < amount ? amount : maxY;
      });
    }
    // Mensualmente
    else if (selectedPeriod == 'Mensual') {
      final Map<int, double> monthlyData = {};
      for (var transaction in transactions) {
        if ((widget.isIncome && transaction.amount > 0) ||
            (!widget.isIncome && transaction.amount < 0)) {
          final month = transaction.date.month;
          final diff = now.difference(transaction.date).inDays;

          if (diff < 90) {
            // Solo los últimos 3 meses
            monthlyData[month] =
                (monthlyData[month] ?? 0) + transaction.amount.abs();
          }
        }
      }

      monthlyData.forEach((month, amount) {
        lineChartData.add(FlSpot(month.toDouble(), amount));
        titles.add(_monthName(month));
        maxY = maxY < amount ? amount : maxY;
      });
    }
    // Anualmente
    else if (selectedPeriod == 'Anual') {
      final Map<int, double> yearlyData = {};
      for (var transaction in transactions) {
        if ((widget.isIncome && transaction.amount > 0) ||
            (!widget.isIncome && transaction.amount < 0)) {
          final year = transaction.date.year;
          final diff = now.difference(transaction.date).inDays;

          if (diff < 365) {
            // Solo el último año
            yearlyData[year] =
                (yearlyData[year] ?? 0) + transaction.amount.abs();
          }
        }
      }

      yearlyData.forEach((year, amount) {
        lineChartData.add(FlSpot(year.toDouble(), amount));
        titles.add(year.toString());
        maxY = maxY < amount ? amount : maxY;
      });
    }

    return {'lineChartData': lineChartData, 'titles': titles, 'maxY': maxY};
  }

  String _monthName(int month) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return months[month - 1];
  }

  String _formatCurrency(double amount) {
    final format = NumberFormat('#,##0.00', 'en_US');
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isIncome ? 'Ingresos' : 'Gastos'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF263238), Color(0xFF303030)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey[900]!, Colors.grey[800]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 16),
        child: Column(
          children: [
            // Descripción
            Text(
              widget.isIncome
                  ? 'El gráfico muestra la evolución de los ingresos.'
                  : 'El gráfico muestra la evolución de los gastos.',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedPeriod,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: ['Diario', 'Semanal', 'Mensual', 'Anual']
                  .map((period) => DropdownMenuItem(
                        value: period,
                        child: Text(period),
                      ))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedPeriod = newValue!;
                  data = _calculateData(
                    (context.read<TransactionBloc>().state
                            as TransactionsLoaded)
                        .transactions,
                  );
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 75.w,
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              _formatCurrency(value),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final label = (data["titles"] as List<String>)
                              .where((element) =>
                                  element.contains(value.toInt().toString()))
                              .firstOrNull;
                          return Text(
                            label ?? '',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data['lineChartData'],
                      isCurved: true,
                      color: Colors.blueAccent,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  maxY: data['maxY'] + 100,
                  minY: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
