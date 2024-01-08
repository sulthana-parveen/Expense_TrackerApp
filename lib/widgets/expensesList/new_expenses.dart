import 'package:flutter/material.dart';
import 'package:expense_app/models/expense.dart';
class NewExpenses extends StatefulWidget {
  const NewExpenses({super.key , required this.onAddExpense});
     final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpenses> createState() => _NewExpensesState();
}

class _NewExpensesState extends State<NewExpenses> {
 final _titleController = TextEditingController();
 final _amountController = TextEditingController();
  DateTime? selectedDate;
  Category _selectedCategory = Category.leisure;
  
  void _presentDate() async{
    final now = DateTime.now();
    final firstDate = DateTime(now.year-1,now.month,now.day);
    final lastDate = DateTime.now();
   final pickedDate=  await showDatePicker(
      context: context,
      initialDate:now,
      firstDate: firstDate, lastDate: lastDate
      );
      setState(() {
        selectedDate=pickedDate;
      });
  }
  
  void _submitExpenseDate(){
    final enteredAmount = double.tryParse(_amountController.text);
    final isAmountValid = enteredAmount == null || enteredAmount <= 0;

    if(_titleController.text.trim().isEmpty || isAmountValid|| selectedDate == null){
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text( 'Please make sure that a valid title,amount , date and category was entered..'),
          actions: [
            TextButton(
              onPressed:(){
                Navigator.pop(context);
              }, 
              child: const Text ('Okay'))
          ],
        ));
        return;
    }
    widget.onAddExpense(
      Expense(
        title: _titleController.text, 
        amount: enteredAmount, 
        category:_selectedCategory, 
        date: selectedDate!
        ));
        Navigator.pop(context);
  }
  @override
 void dispose () {
  _titleController.dispose();
  _amountController.dispose();
  super.dispose();
 }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
           controller: _titleController,
            maxLength: 100,
            decoration: const InputDecoration(
              label: Text('Title')
            ),
          ),
          Row(
            children: [
                 Expanded(
                   child: TextField(
                             controller: _amountController,
                             keyboardType: TextInputType.number,
                             decoration: const InputDecoration(
                               prefixText: '₹',
                               label: Text('Amount')
                             ),
                           ),
                 ),
                 const SizedBox(width:8),
                 Expanded(
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Text( selectedDate ==null ?'No Date Selected':formatter.format(selectedDate!) ),
                    IconButton(
                      onPressed:(){
                        _presentDate();
                      },
                       icon: Icon(Icons.calendar_month))
                   ],),
                 )
          ],
          
          ),
        
         const SizedBox(height:20,),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items:Category.values
                .map((category) =>  DropdownMenuItem(
                  value: category,
                  child: Text(
                    category.name.toUpperCase(),
                    ),
                    ),
                    )
                    .toList(), 
                onChanged:(value){
                  if(value == null){
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                ),
                 const Spacer(),
              ElevatedButton(
                onPressed: () {
                 _submitExpenseDate();
                }, 
                child: const Text('Save Expense')),
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                   child: const Text('Cancel'))
            ],
          )
        ],
      ),);
  }
}