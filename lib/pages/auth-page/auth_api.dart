import 'dart:convert';

import 'package:emee/services/auth_service.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

final AuthService _authService = AuthService();

Future registerAcc(email, password) async {
  try {
    final url = await http.post(
      Uri.parse('http://10.0.2.2:5001/register'),
      headers: {"Content-type" : "application/json"},
      body: jsonEncode({
        "email" : email,
        "password" : password
      })
    );
    
    return url;

  } catch (err) {
    return http.Response(err.toString(), 500);
  }
  
}

Future completeRegister(String firstname, String lastname, String gender, String birthdate, String phonenumber) async {
 
  try {
    String? token;

    token = await _authService.getToken();

    final url = await http.post(
      Uri.parse('http://10.0.2.2:5001/register/complete'),
      headers : {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "first_name" : firstname,
        "last_name" : lastname,
        "gender" : gender,
        "birth_date" : birthdate,
        "phone_number" : phonenumber
      })
    );

    return url;

  } catch (err) {
    return http.Response(err.toString(), 500);
  }
}

Future loginAcc(email, password) async {
  try {
    final url = await http.post(
      Uri.parse('http://10.0.2.2:5001/login'),
      headers: {"Content-type" : "application/json"},
      body : jsonEncode({
        "email" : email,
        "password" : password
      })
    );

    return url;
  } catch(err) {
    return http.Response(err.toString(), 500);
  }
}

