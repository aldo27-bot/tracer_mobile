import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static String baseUrl = "http://127.0.0.1:8000/api";

  // CEK ALUMNI
  static Future cekAlumni(String nim) async {
    var url = Uri.parse("$baseUrl/cek-alumni?nim=$nim");

    var response = await http.get(url);

    return json.decode(response.body);
  }

  // REGISTER
  static Future register(String nim, String email, String password) async {

    var url = Uri.parse("$baseUrl/register");

    var response = await http.post(
      url,
      body: {
        "nim": nim,
        "email": email,
        "password": password
      }
    );

    return json.decode(response.body);
  }

  // LOGIN
  static Future login(String email, String password) async {

    var url = Uri.parse("$baseUrl/login");

    var response = await http.post(
      url,
      body: {
        "email": email,
        "password": password
      }
    );

    return json.decode(response.body);
  }
}