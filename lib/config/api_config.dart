class ApiConfig {
  static const String baseUrl =
      "http://morenign-prod-dev-851050842.eu-north-1.elb.amazonaws.com:3250/api/v1/";
  static const String deviceUrl = "http://10.42.0.1:5000/";

  static const Map<String, String> defaultHeaders = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Connection": "keep-alive"
  };
}
