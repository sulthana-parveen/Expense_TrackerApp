import 'package:expense_app/widgets/chart/chart.dart';
import 'package:expense_app/widgets/expensesList/expenses_list.dart';
import 'package:expense_app/models/expense.dart';
import 'package:expense_app/widgets/expensesList/new_expenses.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpense = [
    Expense(
      title: 'Flutter course',
      amount: 799, 
      category: Category.work, 
      date: DateTime.now()
      ),
      Expense(
      title: 'Lunch',
      amount: 250, 
      category: Category.food, 
      date: DateTime.now()
      )
  ];

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context, 
      builder: (ctx) => NewExpenses(onAddExpense: _addExpense,));
  }

  void _addExpense(Expense expense){
  
    setState(() {
      _registeredExpense.add(expense);
    });
   
  }
     void _removeExpense(Expense expense){
      final expenseIndex = _registeredExpense.indexOf(expense);
      setState(() {
      _registeredExpense.remove(expense);
      });
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted'),
      action: SnackBarAction(
        label: 'Undo', 
        onPressed: () {
          setState(() {
            _registeredExpense.insert(expenseIndex,expense);
          });
        }
        ),
        ),
        );
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: const Text('No expenses found. Please add some!...'),
      );
      if(_registeredExpense.isNotEmpty){
        mainContent = ExpensesList(
            expenses: _registeredExpense,
         onRemoveExpense: _removeExpense,);
      }
    return   Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: (){_openAddExpensesOverlay();},
             icon:const Icon(Icons.add))
        ],
      ),
      body: width < 600 ?  Column(
        children: [
        Chart(expenses:_registeredExpense),
         Expanded(
          child:mainContent )
        ],
      ) : Row(children: [
        Chart(expenses:_registeredExpense),
         Expanded(
          child:mainContent )
      ],),
    );
  }
}
