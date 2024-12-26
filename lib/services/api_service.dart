import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  // GET request
  static Future<http.Response> get(String endpoint) async {
    final uri = Uri.parse("${ApiConfig.baseUrl}$endpoint");
    return await http.get(uri, headers: ApiConfig.defaultHeaders);
  }

  // POST request
  static Future<http.Response> post(
      String endpoint, Map<String, dynamic> data) async {
    final uri = Uri.parse("${ApiConfig.baseUrl}$endpoint");
    return await http.post(
      uri,
      headers: ApiConfig.defaultHeaders,
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> deivceGet(String endpoint) async {
    final uri = Uri.parse("${ApiConfig.deviceUrl}$endpoint");
    return await http.get(uri, headers: ApiConfig.defaultHeaders);
  }

  static Future<http.Response> deivcePost(
      String endpoint, Map<String, dynamic> data) async {
    final uri = Uri.parse("${ApiConfig.deviceUrl}$endpoint");
    return await http.post(
      uri,
      headers: ApiConfig.defaultHeaders,
      body: jsonEncode(data),
    );
  }
}
