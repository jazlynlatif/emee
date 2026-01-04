import 'dart:convert';

import 'package:emee/pages/token_api.dart';
import 'package:emee/services/auth_service.dart';
import 'package:http/http.dart' as http;

final AuthService _authService = AuthService();

Future postReport(int service, int indicator1, int indicator2, double latitude, double longitude) async {
  try {
    String? token;
    token = await _authService.getAccessToken();

    var url = await http.post(
      Uri.parse('http://10.0.2.2:5001/report/post'),
      headers : {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "service" : service,
        "indicator1" : indicator1,
        "indicator2" : indicator2,
        "latitude" : latitude,
        "longitude" : longitude
      })
    );

    if (url.statusCode != 200 || url.statusCode != 203) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      url = await http.post(
        Uri.parse('http://10.0.2.2:5001/report/post'),
        headers : {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        },
        body: jsonEncode({
          "service" : service,
          "indicator1" : indicator1,
          "indicator2" : indicator2,
          "latitude" : latitude,
          "longitude" : longitude
        })
      );
    }

    return url;

  } catch (err) {
    throw Exception("error: $err");
  }
}

Future postEndtime(int reportid, String endedat) async {
  try{
    String? token;
    token = await _authService.getAccessToken();

    var url = await http.post(
      Uri.parse('http://10.0.2.2:5001/report/post/ended'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "report_id" : reportid,
        "ended_at" : endedat
      })
    );

    if (url.statusCode != 200 || url.statusCode != 203) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      url = await http.post(
        Uri.parse('http://10.0.2.2:5001/report/post/ended'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        },
        body: jsonEncode({
          "report_id" : reportid,
          "ended_at" : endedat
        })
      );
    }

    return url;
  } catch (err) {
    throw Exception("error: $err");
  }
}

Future postUserAnswer(int reportid, int assesmentid, List<dynamic> userAnswer, List<int> questionId) async {
  try {
    String? token;
    token = await _authService.getAccessToken();

    var url = await http.post(
      Uri.parse('http://10.0.2.2:5001/assesment/answer'),
      headers : {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "reportid" : reportid,
        "assesmentid" : assesmentid,
        "userAnswer" : userAnswer,
        "questionId" : questionId
      })
    );

    if (url.statusCode != 200 || url.statusCode != 203) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      url = await http.post(
        Uri.parse('http://10.0.2.2:5001/assesment/answer'),
        headers : {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        },
        body: jsonEncode({
          "reportid" : reportid,
          "assesmentid" : assesmentid,
          "userAnswer" : userAnswer,
          "questionId" : questionId
        })
      );
    }

    return url;

  } catch (err) {
    throw Exception("error: $err");
  }
}

Future getReport(int reportid) async {
  try {
    String? token;
    token = await _authService.getAccessToken();

    var url = await http.get(
      Uri.parse('http://10.0.2.2:5001/report/get/$reportid'),
      headers : {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
    );

    if (url.statusCode != 200 || url.statusCode != 203) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      url = await http.get(
        Uri.parse('http://10.0.2.2:5001/report/get/$reportid'),
        headers : {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        },
      );
    }

    if(url.statusCode == 200) {
      return jsonDecode(url.body);
    } 
    return {"error" : url.statusCode};

  } catch (err) {
    throw Exception("error: $err");
  }
}

Stream getMessageAndStatus(int report) async*{
  String? token;
  token = await _authService.getAccessToken();
  yield* Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
    try {

      var url = await http.get(
        Uri.parse('http://10.0.2.2:5001/messagestatus/get/$report'),
        headers : {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );

      print(url.statusCode);

      if (url.statusCode != 200 || url.statusCode != 203) {
        // 🔁 TRY REFRESH
        final newToken = await refreshAccessToken();
        print(newToken);
        if (newToken == null) {
          throw Exception('Session expired');
        }

        url = await http.get(
          Uri.parse('http://10.0.2.2:5001/messagestatus/get/$report'),
          headers : {
            "Content-type" : "application/json",
            "Authorization" : "Bearer $token"
          }
        );
      }
      
      if(url.statusCode == 200) {
        return jsonDecode(url.body);
      } 
      return {"error": url.statusCode};

    } catch (err) {
      throw Exception("error: $err");
    }
  });
}

Future getMessageHistory(int report) async{
  String? token;
  token = await _authService.getAccessToken();

  try {
    var url = await http.get(
      Uri.parse('http://10.0.2.2:5001/history/message/get/$report'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      }
    );

    if (url.statusCode != 200 || url.statusCode != 203) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      print(newToken);
      if (newToken == null) {
        throw Exception('Session expired');
      }

      url = await http.get(
        Uri.parse('http://10.0.2.2:5001/history/message/get/$report'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
    }

    return jsonDecode(url.body);
  } catch (err) {
    throw Exception("error: $err");
  }
}

Future getAssesment(int serviceid, int indicator1, int indicator2) async{
  try {
    String? token;
    token = await _authService.getAccessToken();

    var url = await http.get(
      Uri.parse("http://10.0.2.2:5001/user/assesment/get/$serviceid/$indicator1/$indicator2"),
      headers : {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      }
    );

    if (url.statusCode != 200 || url.statusCode != 203) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      url = await http.get(
        Uri.parse("http://10.0.2.2:5001/user/assesment/get/$serviceid/$indicator1/$indicator2"),
        headers : {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
    }

    if(url.statusCode == 200) {
      return jsonDecode(url.body);
    } 
    return {"error": url.statusCode};

  } catch (err) {
    throw Exception("error: $err");
  }
} 

Future getReportInformation(int reportid, int status, int serviceid) async {
  String? token;
  token = await _authService.getAccessToken();

  try {
    var url = await http.get(
      Uri.parse('http://10.0.2.2:5001/report/get/$serviceid/$reportid/$status'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      }
    );

    if (url.statusCode != 200 || url.statusCode != 203) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      url = await http.get(
        Uri.parse('http://10.0.2.2:5001/report/get/$serviceid/$reportid/$status'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
    }

    return jsonDecode(url.body);
  } catch (err) {
    throw Exception("error: $err");
  }
}

Future getAssesmentResult(int reportid) async {
  String? token;
  token = await _authService.getAccessToken();

  try {
    var url = await http.get(
      Uri.parse('http://10.0.2.2:5001/user/assesment/get/$reportid'),
      headers: {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      }
    );

    if (url.statusCode != 200 || url.statusCode != 203) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      url = await http.get(
        Uri.parse('http://10.0.2.2:5001/user/assesment/get/$reportid'),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
    }

    return jsonDecode(url.body);
  } catch (err) {
    throw Exception("error: $err");
  }
}

Future sendMessage(String message, int report) async{
  try {
    String? token;
    token = await _authService.getAccessToken();

    var url = await http.post(
      Uri.parse('http://10.0.2.2:5001/message/send'),
      headers : {
        "Content-type" : "application/json",
        "Authorization" : "Bearer $token"
      },
      body: jsonEncode({
        "message" : message,
        "report" : report
      })
    );

    if (url.statusCode != 200 || url.statusCode != 203) {
      // 🔁 TRY REFRESH
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Session expired');
      }

      url = await http.post(
        Uri.parse('http://10.0.2.2:5001/message/send'),
        headers : {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $token"
        },
        body: jsonEncode({
          "message" : message,
          "report" : report
        })
      );
    }

    return jsonDecode(url.body);

  } catch (err) {
    throw Exception("Network error: $err");
  }
}

