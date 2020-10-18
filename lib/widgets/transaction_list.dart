import 'package:flutter/material.dart';

import './transactions_item.dart';
import '../models/Transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(
    this.transactions,
    this.deleteTx,
  );

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Center(
            child: Text(
              'No Transactions Yet!',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : ListView(
            children: transactions
                .map(
                  (tx) => TransactionItem(
                    transaction: tx,
                    deleteTx: deleteTx,
                  ),
                )
                .toList(),
          );
  }
}
