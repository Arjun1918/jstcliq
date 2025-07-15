import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiServices {
  static const String _baseUrl = 'https://your-api-base-url.com/api';
  static const int _connectTimeout = 30000; // 30 seconds
  static const int _receiveTimeout = 30000; // 30 seconds
  static const int _sendTimeout = 30000; // 30 seconds

  static late Dio _dio;

  static void initialize({
    String? baseUrl,
    Map<String, dynamic>? headers,
    int? connectTimeout,
    int? receiveTimeout,
    int? sendTimeout,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? _baseUrl,
        connectTimeout: Duration(
          milliseconds: connectTimeout ?? _connectTimeout,
        ),
        receiveTimeout: Duration(
          milliseconds: receiveTimeout ?? _receiveTimeout,
        ),
        sendTimeout: Duration(milliseconds: sendTimeout ?? _sendTimeout),
        headers:
            headers ??
            {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      LogInterceptor(
        request: kDebugMode,
        requestHeader: kDebugMode,
        requestBody: kDebugMode,
        responseHeader: kDebugMode,
        responseBody: kDebugMode,
        error: kDebugMode,
      ),
    );

    // Add error interceptor
    _dio.interceptors.add(ErrorInterceptor());
  }

  // Get Dio instance
  static Dio get dio {
    if (!_isDioInitialized()) {
      initialize();
    }
    return _dio;
  }

  static bool _isDioInitialized() {
    try {
      return _dio.options.baseUrl.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Set Authorization Token
  static void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Remove Authorization Token
  static void removeAuthToken() {
    dio.options.headers.remove('Authorization');
  }

  // Set Custom Headers
  static void setHeaders(Map<String, dynamic> headers) {
    dio.options.headers.addAll(headers);
  }

  // GET Request
  static Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  // POST Request
  static Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  // PUT Request
  static Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  // PATCH Request
  static Future<Response> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  // DELETE Request
  static Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  // Upload Single File
  static Future<Response> uploadFile(
    String endpoint,
    File file, {
    String fieldName = 'file',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    String? fileName,
  }) async {
    try {
      final formData = FormData();

      // Add file
      formData.files.add(
        MapEntry(
          fieldName,
          await MultipartFile.fromFile(
            file.path,
            filename: fileName ?? file.path.split('/').last,
          ),
        ),
      );

      // Add additional data
      if (data != null) {
        data.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }

      final response = await dio.post(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );

      return response;
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  // Upload Multiple Files
  static Future<Response> uploadMultipleFiles(
    String endpoint,
    List<File> files, {
    String fieldName = 'files',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final formData = FormData();

      // Add files
      for (final file in files) {
        formData.files.add(
          MapEntry(
            fieldName,
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }

      // Add additional data
      if (data != null) {
        data.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }

      final response = await dio.post(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );

      return response;
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  // Upload from Bytes
  static Future<Response> uploadFromBytes(
    String endpoint,
    Uint8List bytes, {
    required String fileName,
    String fieldName = 'file',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final formData = FormData();

      // Add file from bytes
      formData.files.add(
        MapEntry(fieldName, MultipartFile.fromBytes(bytes, filename: fileName)),
      );

      // Add additional data
      if (data != null) {
        data.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }

      final response = await dio.post(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );

      return response;
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  // Download File
  static Future<Response> downloadFile(
    String endpoint,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await dio.download(
        endpoint,
        savePath,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  // Download File as Bytes
  static Future<Uint8List> downloadFileAsBytes(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
        options:
            options?.copyWith(responseType: ResponseType.bytes) ??
            Options(responseType: ResponseType.bytes),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return Uint8List.fromList(response.data);
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  // Form Data Request
  static Future<Response> postFormData(
    String endpoint,
    Map<String, dynamic> fields, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final formData = FormData();

      fields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      final response = await dio.post(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );

      return response;
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  // Custom Request
  static Future<Response> customRequest(
    String endpoint, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await dio.request(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options:
            options?.copyWith(method: method.toUpperCase()) ??
            Options(method: method.toUpperCase()),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  // Retry Request
  static Future<Response> retryRequest(
    Future<Response> Function() request, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        return await request();
      } catch (e) {
        if (i == maxRetries - 1) rethrow;
        await Future.delayed(delay);
      }
    }
    throw Exception('Max retries exceeded');
  }

  // Check Internet Connection
  static Future<bool> checkInternetConnection() async {
    try {
      final response = await dio.get(
        'https://www.google.com',
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Handle Dio Errors
  static ApiException _handleDioError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return const NetworkException('Connection timeout');
        case DioExceptionType.sendTimeout:
          return const NetworkException('Send timeout');
        case DioExceptionType.receiveTimeout:
          return const NetworkException('Receive timeout');
        case DioExceptionType.badResponse:
          return _handleStatusCodeError(error);
        case DioExceptionType.cancel:
          return const ApiException('Request was cancelled');
        case DioExceptionType.connectionError:
          return const NetworkException('Connection error');
        case DioExceptionType.badCertificate:
          return const NetworkException('Bad certificate');
        case DioExceptionType.unknown:
          return ApiException('Unknown error: ${error.message}');
      }
    }
    return ApiException('Unexpected error: ${error.toString()}');
  }

  // Handle Status Code Errors
  static ApiException _handleStatusCodeError(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = _getErrorMessage(error.response?.data);

    switch (statusCode) {
      case 400:
        return BadRequestException(message, statusCode!);
      case 401:
        return UnauthorizedException(message, statusCode!);
      case 403:
        return ForbiddenException(message, statusCode!);
      case 404:
        return NotFoundException(message, statusCode!);
      case 422:
        return ValidationException(message, statusCode!);
      case 500:
        return ServerException(message, statusCode!);
      default:
        return ApiException(message, statusCode);
    }
  }

  // Extract Error Message
  static String _getErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData['message'] ??
          responseData['error'] ??
          responseData['detail'] ??
          'Unknown error occurred';
    }
    return responseData?.toString() ?? 'Unknown error occurred';
  }

  // Cancel all requests
  static CancelToken? _globalCancelToken;

  static void cancelAllRequests() {
    _globalCancelToken?.cancel("Cancelled by user");
    _globalCancelToken = CancelToken();
    // Note: CancelToken should be passed per request, not set globally in options.
  }

  // Close Dio
  static void close() {
    dio.close();
  }
}

// Error Interceptor
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle specific error cases
    if (err.response?.statusCode == 401) {
      // Handle unauthorized access
      // You can redirect to login page or refresh token here
    }

    super.onError(err, handler);
  }
}

// Custom Exception Classes
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message';
}

class NetworkException extends ApiException {
  const NetworkException(String message) : super(message);
}

class BadRequestException extends ApiException {
  const BadRequestException(String message, int statusCode)
    : super(message, statusCode);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(String message, int statusCode)
    : super(message, statusCode);
}

class ForbiddenException extends ApiException {
  const ForbiddenException(String message, int statusCode)
    : super(message, statusCode);
}

class NotFoundException extends ApiException {
  const NotFoundException(String message, int statusCode)
    : super(message, statusCode);
}

class ValidationException extends ApiException {
  const ValidationException(String message, int statusCode)
    : super(message, statusCode);
}

class ServerException extends ApiException {
  const ServerException(String message, int statusCode)
    : super(message, statusCode);
}

// Usage Examples:
/*
// Initialize the service (call this in main.dart)
ApiServices.initialize();

// Set auth token
ApiServices.setAuthToken('your-token-here');

// Basic GET request
try {
  final response = await ApiServices.get('/users');
  print(response.data);
} catch (e) {
  print('Error: $e');
}

// POST request with data
try {
  final response = await ApiServices.post('/users', data: {
    'name': 'John Doe',
    'email': 'john@example.com',
  });
  print(response.data);
} catch (e) {
  print('Error: $e');
}

// Upload file with progress
try {
  final response = await ApiServices.uploadFile(
    '/upload',
    File('path/to/file.jpg'),
    onSendProgress: (sent, total) {
      print('Progress: ${(sent / total * 100).toStringAsFixed(0)}%');
    },
  );
  print(response.data);
} catch (e) {
  print('Error: $e');
}

// Download file with progress
try {
  final response = await ApiServices.downloadFile(
    '/download/file.pdf',
    '/path/to/save/file.pdf',
    onReceiveProgress: (received, total) {
      print('Progress: ${(received / total * 100).toStringAsFixed(0)}%');
    },
  );
  print('File downloaded successfully');
} catch (e) {
  print('Error: $e');
}

// Request with cancellation
CancelToken cancelToken = CancelToken();
try {
  final response = await ApiServices.get('/users', cancelToken: cancelToken);
  print(response.data);
} catch (e) {
  print('Error: $e');
}

// To cancel the request
cancelToken.cancel('Request cancelled by user');
*/
