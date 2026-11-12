import 'dart:async';
import 'dart:convert';
import 'dart:io' show IOException;

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import 'api_exception.dart';
import 'response_parsers.dart';

/// A successfully received (2xx) and JSON-decoded response.
class ApiResponse {
  const ApiResponse({required this.json, required this.rawBody, required this.statusCode});

  final dynamic json;
  final String rawBody; // truncated, for diagnostics only
  final int statusCode;
}

/// Thin HTTP + JSON layer. It knows nothing about services or bookings.
class ApiClient {
  ApiClient({http.Client? client, String? baseUrl, Duration? timeout})
      : _client = client ?? http.Client(),
        _base = baseUrl ?? AppConfig.apiBase,
        _timeout = timeout ?? AppConfig.requestTimeout;

  // An honest, distinctive User-Agent (the app's own name) so the host can
  // identify and allow-list the app. It is deliberately NOT a browser string.
  static const String _userAgent = 'RayanGardenApp/1.0 (Android)';
  static const Map<String, String> _getHeaders = {
    'Accept': 'application/json',
    'User-Agent': _userAgent,
  };
  static const Map<String, String> _postHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=utf-8',
    'User-Agent': _userAgent,
  };

  final http.Client _client;
  final String _base;
  final Duration _timeout;

  Uri _uri(String path, [Map<String, String>? query]) {
    final uri = Uri.parse('$_base$path');
    return (query == null || query.isEmpty)
        ? uri
        : uri.replace(queryParameters: query);
  }

  Future<ApiResponse> get(String path, {Map<String, String>? query}) async {
    final response = await _send(() => _client.get(
          _uri(path, query),
          headers: _getHeaders,
        ));
    return _decode(response);
  }

  Future<ApiResponse> post(String path, Map<String, dynamic> body) async {
    final response = await _send(() => _client.post(
          _uri(path),
          headers: _postHeaders,
          body: jsonEncode(body),
        ));
    return _decode(response);
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(_timeout);
    } on TimeoutException {
      throw const ApiException(ApiErrorKind.timeout);
    } on http.ClientException {
      throw const ApiException(ApiErrorKind.network);
    } on IOException {
      // SocketException, HandshakeException, TlsException, ...
      throw const ApiException(ApiErrorKind.network);
    }
  }

  ApiResponse _decode(http.Response response) {
    var text = utf8.decode(response.bodyBytes, allowMalformed: true);
    if (text.startsWith('﻿')) text = text.substring(1);
    final status = response.statusCode;
    final snippet = text.length > 600 ? '${text.substring(0, 600)}…' : text;

    dynamic json;
    var parsed = true;
    try {
      json = jsonDecode(text);
    } on FormatException {
      parsed = false;
    }

    if (status < 200 || status >= 300) {
      // Keep the evidence (request, response headers, body) for troubleshooting.
      // A non-JSON body (e.g. an HTML 403 page) is NOT treated as JSON.
      final message = parsed ? extractServerMessage(json) : null;
      final evidence = StringBuffer()
        ..writeln('${response.request?.method} ${response.request?.url}');
      response.headers.forEach((k, v) {
        if (k.toLowerCase() != 'set-cookie') evidence.writeln('$k: $v');
      });
      evidence
        ..writeln()
        ..write(snippet);
      throw ApiException(
        message != null ? ApiErrorKind.rejected : ApiErrorKind.server,
        serverMessage: message,
        statusCode: status,
        rawBody: evidence.toString(),
      );
    }
    if (!parsed) {
      throw ApiException(ApiErrorKind.format, statusCode: status, rawBody: snippet);
    }
    return ApiResponse(json: json, rawBody: snippet, statusCode: status);
  }

  /// Read-only connection check used by the in-app "Connection check" button.
  /// It sends a few plain GET requests (redirects NOT followed) so the status,
  /// server header and body of each can be compared. No header is faked.
  Future<String> diagnose(String path) async {
    final base = Uri.parse('$_base$path');
    final host = base.host;
    final altHost = host.startsWith('www.') ? host.substring(4) : 'www.$host';
    final probes = <_Probe>[
      _Probe('A) app request (UA $_userAgent)', base, _getHeaders),
      _Probe('B) library default headers', base, const <String, String>{}),
      _Probe('C) Accept */* only, app UA', base,
          const {'Accept': '*/*', 'User-Agent': _userAgent}),
      _Probe('D) other host ($altHost), app headers', base.replace(host: altHost),
          _getHeaders),
    ];
    final out = StringBuffer('RayanGardenApp connection check\n');
    for (final p in probes) {
      out.writeln('\n${p.label}\n  GET ${p.uri}');
      try {
        final req = http.Request('GET', p.uri)..followRedirects = false;
        req.headers.addAll(p.headers);
        final streamed = await _client.send(req).timeout(_timeout);
        final res = await http.Response.fromStream(streamed);
        out.writeln('  -> HTTP ${res.statusCode}');
        for (final k in ['server', 'content-type', 'location', 'cf-ray', 'x-powered-by', 'via']) {
          final v = res.headers[k];
          if (v != null) out.writeln('  $k: $v');
        }
        final body = utf8
            .decode(res.bodyBytes, allowMalformed: true)
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();
        out.writeln('  body: ${body.length > 160 ? '${body.substring(0, 160)}…' : body}');
      } on TimeoutException {
        out.writeln('  -> timeout');
      } catch (e) {
        out.writeln('  -> ${e.runtimeType}');
      }
    }
    return out.toString();
  }

  void close() => _client.close();
}

class _Probe {
  const _Probe(this.label, this.uri, this.headers);
  final String label;
  final Uri uri;
  final Map<String, String> headers;
}
