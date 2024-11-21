import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_wallet_wise/bloc/transaction_bloc.dart';

import 'views/transacion_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Durations.medium4);
  runApp(const MyFinanceApp());
}

class MyFinanceApp extends StatelessWidget {
  const MyFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TransactionBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.indigo,
          textTheme: const TextTheme(
            titleLarge: TextStyle(color: Colors.white),
          ),
        ),
        home: TransactionList(),
      ),
    );
  }
}
