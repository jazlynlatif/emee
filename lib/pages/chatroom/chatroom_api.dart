import 'dart:convert';

import 'package:emee/services/auth_service.dart';
import 'package:http/http.dart' as http;

final AuthService _authService = AuthService();

Future postReport(int service) async {
  try {
    String? token;
    token = await _authService.getToken();

    final url = await http.post(
      Uri.parse('http://10.0.2.2:5001/report/post'),
      headers : {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "service" : service,
      })
    );

    return url;

  } catch (err) {
    throw Exception("error: $err");
  }
}

Future getReport(int service) async {
  try {
    String? token;
    token = await _authService.getToken();

    final url = await http.get(
      Uri.parse('http://10.0.2.2:5001/report/get/$service'),
      headers : {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
    );

    if(url.statusCode == 200) {
      return jsonDecode(url.body);
    } 
    return {"error" : url.statusCode};

  } catch (err) {
    throw Exception("error: $err");
  }
}

Stream getMessage(int report, int service) async*{
  String? token;
  token = await _authService.getToken();
  yield* Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
    try {

      final url = await http.get(
        Uri.parse('http://10.0.2.2:5001/message/get/$service/$report'),
        headers : {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
      
      if(url.statusCode == 200) {
        return jsonDecode(url.body);
      } 
      return {"error": url.statusCode};

    } catch (err) {
      throw Exception("error: $err");
    }
  });
}

Future getAssesment(int serviceid, int victimid, int victimNumId) async{
  try {
    String? token;
    token = await _authService.getToken();

    final url = await http.get(
      Uri.parse("http://10.0.2.2:5001/$serviceid/assesment/get/$victimid/$victimNumId"),
      headers : {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      }
    );

    if(url.statusCode == 200) {
        return jsonDecode(url.body);
      } 
    return {"error": url.statusCode};

  } catch (err) {
    throw Exception("error: $err");
  }
} 

Future sendMessage(String message, int service, int report) async{
  try {
    String? token;
    token = await _authService.getToken();

    final url = await http.post(
      Uri.parse('http://10.0.2.2:5001/message/send'),
      headers : {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "message" : message,
        "service" : service,
        "report" : report
      })
    );

    return jsonDecode(url.body);

  } catch (err) {
    throw Exception("Network error: $err");
  }
}

