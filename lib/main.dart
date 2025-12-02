import 'package:flutter/material.dart';

void main() {
  runApp(ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ExpenseHome());
  }
}

class ExpenseHome extends StatefulWidget {
  @override
  _ExpenseHomeState createState() => _ExpenseHomeState();
}

class _ExpenseHomeState extends State<ExpenseHome> {
  // Controllers
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  List<Map<String, dynamic>> expenses = [];

  void addExpense() {
    final String amountText = amountController.text.trim();
    final String categoryText = categoryController.text.trim();

    if (amountText.isEmpty || categoryText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() {
      expenses.add({
        'amount': double.tryParse(amountText) ?? 0.0,
        'category': categoryText,
      });
    });

    amountController.clear();
    categoryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text(
          "Expense Tracker",
          style: TextStyle(color: Colors.tealAccent),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF1E1E1E),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // -------- Amount Input ----------
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Amount",
                labelStyle: TextStyle(color: Colors.tealAccent.shade100),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.tealAccent),
                ),
                filled: true,
                fillColor: Color(0xFF1E1E1E),
              ),
            ),
            SizedBox(height: 12),

            // -------- Category Input ----------
            TextField(
              controller: categoryController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Category",
                labelStyle: TextStyle(color: Colors.tealAccent.shade100),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.tealAccent),
                ),
                filled: true,
                fillColor: Color(0xFF1E1E1E),
              ),
            ),
            SizedBox(height: 12),

            // -------- Add Button ----------
            ElevatedButton(
              onPressed: addExpense,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
              ),
              child: Text("Add Expense"),
            ),

            SizedBox(height: 20),

            // -------- Total Expenses ----------
            Text(
              "Total: \$${(() {
                double total = expenses.fold(0.0, (sum, item) => sum + item['amount']);
                return (total % 1 == 0) ? total.toInt() : total;
              })()}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.tealAccent,
              ),
            ),

            // -------- Expense List ----------
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final item = expenses[index];
                  return Card(
                    color: Color(0xFF1E1E1E),
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(
                        Icons.monetization_on,
                        color: Colors.tealAccent,
                      ),
                      title: Text(
                        "${item['category']}",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "Amount: \$${(item['amount'] % 1 == 0) ? item['amount'].toInt() : item['amount']}",
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              setState(() {
                                expenses.removeAt(index);
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blueAccent),
                            onPressed: () {
                              amountController.text = item['amount'].toString();
                              categoryController.text = item['category'];

                              setState(() {
                                expenses.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
