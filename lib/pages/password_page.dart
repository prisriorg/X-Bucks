import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xbucks/helpper/function.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  TextEditingController? emailController;
  TextEditingController? passController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passController = TextEditingController();
  }

  Future<void> signIn() async {
    String? token = await getData("isToken");
    final response = await http.post(
      Uri.parse('${getURL()}change-password'),
      body: jsonEncode(
        {
          'currentPassword': emailController?.text,
          'newPassword': passController?.text,
        },
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Successfully Changed",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
      setState(() {
        passController?.text = "";
        emailController?.text = "";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Network error or incorect password",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        actions: [],
      ),
      body: Center(
        child: Container(
          height: getScreenHeight(context) * 0.5,
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // const Text(
                  //   "Change Password",
                  //   style: TextStyle(
                  //     fontSize: 27,
                  //     color: Colors.white,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  addVerticalSpace(20),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Current Password',
                      icon: Icon(Icons.email_outlined),
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    controller: passController,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                      icon: Icon(Icons.lock_outlined),
                    ),
                  ),
                  addVerticalSpace(50),
                  ElevatedButton(
                    onPressed: signIn,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
