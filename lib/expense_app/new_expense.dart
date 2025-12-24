import 'package:first_app/expense_app/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense newExpense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // alway dispose controllers because they use resources even after widget is destroyed
  final _costController = TextEditingController();
  String _titleInput = '';
  DateTime? _selectedDate;
  ExpenseCategory _selectedCategory = ExpenseCategory.other;

  // one of the ways to get input from TextField - but better to use controller above
  void _titleInputHandler(String value) {
    _titleInput = value;
    print('Title input: $value');
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = date;
    });
  }

  void _saveExpense(BuildContext context) {
    final cost = double.tryParse(_costController.text);
    final isCostValid = cost == null || cost < 0;
    if (_titleInput.trim().isEmpty || isCostValid) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Invalid Input"),
          content: Text("Title is empty or Cost invalid !!"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Ok')),
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      Expense.addDate(
        title: _titleInput.trim(),
        amount: cost,
        category: _selectedCategory,
        date: _selectedDate ?? DateTime.now(),
      ),
    );
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add New Expense!'),
          TextField(
            onChanged: _titleInputHandler,
            decoration: InputDecoration(labelText: 'Title'),
            maxLength: 20,
            keyboardType: TextInputType.text,
          ),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _costController,
                    onEditingComplete: () =>
                        _titleInputHandler(_costController.text),
                    decoration: InputDecoration(
                      labelText: 'Cost',
                      prefixText: '\$',
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                Row(
                  children: [
                    Text(
                      _selectedDate != null
                          ? _formatDate(_selectedDate!)
                          : 'No Date Selected',
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          DropdownButton(
            value: _selectedCategory,
            items: ExpenseCategory.values
                .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                .toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('Submitted: ${_costController.text}');
                    _saveExpense(context);
                  },
                  child: Text('Save Expense'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
