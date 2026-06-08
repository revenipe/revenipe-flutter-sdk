import 'package:dio/dio.dart';

sealed class RevenipeException implements Exception {
  final String message;
  final int? statusCode;

  const RevenipeException(this.message, {this.statusCode});

  @override
  String toString() =>
      'RevenipeException(message: $message, statusCode: $statusCode)';
}

class RevenipeConfigurationException extends RevenipeException {
  const RevenipeConfigurationException(super.message);
}

class RevenipeNetworkException extends RevenipeException {
  const RevenipeNetworkException(super.message, {super.statusCode});

  factory RevenipeNetworkException.fromDio(DioException error) {
    final responseData = error.response?.data;
    final responseMessage = responseData is Map<String, dynamic>
        ? responseData['message']?.toString()
        : null;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const RevenipeNetworkException('Connection timeout');
      case DioExceptionType.sendTimeout:
        return const RevenipeNetworkException('Send timeout');
      case DioExceptionType.receiveTimeout:
        return const RevenipeNetworkException('Receive timeout');
      case DioExceptionType.badCertificate:
        return const RevenipeNetworkException('Bad certificate');
      case DioExceptionType.badResponse:
        return RevenipeNetworkException(
          responseMessage ?? 'Bad response from Revenipe API',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return const RevenipeNetworkException('Request cancelled');
      case DioExceptionType.connectionError:
        return const RevenipeNetworkException('Connection error');
      case DioExceptionType.unknown:
        return RevenipeNetworkException(
          error.message ?? 'Unknown network error',
          statusCode: error.response?.statusCode,
        );
    }
  }
}

class RevenipeOperationException implements Exception {
  final String message;
  final int? statusCode;

  const RevenipeOperationException({required this.message, this.statusCode});

  factory RevenipeOperationException.unknown(String message) {
    return RevenipeOperationException(message: message);
  }

  @override
  String toString() {
    return 'RevenipeException(message: $message, statusCode: $statusCode)';
  }
}

class RevenipeUnknownException extends RevenipeException {
  const RevenipeUnknownException(super.message);
}
