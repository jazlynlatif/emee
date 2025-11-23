import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emee/pages/auth-page/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _birthDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    DateTime? selectedDate;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'sign up'
        ),
      ),
      body: Form(
        key : _formKey,
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
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                decoration: InputDecoration(
                  label: const Text(
                    'First Name'
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your first name';
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                decoration: InputDecoration(
                  label: const Text(
                    'Last Name'
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your last name';
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                controller: _birthDate,
                readOnly: true,
                decoration: InputDecoration(
                  label: const Text(
                    'Birth Date'
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onTap: () async{
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime currDate = DateTime.now();
                  DateTime? pickedDate = await showDatePicker(
                    context: context, 
                    initialDate: currDate,
                    firstDate: DateTime(currDate.year-13), 
                    lastDate: currDate
                  );
                  if(pickedDate != null) {
                    setState(() {
                      _birthDate.text = '${pickedDate.toLocal()}'.split(' ')[0];
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your birth date';
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                decoration: InputDecoration(
                  label: const Text(
                    'Phone number'
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(13)
                ],
                keyboardType: TextInputType.numberWithOptions(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your phone number';
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => {
                if (_formKey.currentState!.validate()) {
                  // for a success
                }
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
              child: Text(
                'sign up',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
             ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?"
                ),
                SizedBox(
                  width: 5
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const LoginPage()
                      )
                    );
                  },
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}