import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as getxc;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:real_proton/utils/apis.dart';
import 'package:real_proton/utils/shared_preference.dart';
import 'package:real_proton/utils/widgets.dart';

class ApiService {
  late Dio _dio;
  final Logger _logger = Logger();

  ApiService({bool isGoogleLogin = false}) {
    BaseOptions options = BaseOptions(
      baseUrl: ApiUtils.BASE_URL,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${isGoogleLogin
            ? SharedPreferencesUtil.getString(SharedPreferenceKey.googleToken)
        :SharedPreferencesUtil.getString(SharedPreferenceKey.loginToken)
        }'
      },
    );

    _dio = Dio(options);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.i("Request: ${options.method} ${options.uri}");
        _logger.d("Headers: ${options.headers}");
        _logger.d("Data: ${options.data}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i("Response [${response.statusCode}]: ${response.data}");
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        _logger.e("Error: ${error.response?.statusCode} ${error.message}");
        if (error.response != null) {
          _logger.d("Error Data: ${error.response?.data}");
        }
        return handler.next(error);
      },
    ));
  }

  void updateAuthorizationToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    _logger.i("Authorization Token Updated: $token");
  }

  /// GraphQL API Call
  Future<Map<String, dynamic>> queryGraphQL(String endpoint, String query, {Map<String, dynamic>? variables}) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: {
          "query": query,
          "variables": variables ?? {},
        },
      );

      if (response.statusCode == 200 && response.data["data"] != null) {
        return response.data["data"];
      } else {
        throw ApiException("GraphQL API Error: ${response.data}");
      }
    } catch (error) {
      if (error is DioException) {
        _logger.e("GraphQL API Error: ${error.response?.data}");
        throw ApiException(error.response?.data['message'] ?? "GraphQL API call failed");
      } else {
        throw ApiException("Unexpected error during GraphQL API call");
      }
    }
  }

  Future<Response> uploadImage(BuildContext context, String endpoint, XFile imageFile) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path, filename: imageFile.name),
    });

    _dio.options.headers['Content-Type'] = 'multipart/form-data';

    return put(context, endpoint, data: formData);
  }

  Future<Response> get(BuildContext context, String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return response;
    } catch (error) {
      if (error is DioException) {
        final errorMessage = error.response?.data['message'] ?? 'Something went wrong while fetching data.';
        _handleError(context, error);
        throw ApiException(errorMessage);
      } else {
        _handleError(context, error);
        throw ApiException('An unexpected error occurred while fetching data.');
      }
    }
  }


  Future<Response> post(BuildContext context, String endpoint, {dynamic data}) async {
    try {
      return await _dio.post(endpoint, data: data);
    } catch (error) {
      if (error is DioException) {
        final errorMessage = error.response?.data['message'] ?? 'error';
        _handleError(context, error);
        throw ApiException(errorMessage);
      } else {
        _handleError(context, error);
        throw ApiException('An unexpected error occurred');
      }
    }
  }


  Future<Response> put(BuildContext context,String endpoint, {dynamic data}) async {
    try {
      return await _dio.put(endpoint, data: data);
    } catch (error) {
      if (error is DioException) {
        final errorMessage = error.response?.data['message'] ?? 'error';
        _handleError(context, error);
        throw ApiException(errorMessage);
      } else {
        _handleError(context, error);
        throw ApiException('An unexpected error occurred');
      }
    }
  }

  Future<Response?> delete(BuildContext context,String endpoint, {dynamic data}) async {
    try {
      return await _dio.delete(endpoint, data: data);
    } catch (error) {
      if (error is DioException) {
        final errorMessage = error.response?.data['message'] ?? 'error';
        _handleError(context, error);
        throw ApiException(errorMessage);
      } else {
        _handleError(context, error);
        throw ApiException('An unexpected error occurred');
      }
    }
  }

  void _handleError(BuildContext context,dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        // CustomWidgets.showError(context: context, message:"${error.response?.data['message']}" );
        _logger.e("DioError Response: ${error.response?.data['message']}");
      } else {
        // CustomWidgets.showError(context: context, message:"Dio error else part:- ${error.message}" );
        _logger.e("DioError: ${error.message}");
      }
    } else {
      // CustomWidgets.showError(context: context, message:"Dio error else part:-$error");
      _logger.e("Unexpected Error: $error");
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

