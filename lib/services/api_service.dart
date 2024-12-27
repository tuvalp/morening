import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  // GET request
  static Future<http.Response> get(String endpoint) async {
    try {
      final uri =
          Uri.parse("${ApiConfig.baseUrl}${sanitizeEndpoint(endpoint)}");
      final response = await http
          .get(uri, headers: ApiConfig.defaultHeaders)
          .timeout(const Duration(seconds: 10));
      _logRequest("GET", uri.toString(), null, response);
      return _handleResponse(response);
    } catch (e) {
      throw Exception("GET request failed: $e");
    }
  }

  // POST request
  static Future<http.Response> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final uri =
          Uri.parse("${ApiConfig.baseUrl}${sanitizeEndpoint(endpoint)}");
      final response = await http
          .post(
            uri,
            headers: ApiConfig.defaultHeaders,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));
      _logRequest("POST", uri.toString(), data, response);
      return _handleResponse(response);
    } catch (e) {
      throw Exception("POST request failed: $e");
    }
  }

  // Device GET request
  static Future<http.Response> deviceGet(String endpoint) async {
    try {
      final uri =
          Uri.parse("${ApiConfig.deviceUrl}${sanitizeEndpoint(endpoint)}");
      final response = await http
          .get(uri, headers: ApiConfig.defaultHeaders)
          .timeout(const Duration(seconds: 10));
      _logRequest("GET (Device)", uri.toString(), null, response);
      return _handleResponse(response);
    } catch (e) {
      throw Exception("Device GET request failed: $e");
    }
  }

  // Device POST request
  static Future<http.Response> devicePost(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final uri =
          Uri.parse("${ApiConfig.deviceUrl}${sanitizeEndpoint(endpoint)}");
      final response = await http
          .post(
            uri,
            headers: ApiConfig.defaultHeaders,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));
      _logRequest("POST (Device)", uri.toString(), data, response);
      return _handleResponse(response);
    } catch (e) {
      throw Exception("Device POST request failed: $e");
    }
  }

  // Sanitize endpoint to avoid double slashes
  static String sanitizeEndpoint(String endpoint) {
    return endpoint.startsWith("/") ? endpoint.substring(1) : endpoint;
  }

  // Log request and response details (useful for debugging)
  static void _logRequest(String method, String url, Map<String, dynamic>? data,
      http.Response response) {
    print("[$method] Request: $url");
    if (data != null) print("Payload: ${jsonEncode(data)}");
    print("Response: ${response.statusCode} - ${response.body}");
  }

  // Handle response status
  static http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw HttpException(
        "HTTP ${response.statusCode}: ${response.body}",
        uri: Uri.parse(response.request!.url.toString()),
      );
    }
  }
}
