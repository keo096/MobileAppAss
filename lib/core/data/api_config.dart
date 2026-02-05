import 'package:smart_quiz/core/data/api_service.dart';
import 'package:smart_quiz/core/data/mock_api_service.dart';
import 'package:smart_quiz/core/data/remote_api_service.dart';

/// Simple service locator to switch between Mock and Remote APIs
class ApiConfig {
  ApiConfig._();

  static bool useMock = true; // Toggle this to switch between Mock and Postman
  static String postmanBaseUrl = 'https://your-postman-mock-url.com';

  static ApiService get service {
    if (useMock) {
      return MockApiService();
    } else {
      return RemoteApiService(postmanBaseUrl);
    }
  }
}
