import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/api_config.dart';

class ApiService {
  final Dio dio;
  final Dio deviceDio;

  ApiService()
      : dio = Dio(BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
          headers: ApiConfig.defaultHeaders,
        )),
        deviceDio = Dio(BaseOptions(
          baseUrl: ApiConfig.deviceUrl,
          connectTimeout: Duration(seconds: 60),
          receiveTimeout: Duration(seconds: 60),
          headers: ApiConfig.defaultHeaders,
          followRedirects: false,
        ));

  // GET request
  Future<Response> get(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await dio.get(endpoint, queryParameters: data);
      _logRequest("GET", "${ApiConfig.baseUrl}$endpoint", null, response);
      return _handleResponse(response);
    } catch (e) {
      throw Exception("GET request failed: $e");
    }
  }

  // POST request
  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await dio.post(endpoint, queryParameters: data);
      _logRequest("POST", "${ApiConfig.baseUrl}$endpoint", data, response);
      return response;
    } catch (e) {
      throw Exception("POST request failed: $e");
    }
  }

  Future<Response> delete(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await dio.delete(endpoint, queryParameters: data);
      _logRequest("DELETE", "${ApiConfig.baseUrl}$endpoint", data, response);
      return response;
    } catch (e) {
      throw Exception("POST request failed: $e");
    }
  }

  // Device GET request
  Future<Response> deviceGet(String endpoint) async {
    try {
      final response = await deviceDio.get(endpoint);
      _logRequest(
          "GET (Device)", "${ApiConfig.deviceUrl}$endpoint", null, response);
      return _handleResponse(response);
    } catch (e) {
      throw Exception("Device GET request failed: $e");
    }
  }

  // Device POST request
  Future<Response> devicePost(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await deviceDio.post(endpoint, data: data);
      _logRequest(
          "POST (Device)", "${ApiConfig.deviceUrl}$endpoint", data, response);
      return _handleResponse(response);
    } catch (e) {
      throw Exception("Device POST request failed: $e");
    }
  }

  // Log request and response details (useful for debugging)
  void _logRequest(String method, String url, Map<String, dynamic>? data,
      Response response) {
    print("[$method] Request: $url");
    if (data != null) print("Payload: ${jsonEncode(data)}");
    print("Response: ${response.statusCode} - ${response.data}");
  }

  // Handle response status
  Response _handleResponse(Response response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response;
    } else {
      throw DioError(
        requestOptions: response.requestOptions,
        response: response,
        error: "HTTP ${response.statusCode}: ${response.data}",
      );
    }
  }
}
