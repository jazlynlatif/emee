import 'dart:convert';

import 'package:emee/services/auth_service.dart';
import 'package:http/http.dart' as http;

final AuthService _authService = AuthService();

const String baseUrl = "https://cuddly-athena-emeeapp-f2eaeb08.koyeb.app";

Future registerAcc(email, password) async {
  try {
    final url = await http.post(
      Uri.parse('$baseUrl/register'),
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

    token = await _authService.getAccessToken();

    final url = await http.post(
      Uri.parse('$baseUrl/register/complete'),
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
      Uri.parse('$baseUrl/login'),
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

Future logout() async {
  final auth = AuthService();
  final token = await auth.getAccessToken();

  try {
    if (token != null) {
      final url = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    }

    await auth.clearTokens();
  } catch(err) {
    return http.Response(err.toString(), 500);
  }
  
}

