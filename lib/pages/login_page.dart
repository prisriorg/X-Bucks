import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xbucks/helpper/function.dart';
import 'package:xbucks/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoginSelected = true;
  @override
  void initState() {
    super.initState();
    get();
  }

  Future<void> get() async {
    bool data = await getBoolData("auth") ?? false;
    if (data) {
      navigateToPop(context, const HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child:
                _isLoginSelected ? const LoginWidget() : const SignupWidget(),
            transitionBuilder: (child, animation) {
              final offsetAnimation = Tween<Offset>(
                begin:
                    _isLoginSelected ? const Offset(1, 0) : const Offset(-1, 0),
                end: Offset.zero,
              ).animate(animation);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
          addVerticalSpace(20),
          Container(
            height: 1,
            margin: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: Colors.blue),
          ),
          ToggleLoginSignupButton(
            isLoginSelected: _isLoginSelected,
            onPressed: () {
              setState(() {
                _isLoginSelected = !_isLoginSelected;
              });
            },
          ),
        ],
      ),
    );
  }
}

class ToggleLoginSignupButton extends StatelessWidget {
  final bool isLoginSelected;
  final VoidCallback onPressed;

  const ToggleLoginSignupButton({
    super.key,
    required this.isLoginSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return const Color.fromARGB(255, 36, 138, 159);
              },
            ),
          ),
          onPressed: onPressed,
          child: Text(
            isLoginSelected ? 'Sign Up' : 'Login',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController? emailController;
  TextEditingController? passController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passController = TextEditingController();
  }

  Future<void> signIn() async {
    final response = await http.post(
      Uri.parse('${getURL()}login'),
      body: jsonEncode({
        'username': emailController?.text,
        'password': passController?.text,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      saveData("isToken", jsonResponse['token']);
      saveBoolData("auth", true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Successfully Log In ",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
      navigateToPop(context, const HomePage());
    } else if (response.statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Network error",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Network error 2",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 27,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              addVerticalSpace(20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email_outlined),
                ),
              ),
              TextField(
                obscureText: true,
                controller: passController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock_outlined),
                ),
              ),
              addVerticalSpace(20),
              ElevatedButton(
                onPressed: signIn,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: const Text(
                  'Login',
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
    );
  }
}

class SignupWidget extends StatefulWidget {
  const SignupWidget({super.key});

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  TextEditingController? emailController;
  TextEditingController? passController;
  TextEditingController? conPassController;
  TextEditingController? nameController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passController = TextEditingController();
    conPassController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> signUp() async {
      if (conPassController?.text != passController?.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Password not matched",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      if (nameController?.text == '' &&
          emailController?.text == "" &&
          passController?.text == "") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Please enter name and email",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
        return;
      }
      final response = await http.post(
        Uri.parse('${getURL()}signup'),
        body: jsonEncode({
          'email': emailController?.text,
          'pass': passController?.text,
          'name': nameController?.text
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        saveData("isToken", jsonResponse['token']);
        saveBoolData("auth", true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Successfully SignUp ",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ));
        navigateToPop(context, const HomePage());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Network error",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    }

    return Container(
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
              const Text(
                "Register on Xbucks",
                style: TextStyle(
                  fontSize: 27,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              addVerticalSpace(20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  icon: Icon(Icons.person_outline_rounded),
                ),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email_outlined),
                ),
              ),
              TextField(
                controller: passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock_outline),
                ),
              ),
              TextField(
                controller: conPassController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    icon: Icon(Icons.lock_outline)),
              ),
              addVerticalSpace(30),
              ElevatedButton(
                onPressed: signUp,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: const Text(
                  'Sign Up',
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
    );
  }
}
