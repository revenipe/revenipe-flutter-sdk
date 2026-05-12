import 'package:dio/dio.dart';

import '../core/revenipe_config.dart';
import '../exceptions/revenipe_exception.dart';

class RevenipeHttpClient {
  final Dio _dio;

  RevenipeHttpClient({required RevenipeConfig config})
      : _dio = Dio(
          BaseOptions(
            baseUrl: config.baseUrl,
            connectTimeout: config.connectTimeout,
            receiveTimeout: config.receiveTimeout,
            headers: <String, Object?>{
              'Content-Type': 'application/json',
              'Authorization': config.appId,
              ...config.defaultHeaders,
            },
            responseType: ResponseType.json,
          ),
        ) {
    if (config.enableLogging) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
    }
  }

  Dio get rawDio => _dio;

  Future<T> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return parser(response.data);
    } on DioException catch (error) {
      throw RevenipeNetworkException.fromDio(error);
    } catch (error) {
      throw RevenipeUnknownException(error.toString());
    }
  }

  Future<T> post<T>({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return parser(response.data);
    } on DioException catch (error) {
      throw RevenipeNetworkException.fromDio(error);
    } catch (error) {
      throw RevenipeUnknownException(error.toString());
    }
  }

  Future<T> put<T>({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return parser(response.data);
    } on DioException catch (error) {
      throw RevenipeNetworkException.fromDio(error);
    } catch (error) {
      throw RevenipeUnknownException(error.toString());
    }
  }

  Future<T> delete<T>({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return parser(response.data);
    } on DioException catch (error) {
      throw RevenipeNetworkException.fromDio(error);
    } catch (error) {
      throw RevenipeUnknownException(error.toString());
    }
  }
}
