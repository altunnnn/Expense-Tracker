import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // var _enteredTitle = '';

  // void _saveTitle(String title){
  //   _enteredTitle = title;
  // }
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.leisure;
  DateTime? _selectedDate;

  void _showDiologBasedPlatform() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context, builder: (ctx) => CupertinoAlertDialog(
            title: const Text('Invalid input'),
                content: const Text(
                    'Please input valid amount, date, category, title'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Okay'))
                ],
          ));
    } else {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid input'),
                content: const Text(
                    'Please input valid amount, date, category, title'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Okay'))
                ],
              ));
    }
  }

  void _validateExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final isValidAmount = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        isValidAmount ||
        _selectedDate == null) {
      _showDiologBasedPlatform();
      return;
    }
    widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory));
    Navigator.pop(context);
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          // onChanged: _saveTitle,
                          controller: _titleController,
                          maxLength: 50,
                          decoration: InputDecoration(label: Text("Title")),
                        ),
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Expanded(
                          child: TextField(
                        controller: _amountController,
                        decoration: InputDecoration(
                            prefixText: '\$ ', label: Text('Amount')),
                        keyboardType: TextInputType.number,
                      )),
                      SizedBox(
                        width: 16,
                      ),
                    ],
                  )
                else
                  TextField(
                    // onChanged: _saveTitle,
                    controller: _titleController,
                    maxLength: 50,
                    decoration: InputDecoration(label: Text("Title")),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase())))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      SizedBox(
                        width: 24,
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(_selectedDate == null
                              ? 'No date selected'
                              : formatter.format(_selectedDate!)),
                          IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month))
                        ],
                      )),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: _amountController,
                        decoration: InputDecoration(
                            prefixText: '\$ ', label: Text('Amount')),
                        keyboardType: TextInputType.number,
                      )),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(_selectedDate == null
                              ? 'No date selected'
                              : formatter.format(_selectedDate!)),
                          IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month))
                        ],
                      ))
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Exit')),
                      ElevatedButton(
                          onPressed: _validateExpenseData,
                          child: Text('Save Expense'))
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase())))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      Spacer(),
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Exit')),
                      ElevatedButton(
                          onPressed: _validateExpenseData,
                          child: Text('Save Expense'))
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
