import 'package:flutter/material.dart';

void main() {
  runApp(BudgetTrackerApp());
}

class BudgetTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showIndividualBudgets = false;

  // Dummy data for demonstration purposes
  double totalBudget = 48700;
  final List<Category> categories = [
    Category(name: 'Groceries', budget: -300),
    Category(name: 'Bills', budget: -1000),
    Category(name: 'salary', budget:50000),
  ];

  void addBudget(double budget, String category) {
    setState(() {
      categories.add(Category(name: category, budget: budget));
      totalBudget += budget;
    });
  }

  void deleteBudget(Category category) {
    setState(() {
      categories.remove(category);
      totalBudget -= category.budget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Tracker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  showIndividualBudgets = !showIndividualBudgets;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Budget: \$${totalBudget.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    showIndividualBudgets ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
          if (showIndividualBudgets)
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(categories[index].name),
                  subtitle: Text('Budget: \$${categories[index].budget.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteBudget(categories[index]);
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the Add Expense screen
          await showDialog(
            context: context,
            builder: (BuildContext context) => AddExpenseDialog(addBudget),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ExpenseScreen extends StatelessWidget {
  final Category category;

  ExpenseScreen({required this.category});

  // Dummy data for demonstration purposes
  final List<Expense> expenses = [
    Expense(description: 'Groceries', amount: 50),
    Expense(description: 'Restaurant', amount: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(expenses[index].description),
          subtitle: Text('Amount: \$${expenses[index].amount.toStringAsFixed(2)}'),
        ),
      ),
    );
  }
}

class AddExpenseDialog extends StatefulWidget {
  final Function(double, String) addBudget;

  AddExpenseDialog(this.addBudget);

  @override
  _AddExpenseDialogState createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController budgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Budget'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: categoryController,
            decoration: InputDecoration(labelText: 'Category'),
          ),
          TextField(
            controller: budgetController,
            decoration: InputDecoration(labelText: 'Budget'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            double budget = double.tryParse(budgetController.text) ?? 0.0;
            String category = categoryController.text.trim();
            if (budget > 0 && category.isNotEmpty) {
              widget.addBudget(budget, category);
            }
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}

class Category {
  final String name;
  final double budget;

  Category({required this.name, required this.budget});
}

class Expense {
  final String description;
  final double amount;

  Expense({required this.description, required this.amount});
}
