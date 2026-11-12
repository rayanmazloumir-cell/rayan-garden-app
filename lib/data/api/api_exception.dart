enum ApiErrorKind { network, timeout, server, format, rejected }

/// Error raised by the API layer. The UI translates [kind] into a friendly
/// message; [serverMessage] is shown as-is when the server supplied one.
class ApiException implements Exception {
  const ApiException(
    this.kind, {
    this.serverMessage,
    this.statusCode,
    this.rawBody,
  });

  final ApiErrorKind kind;
  final String? serverMessage;
  final int? statusCode;
  final String? rawBody;

  @override
  String toString() =>
      'ApiException($kind, status: $statusCode, message: $serverMessage)';
}
