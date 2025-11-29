import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/detection_response.dart';

/// Sound Detection API Client
/// Handles HTTP requests to the backend detection API
class SoundDetectionApiClient {
  static const String baseUrl = 'https://f37aaadfd050.ngrok-free.app';
  static const String detectEndpoint = '/detect';
  static const Duration timeoutDuration = Duration(seconds: 30);

  /// Send audio file to detection API
  ///
  /// [audioFile] - The audio file to send
  /// Returns [DetectionResponse] on success
  /// Throws [Exception] on error
  Future<DetectionResponse> detectSound(File audioFile) async {
    try {
      final uri = Uri.parse('$baseUrl$detectEndpoint');

      // Create multipart request
      final request = http.MultipartRequest('POST', uri);

      // Add audio file
      final audioStream = http.ByteStream(audioFile.openRead());
      final audioLength = await audioFile.length();
      final multipartFile = http.MultipartFile(
        'file',
        audioStream,
        audioLength,
        filename: audioFile.path.split('/').last,
      );

      request.files.add(multipartFile);

      // Add headers
      request.headers.addAll({'Accept': 'application/json'});

      // Send request
      final streamedResponse = await request.send().timeout(timeoutDuration);

      // Read response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Parse success response
        final json = _parseJson(response.body);
        return DetectionResponse.fromJson(json);
      } else {
        // Parse error response
        try {
          final json = _parseJson(response.body);
          final errorResponse = ApiErrorResponse.fromJson(json);
          throw ApiException(
            'API Error: ${errorResponse.detail.first.msg}',
            response.statusCode,
          );
        } catch (e) {
          throw ApiException(
            'Failed to detect sound: ${response.statusCode} - ${response.body}',
            response.statusCode,
          );
        }
      }
    } on http.ClientException catch (e) {
      throw ApiException('Network error: ${e.message}', 0);
    } on SocketException catch (e) {
      throw ApiException('Connection error: ${e.message}', 0);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error: $e', 0);
    }
  }

  /// Parse JSON string to Map
  Map<String, dynamic> _parseJson(String jsonString) {
    try {
      // Handle JSON parsing
      final json = jsonString.trim();
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException('Invalid JSON response: $e', 0);
    }
  }
}

/// API Exception
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
