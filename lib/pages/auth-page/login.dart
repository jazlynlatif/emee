import 'dart:convert';

import 'package:emee/pages/auth-page/auth_api.dart';
import 'package:emee/pages/auth-page/signup.dart';
import 'package:emee/pages/home-page/navpage.dart';
import 'package:emee/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override 
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'login'
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                'emee',
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  decoration: InputDecoration(
                    label : Text(
                      'Email'
                    ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                  ),
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                  },
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  decoration: InputDecoration(
                    label: Text(
                      'Password'
                    ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // for a success
                    final loginRes = await loginAcc(_emailController.text, _passwordController.text);

                    if(loginRes.statusCode == 200) {
                      final data = jsonDecode(loginRes.body);

                      await _authService.saveTokens(data['accessToken'], data['refreshToken']);

                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => const NavPage()
                        )
                      );
                    }
                    else {
                      print(loginRes.body);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loginRes.body))
                      );
                    }
                    
                    
                  }
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10)
                ),
                child: Text(
                  'login',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
              SizedBox(
                height: 10
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tidak punya akun?"
                  ),
                  SizedBox(
                    width: 5
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => const SignUp()
                        )
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}