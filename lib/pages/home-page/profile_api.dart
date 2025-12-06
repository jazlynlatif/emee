import 'dart:convert';

import 'package:emee/services/auth_service.dart';
import 'package:http/http.dart' as http;

final AuthService _authService = AuthService();

// Future fetchServices() async {
//   try {
//     String? token;

//     token = await _authService.getToken();

//     final url = await http.get(
//       Uri.parse('http://10.0.2.2:5001/services'),
//       headers: {
//         "Content-type"  : "application/json",
//         "Authorization" : "Bearer $token",
//       },

//     );
    
//     if(url.statusCode == 200) {
//       return jsonDecode(url.body);
//     } 
//     return {"error" : url.statusCode};
//   } catch (err) {
//     throw Exception("error: $err");
//   }
// }

Future fetchData(String info) async {
  try {
    String? token;

    token = await _authService.getToken();

    final url = await http.get(
      Uri.parse('http://10.0.2.2:5001/retrievedata/$info'),
      headers: {
        "Content-type"  : "application/json",
        "Authorization" : "Bearer $token",
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

Future fetchReportHistory() async {
  try {
    String? token;

    token = await _authService.getToken();

    final url = await http.get(
      Uri.parse('http://10.0.2.2:5001/report/get/all'),
      headers: {
        "Content-type"  : "application/json",
        "Authorization" : "Bearer $token",
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

Future postMedNotesData(String title, String note) async {
  try {
    String? token;

    token = await _authService.getToken();

    final url = await http.post(
      Uri.parse('http://10.0.2.2:5001/adddata/mednotes'),
      headers : {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "title" : title,
        "note" : note
      })
    );

    return url;

  } catch (err) {
    throw Exception("Network error: $err");
  }
}

Future postEmerContactsData(String contact, String phonenumber) async {
  try {
    String? token;

    token = await _authService.getToken();

    final url = await http.post(
      Uri.parse('http://10.0.2.2:5001/adddata/emercontacts'),
      headers : {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "contact" : contact,
        "phone_number" : phonenumber
      })
    );

    return url;

  } catch (err) {
    throw Exception("Network error: $err");
  }
}

Future editMedNotesData(String title, String note, int noteId) async {
  try {
    String? token;

    token = await _authService.getToken();

    print('tryna edit');
    print(noteId);

    final url = await http.put(
      Uri.parse('http://10.0.2.2:5001/editdata/mednotes'),
      headers : {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "title" : title,
        "note" : note,
        "noteId" : noteId
      })
    );


    return url;

  } catch(err) {
    throw Exception("Network error: $err");
  }
}

Future editEmerContactsData(String contact, String phonenumber, int contactId) async {
  try {
    String? token;

    token = await _authService.getToken();

    final url = await http.put(
      Uri.parse('http://10.0.2.2:5001/editdata/emercontacts'),
      headers : {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "contact" : contact,
        "phonenumber" : phonenumber,
        "contactId" : contactId
      })
    );


    return url;

  } catch(err) {
    throw Exception("Network error: $err");
  }
}

Future deleteData(int noteId) async {
  try {
    String? token;

    token = await _authService.getToken();

    final url = await http.delete(
      Uri.parse('http://10.0.2.2:5001/deletedata/$noteId'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      }

    );

    return url;

  } catch (err) {
    throw Exception("Network error: $err");
  }
}