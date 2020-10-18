import 'package:flutter/material.dart';

import './widgets/add_transactions.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/Transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Budget App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Colors.purple,
        textTheme: ThemeData.light().textTheme.copyWith(
              button: TextStyle(color: Colors.white),
            ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;

  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: '2020-10-11 23:52:19.074202',
    //   title: 'Car',
    //   amount: 120,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransactions(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
      id: txDate.toString(),
      title: txTitle,
      amount: txAmount,
      date: txDate,
    );

    setState(
      () {
        _userTransactions.add(newTx);
      },
    );
  }

  void _deleteTransactions(String id) {
    setState(
      () {
        _userTransactions.removeWhere((tx) => tx.id == id);
      },
    );
  }

  void _startAddNewTransactions(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddNewTransactions(_addNewTransactions),
        );
      },
    );
  }

  Widget txLstWidget(AppBar appBar, double height) {
    return Container(
      color: Colors.greenAccent,
      height: ((MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          height),
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 10.0,
      ),
      child: TransactionList(_userTransactions, _deleteTransactions),
    );
  }

  List<Widget> widgetsLandScapeMode(AppBar appBar) {
    return [
      Switch.adaptive(
        activeColor: Colors.greenAccent,
        value: _showChart,
        onChanged: (val) {
          print(val);
          setState(() {
            _showChart = val;
          });
        },
      ),
      _showChart
          ? Container(
              height: ((MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              child: Card(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(2.0),
                  child: Chart(_recentTransactions),
                ),
              ),
            )
          : txLstWidget(appBar, 0.841),
    ];
  }

  List<Widget> widgetsPotraitMode(AppBar appBar) {
    return [
      Container(
        height: ((MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.28),
        child: Card(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(2.0),
            child: Chart(_recentTransactions),
          ),
        ),
      ),
      txLstWidget(appBar, 0.72)
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text('Budger App'),
      actions: [
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransactions(context),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          if (isLandScape) ...widgetsLandScapeMode(appBar),
          if (!isLandScape) ...widgetsPotraitMode(appBar),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransactions(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
