import 'dart:convert';

import 'package:emee/services/auth_service.dart';
import 'package:http/http.dart' as http;

Future<String?> refreshAccessToken() async {
  final auth = AuthService();
  final refresh = await auth.getRefreshToken();

  if (refresh == null) return null;

  final res = await http.post(
    Uri.parse('http://10.0.2.2:5001/auth/refresh'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'refreshToken': refresh}),
  );

  if (res.statusCode != 200) {
    await auth.clearTokens();
    return null;
  }
  print('it is refreshed');

  final data = jsonDecode(res.body);
  await auth.saveTokens(data['accessToken'], data['refreshToken']);

  return data['accessToken'];
}