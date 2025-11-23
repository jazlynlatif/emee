import 'package:emee/pages/auth-page/signup.dart';
import 'package:emee/pages/home-page/navpage.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
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
                '[logo]',
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
                      'Username'
                    ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
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
                onPressed: () => {
                  if (_formKey.currentState!.validate()) {
                    // for a success
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const NavPage()
                      )
                    )
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
                    "Don't have an account?"
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