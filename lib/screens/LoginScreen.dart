import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveldiary/apis/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //  controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //  form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // login function
  Future _userLogin() async {
    APIService()
        .login(_emailController.text, _passwordController.text, context)
        .then((value) => {
              if (value == true)
                {
                  Navigator.pushNamed(context, '/buttonNavbarScreen'),
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login Success!')))
                }
              else
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login Failed!')))
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter email';
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter password';
                  }
                },
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _userLogin();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50.0),
                  ),
                  child: const Text('Login')),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Create a new account!'))
            ],
          ),
        ),
      ),
    );
  }
}
