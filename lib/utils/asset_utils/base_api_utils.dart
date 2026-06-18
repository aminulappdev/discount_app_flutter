import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:discount_me_app/utils/utils.dart';
import 'package:dio/dio.dart' as dio;
import 'package:discount_me_app/view/authenticaion/view/sign_in_view.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';

class BaseApiUtils {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      colors: true,
      printEmojis: false,
    ),
  );

  /// -----------------------------------------
  ///  BUILD HEADERS (JSON + MULTIPART) 
  /// -----------------------------------------
  static Map<String, String> _jsonHeaders({
    String authorization = "",
  }) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (authorization != "") "Authorization": "Bearer ${authorization}",
    };
  }

  static Map<String, String> _multipartHeaders({
    String authorization = "",
  }) {
    return {
      "Accept": "application/json",
      if (authorization != "") "Authorization": "Bearer ${authorization}",
    };
  }

  static void _logRequest({
    required String url,
    required String method,
    required Map<String, String> headers,
    Map<String, dynamic>? data,
    dio.FormData? formData,
    Map<String, dynamic>? queryParams,
  }) {
    if (!kDebugMode) return;

    final body = formData != null
        ? {
            "fields": formData.fields
                .map((field) => {
                      "key": field.key,
                      "value": field.value,
                    })
                .toList(),
            "files": formData.files
                .map((file) => {
                      "key": file.key,
                      "filename": file.value.filename,
                    })
                .toList(),
          }
        : data;

    _logger.i(
      'API REQUEST => $method\n'
      'URL => $url\n'
      'Headers => $headers\n'
      'QueryParams => ${queryParams ?? {}}\n'
      'Body => ${body != null ? jsonEncode(body) : null}',
    );
  }

  static void _logResponse({
    required String url,
    required String method,
    required int? statusCode,
    required dio.Headers? headers,
    dynamic responseData,
  }) {
    if (!kDebugMode) return;

    _logger.i(
      'API RESPONSE => $method\n'
      'URL => $url\n'
      'StatusCode => $statusCode\n'
      'Headers => ${headers?.map ?? {}}\n'
      'Body => $responseData',
    );
  }

  static void _logError({
    required String url,
    required String method,
    required int? statusCode,
    required String errorMessage,
    dynamic responseData,
    Object? error,
  }) {
    if (!kDebugMode) return;

    _logger.e(
      'API ERROR => $method\n'
      'URL => $url\n'
      'StatusCode => $statusCode\n'
      'Error => $errorMessage\n'
      'Body => $responseData\n'
      'DioError => $error',
    );
  }

  static String _errorMessageFromResponse(dynamic responseData) {
    const fallbackMessage = "Something went wrong";

    if (responseData is Map<String, dynamic>) {
      final errorModel = ErrorMessageModel.fromJson(responseData);
      return errorModel.message ?? fallbackMessage;
    }

    if (responseData is Map) {
      final errorModel = ErrorMessageModel.fromJson(
        Map<String, dynamic>.from(responseData),
      );
      return errorModel.message ?? fallbackMessage;
    }

    if (responseData is String && responseData.isNotEmpty) {
      try {
        final decodedData = jsonDecode(responseData);
        if (decodedData is Map<String, dynamic>) {
          final errorModel = ErrorMessageModel.fromJson(decodedData);
          return errorModel.message ?? fallbackMessage;
        }
      } catch (_) {
        return responseData;
      }
    }

    return fallbackMessage;
  }

  static String _messageFromResponse(dynamic responseData) {
    const fallbackMessage = "Response message";

    if (responseData is Map<String, dynamic>) {
      return responseData["message"]?.toString() ?? fallbackMessage;
    }

    if (responseData is Map) {
      return responseData["message"]?.toString() ?? fallbackMessage;
    }

    return fallbackMessage;
  }

  /// -----------------------------------------
  ///  UNIVERSAL REQUEST HANDLER
  /// -----------------------------------------
  static Future<void> _request({
    required String url,
    required String method,
    required Function onSuccess,
    required Function onFail,
    required Function onExceptionFail,
    Map<String, dynamic>? data,
    dio.FormData? formData,
    Map<String, dynamic>? queryParams,
    required Map<String, String> headers,
  }) async {
    try {
      _logRequest(
        url: url,
        method: method,
        headers: headers,
        data: data,
        formData: formData,
        queryParams: queryParams,
      );

      final response = await dio.Dio(
        dio.BaseOptions(
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 20),
        ),
      ).request(
        url,
        data: formData ?? (data != null ? jsonEncode(data) : null),
        queryParameters: queryParams,
        options: dio.Options(
          method: method,
          headers: headers,
        ),
      );
      _logResponse(
        url: url,
        method: method,
        statusCode: response.statusCode,
        headers: response.headers,
        responseData: response.data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess(_messageFromResponse(response.data), response.data);
      } else {
        onFail(_errorMessageFromResponse(response.data), response.data);
      }
    } on dio.DioException catch (e) {
      final responseData = e.response?.data;
      final errorMessage = _errorMessageFromResponse(responseData);

      _logError(
        url: url,
        method: method,
        statusCode: e.response?.statusCode,
        errorMessage: errorMessage,
        responseData: responseData,
        error: e,
      );

      if (errorMessage == "jwt expired" || errorMessage == "invalid token") {
        onExceptionFail(errorMessage, responseData);
        await LocalStorageUtils.remove(AppConstantUtils.loginResponse);
        await LocalStorageUtils.remove(AppConstantUtils.loginCredentialResponse);
        await Get.offAll(
          () => SignInView(),
          duration: Duration(milliseconds: 100),
        );
      } else {
        onExceptionFail(errorMessage, responseData);
      }
    } catch (e) {
      _logError(
        url: url,
        method: method,
        statusCode: null,
        errorMessage: "Unexpected error occurred",
        error: e,
      );
      onExceptionFail("Unexpected error occurred", null);
    }
  }

  /// -----------------------------------------
  ///  POST API
  /// -----------------------------------------


  static Future<void> post({
    required String url,
    Map<String, dynamic>? data,
    dio.FormData? formData,
    String authorization = "",
    required Function onSuccess,
    required Function onFail,
    required Function onExceptionFail,
  }) async {
    return _request(
      url: url,
      method: "POST",
      data: data,
      formData: formData,
      headers: formData != null ?
      _multipartHeaders(authorization: authorization) :
      _jsonHeaders(authorization: authorization),
      onSuccess: onSuccess,
      onFail: onFail,
      onExceptionFail: onExceptionFail,
    );
  }


  /// -----------------------------------------
  ///  PUT API
  /// -----------------------------------------


  static Future<void> put({
    required String url,
    Map<String, dynamic>? data,
    dio.FormData? formData,
    String authorization = "",
    required Function onSuccess,
    required Function onFail,
    required Function onExceptionFail,
  }) async {
    return _request(
      url: url,
      method: "PUT",
      data: data,
      formData: formData,
      headers: formData != null ?
      _multipartHeaders(authorization: authorization) :
      _jsonHeaders(authorization: authorization),
      onSuccess: onSuccess,
      onFail: onFail,
      onExceptionFail: onExceptionFail,
    );
  }

  /// -----------------------------------------
  ///  PATCH API
  /// -----------------------------------------


  static Future<void> patch({
    required String url,
    Map<String, dynamic>? data,
    dio.FormData? formData,
    String authorization = "",
    required Function onSuccess,
    required Function onFail,
    required Function onExceptionFail,
  }) async {
    return _request(
      url: url,
      method: "PATCH",
      data: data,
      formData: formData,
      headers: formData != null ?
      _multipartHeaders(authorization: authorization) :
      _jsonHeaders(authorization: authorization),
      onSuccess: onSuccess,
      onFail: onFail,
      onExceptionFail: onExceptionFail,
    );
  }


  /// -----------------------------------------
  ///  DELETE API
  /// -----------------------------------------


  static Future<void> delete({
    required String url,
    Map<String, dynamic>? data,
    dio.FormData? formData,
    String authorization = "",
    required Function onSuccess,
    required Function onFail,
    required Function onExceptionFail,
  }) async {
    return _request(
      url: url,
      method: "DELETE",
      data: data,
      formData: formData,
      headers: formData != null ?
      _multipartHeaders(authorization: authorization) :
      _jsonHeaders(authorization: authorization),
      onSuccess: onSuccess,
      onFail: onFail,
      onExceptionFail: onExceptionFail,
    );
  }


  /// -----------------------------------------
  ///  GET API
  /// -----------------------------------------


  static Future<void> get({
    required String url,
    Map<String, dynamic>? data,
    dio.FormData? formData,
    String authorization = "",
    required Function onSuccess,
    required Function onFail,
    required Function onExceptionFail,
  }) async {
    return _request(
      url: url,
      method: "GET",
      data: data,
      formData: formData,
      headers: formData != null ?
      _multipartHeaders(authorization: authorization) :
      _jsonHeaders(authorization: authorization),
      onSuccess: onSuccess,
      onFail: onFail,
      onExceptionFail: onExceptionFail,
    );
  }

}
