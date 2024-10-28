import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xbucks/helpper/function.dart';

import 'package:http/http.dart' as http;
import 'package:xbucks/pages/addamount_page.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    fetchWalletBalance();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchWalletBalance();
    }
    if (state == AppLifecycleState.paused) {
      fetchWalletBalance();
    }
    if (state == AppLifecycleState.inactive) {
      fetchWalletBalance();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(20.0),
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              width: double.infinity,
              height: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    top: 20.0,
                    left: 20.0,
                    child: Text(
                      'Wallet Balance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20.0,
                    left: 20.0,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            _walletBalance.toStringAsFixed(2),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 20.0,
                    right: 10.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {
                        navigateToPush(context, const AddAmountPage());
                      },
                      child: const Text('Add Balance',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  Positioned(
                    top: 10.0,
                    right: 10.0,
                    child: IconButton(
                      icon: const Icon(Icons.done_all),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(right: 10, left: 10),
              itemCount: 2,
              itemBuilder: (context, index) {
                return _widget(
                    type: index == 1 ? true : false,
                    name: index == 1 ? "Funds Added" : "Game Loss",
                    amount: "$index");
              },
            ),
          ),
        ],
      ),
    );
  }

  double _walletBalance = 0.00;
  bool _isLoading = false;

  Future<void> fetchWalletBalance() async {
    setState(() {
      _isLoading = true;
    });

    String? token = await getData("isToken");

    try {
      final response = await http
          .post(Uri.parse('${getURL()}balance'), headers: <String, String>{
        'Authorization': '$token',
      });
      final responseData = json.decode(response.body);

      setState(() {
        _walletBalance = double.parse(responseData['balance'].toString());
      });
    } catch (error) {
      print('Error fetching wallet balance: $error');
      // Handle error here, such as showing a snackbar or dialog
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _widget(
      {required bool type, required String name, required String amount}) {
    return ListTile(
      leading: type
          ? const Icon(Icons.arrow_circle_up, color: Colors.green)
          : const Icon(Icons.arrow_circle_down, color: Colors.red),
      title: Text(
        name,
        style: TextStyle(
          color: type ? const Color.fromARGB(255, 158, 160, 158) : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Text(
        type ? '+$amount' : '-$amount',
        style: TextStyle(
          fontSize: 18,
          color: type ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
