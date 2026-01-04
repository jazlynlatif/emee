import 'package:emee/pages/auth-page/auth_api.dart';
import 'package:emee/pages/home-page/navpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emee/pages/auth-page/login.dart';

class SignUpDetails extends StatefulWidget {
  const SignUpDetails({super.key});

  @override
  State<SignUpDetails> createState() => _SignUpDetailsState();
}

class _SignUpDetailsState extends State<SignUpDetails> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final List<String> _genderDropDown = ['Female', 'Male'];

  void dispose() {
    // TODO: implement dispose
    _firstNameController.dispose();
    _lastNameController.dispose();
    _genderController.dispose();
    _birthDateController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    DateTime? selectedDate;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'register'
        ),
      ),
      body: Form(
        key : _formKey,
        child: Column(
          children: [
            SizedBox(
                height: 15,
            ),
            // Text(
            //   '[logo]',
            //   style: theme.textTheme.titleLarge,
            // ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                decoration: InputDecoration(
                  label: const Text(
                    'Nama Depan'
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
                controller: _firstNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama depan';
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
                    'Nama Belakang'
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
                controller: _lastNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama belakang';
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
                    'Gender'
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  suffixIcon: PopupMenuButton(
                    icon: Icon(Icons.arrow_drop_down),
                    onSelected: ((String value) {
                      setState(() {
                        _genderController.text = value;
                      });
                    }),
                    itemBuilder: (context) {
                      return _genderDropDown.map((String value) {
                        return PopupMenuItem(
                          value : value,
                          child: Text(value)
                        );
                      }).toList();
                    }
                  )
                ),
                controller: _genderController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan gender';
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
                controller: _birthDateController,
                readOnly: true,
                decoration: InputDecoration(
                  label: const Text(
                    'Tanggal Lahir'
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onTap: () async{
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime currDate = DateTime.now();
                  DateTime maxDate = currDate.copyWith(year: currDate.year-13);
                  DateTime? pickedDate = await showDatePicker(
                    context: context, 
                    initialDate: maxDate,
                    firstDate: DateTime(currDate.year-100), 
                    lastDate: maxDate
                  );
                  if(pickedDate != null) {
                    setState(() {
                      _birthDateController.text = '${pickedDate.toLocal()}'.split(' ')[0];
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan tanggal lahir';
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
                    'Nomor Telepon'
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(13)
                ],
                keyboardType: TextInputType.numberWithOptions(),
                controller: _phoneNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nomor telepon';
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // for a success
                  final _birthdate = (_birthDateController.text).toString();
                  print('success');
                  final regisAddInfo = await completeRegister(_firstNameController.text, _lastNameController.text, _genderController.text, _birthdate, _phoneNumberController.text);

                  print('success : after regisAddInfo');

                  if (regisAddInfo.statusCode == 201) {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) => const NavPage())
                    );
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(regisAddInfo.body))
                    );
                  }
                }
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
              child: Text(
                'submit',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
             ),
            ),
            Spacer()
          ],
        ),
      )
    );
  }
}