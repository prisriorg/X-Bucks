import 'package:flutter/material.dart';
import 'package:xbucks/helpper/function.dart';
import 'package:xbucks/pages/upi_page.dart';

class AddAmountPage extends StatefulWidget {
  const AddAmountPage({super.key});

  @override
  State<AddAmountPage> createState() => _AddAmountPageState();
}

class _AddAmountPageState extends State<AddAmountPage> {
  TextEditingController? amountController;
  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
  }

  void addMoney() {
    navigateToPush(context, const UpiPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Balance'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Enter Amount',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                      // prefixIcon: Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: addMoney,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Add Balance'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
