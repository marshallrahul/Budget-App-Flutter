import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/Transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get _groupTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalAmount = 0.0;
      double recentAmount = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (DateFormat.E().format(recentTransactions[i].date) ==
            DateFormat.E().format(weekDay)) {
          recentAmount += recentTransactions[i].amount;
        }
        totalAmount += recentTransactions[i].amount;
      }

      return {
        'totalAmount': totalAmount,
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': recentAmount,
        'labelHghFct': (recentAmount / totalAmount),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _groupTransactions
          .map(
            (data) => Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ChartBar(
                  data['totalAmount'] == 0.0
                      ? 0.0
                      : data['labelHghFct'] as double,
                  data['amount'],
                  data['day'],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
