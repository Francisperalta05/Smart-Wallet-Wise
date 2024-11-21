import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Asegúrate de tener esta dependencia en pubspec.yaml
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
  String selectedPeriod =
      'Diario'; // Inicializamos con 'Diario' como valor predeterminado
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
    List<BarChartGroupData> barChartData = [];
    List<String> titles = [];
    double maxY = 0;

    if (selectedPeriod == 'Diario') {
      final Map<int, double> dailyData = {};
      for (var transaction in transactions) {
        if ((widget.isIncome && transaction.amount > 0) ||
            (!widget.isIncome && transaction.amount < 0)) {
          final day = transaction.date.day;
          final diff = now.difference(transaction.date).inDays;

          if (diff < 5) {
            // Considerar solo los últimos 5 días
            dailyData[day] = (dailyData[day] ?? 0) + transaction.amount.abs();
          }
        }
      }

      dailyData.forEach((day, amount) {
        barChartData.add(
          BarChartGroupData(
            x: day,
            barRods: [
              BarChartRodData(
                toY: amount,
                color: Colors.blueAccent,
                width: 15,
                borderRadius: BorderRadius.circular(30),
              ),
            ],
            // showingTooltipIndicators: [0],
          ),
        );
        titles.add(day.toString());
        maxY = maxY < amount ? amount : maxY;
      });
    } else if (selectedPeriod == 'Semanal') {
      final Map<int, double> weeklyData = {};
      for (var transaction in transactions) {
        if ((widget.isIncome && transaction.amount > 0) ||
            (!widget.isIncome && transaction.amount < 0)) {
          final week = ((transaction.date.day - 1) / 7).ceil();
          final diff = now.difference(transaction.date).inDays;

          if (diff < 28) {
            // Considerar solo las últimas 4 semanas
            weeklyData[week] =
                (weeklyData[week] ?? 0) + transaction.amount.abs();
          }
        }
      }

      weeklyData.forEach((week, amount) {
        barChartData.add(
          BarChartGroupData(
            x: week,
            barRods: [
              BarChartRodData(
                toY: amount,
                color: Colors.blueAccent,
                width: 15,
                borderRadius: BorderRadius.circular(30),
              ),
            ],
            // showingTooltipIndicators: [0],
          ),
        );
        titles.add('Semana $week');
        maxY = maxY < amount ? amount : maxY;
      });
    } else if (selectedPeriod == 'Mensual') {
      final Map<int, double> monthlyData = {};
      for (var transaction in transactions) {
        if ((widget.isIncome && transaction.amount > 0) ||
            (!widget.isIncome && transaction.amount < 0)) {
          final month = transaction.date.month;
          final diff = now.difference(transaction.date).inDays;

          if (diff < 90) {
            // Considerar solo los últimos 3 meses
            monthlyData[month] =
                (monthlyData[month] ?? 0) + transaction.amount.abs();
          }
        }
      }

      monthlyData.forEach((month, amount) {
        barChartData.add(
          BarChartGroupData(
            x: month,
            barRods: [
              BarChartRodData(
                toY: amount,
                color: Colors.blueAccent,
                width: 15,
                borderRadius: BorderRadius.circular(30),
              ),
            ],
            // showingTooltipIndicators: [0],
          ),
        );
        titles.add(_monthName(month));
        maxY = maxY < amount ? amount : maxY;
      });
    } else if (selectedPeriod == 'Anual') {
      final Map<int, double> yearlyData = {};
      for (var transaction in transactions) {
        if ((widget.isIncome && transaction.amount > 0) ||
            (!widget.isIncome && transaction.amount < 0)) {
          final year = transaction.date.year;
          final diff = now.difference(transaction.date).inDays;

          if (diff < 365) {
            // Considerar solo el último año
            yearlyData[year] =
                (yearlyData[year] ?? 0) + transaction.amount.abs();
          }
        }
      }

      yearlyData.forEach((year, amount) {
        barChartData.add(
          BarChartGroupData(
            x: year,
            barRods: [
              BarChartRodData(
                toY: amount,
                color: Colors.blueAccent,
                width: 15,
                borderRadius: BorderRadius.circular(30),
              ),
            ],
            // showingTooltipIndicators: [0],
          ),
        );
        titles.add(year.toString());
        maxY = maxY < amount ? amount : maxY;
      });
    }

    return {'barChartData': barChartData, 'titles': titles, 'maxY': maxY};
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
            // Descripción arriba del gráfico
            Text(
              widget.isIncome
                  ? 'El gráfico a continuación muestra la evolución de los ingresos en función del periodo seleccionado.'
                  : 'El gráfico a continuación muestra la evolución de los gastos en función del periodo seleccionado.',
              style: TextStyle(
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
              child: BarChart(
                BarChartData(
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
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          // final label = value.toInt().toString();

                          final label = (data["titles"] as List<String>)
                                  .where((element) => element
                                      .contains(value.toInt().toString()))
                                  .firstOrNull ??
                              (data["titles"] as List).firstOrNull.toString();

                          return Text(
                            label,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  // gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: data['barChartData'],
                  maxY: data['maxY'] + 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
