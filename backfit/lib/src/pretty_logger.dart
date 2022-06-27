import 'dart:convert';
import 'dart:math' as math;

import 'package:backfit/src/interceptor.dart';
import 'package:http/http.dart' as http;

class PrettyLogger implements RequestInterceptor, ResponseInterceptor {
  /// InitialTab count to logPrint json response
  static const int initialTab = 1;

  /// 1 tab length
  static const String tabStep = '    ';

  /// Print compact json response
  final bool compact;

  /// Width size per logPrint
  final int maxWidth;

  /// Log printer; defaults logPrint log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file.
  void Function(Object object) logPrint;

  PrettyLogger(
      {this.maxWidth = 90, this.compact = true, this.logPrint = print});

  void _printBoxed({String? header, String? text}) {
    logPrint('');
    logPrint('╔╣ $header');
    logPrint('║  $text');
    _printLine('╚');
  }

  void _printResponse(http.Response response) {
    final data = json.decode(response.body);
    if (data != null) {
      if (data is Map) {
        _printPrettyMap(data);
      } else if (data is List) {
        logPrint('║${_indent()}[');
        _printList(data);
        logPrint('║${_indent()}[');
      } else {
        _printBlock(data.toString());
      }
    }
  }

  void _printResponseHeader(http.BaseResponse response) {
    final uri = response.request?.url;
    final method = response.request?.method;
    _printBoxed(
        header:
            'Response ║ $method ║ Status: ${response.statusCode} ${response.reasonPhrase}',
        text: uri.toString());
  }

  void _printRequestHeader(http.BaseRequest request) {
    final uri = request.url;
    final method = request.method;
    _printBoxed(header: 'Request ║ $method ', text: uri.toString());
  }

  void _printLine([String pre = '', String suf = '╝']) =>
      logPrint('$pre${'═' * maxWidth}$suf');

  void _printKV(String? key, Object? v) {
    final pre = '╟ $key: ';
    final msg = v.toString();

    if (pre.length + msg.length > maxWidth) {
      logPrint(pre);
      _printBlock(msg);
    } else {
      logPrint('$pre$msg');
    }
  }

  void _printBlock(String msg) {
    final lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      logPrint((i >= 0 ? '║ ' : '') +
          msg.substring(i * maxWidth,
              math.min<int>(i * maxWidth + maxWidth, msg.length)));
    }
  }

  String _indent([int tabCount = initialTab]) => tabStep * tabCount;

  void _printPrettyMap(
    Map data, {
    int tabs = initialTab,
    bool isListItem = false,
    bool isLast = false,
  }) {
    var _tabs = tabs;
    final isRoot = _tabs == initialTab;
    final initialIndent = _indent(_tabs);
    _tabs++;

    if (isRoot || isListItem) logPrint('║$initialIndent{');

    data.keys.toList().asMap().forEach((index, dynamic key) {
      final isLast = index == data.length - 1;
      dynamic value = data[key];
      if (value is String) {
        value = '"${value.toString().replaceAll(RegExp(r'(\r|\n)+'), " ")}"';
      }
      if (value is Map) {
        if (compact && _canFlattenMap(value)) {
          logPrint('║${_indent(_tabs)} $key: $value${!isLast ? ',' : ''}');
        } else {
          logPrint('║${_indent(_tabs)} $key: {');
          _printPrettyMap(value, tabs: _tabs);
        }
      } else if (value is List) {
        if (compact && _canFlattenList(value)) {
          logPrint('║${_indent(_tabs)} $key: ${value.toString()}');
        } else {
          logPrint('║${_indent(_tabs)} $key: [');
          _printList(value, tabs: _tabs);
          logPrint('║${_indent(_tabs)} ]${isLast ? '' : ','}');
        }
      } else {
        final msg = value.toString().replaceAll('\n', '');
        final indent = _indent(_tabs);
        final linWidth = maxWidth - indent.length;
        if (msg.length + indent.length > linWidth) {
          final lines = (msg.length / linWidth).ceil();
          for (var i = 0; i < lines; ++i) {
            logPrint(
                '║${_indent(_tabs)} ${msg.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, msg.length))}');
          }
        } else {
          logPrint('║${_indent(_tabs)} $key: $msg${!isLast ? ',' : ''}');
        }
      }
    });

    logPrint('║$initialIndent}${isListItem && !isLast ? ',' : ''}');
  }

  void _printList(List list, {int tabs = initialTab}) {
    list.asMap().forEach((i, dynamic e) {
      final isLast = i == list.length - 1;
      if (e is Map) {
        if (compact && _canFlattenMap(e)) {
          logPrint('║${_indent(tabs)}  $e${!isLast ? ',' : ''}');
        } else {
          _printPrettyMap(e, tabs: tabs + 1, isListItem: true, isLast: isLast);
        }
      } else {
        logPrint('║${_indent(tabs + 2)} $e${isLast ? '' : ','}');
      }
    });
  }

  bool _canFlattenMap(Map map) {
    return map.values
            .where((dynamic val) => val is Map || val is List)
            .isEmpty &&
        map.toString().length < maxWidth;
  }

  bool _canFlattenList(List list) {
    return list.length < 10 && list.toString().length < maxWidth;
  }

  void _printMapAsTable(Map? map, {String? header}) {
    if (map == null || map.isEmpty) return;
    logPrint('╔ $header ');
    map.forEach(
        (dynamic key, dynamic value) => _printKV(key.toString(), value));
    _printLine('╚');
  }

  @override
  http.BaseRequest? onInterceptRequest(http.BaseRequest request) {
    _printRequestHeader(request);
    _printMapAsTable(request.url.queryParameters, header: 'Query Parameters');
    final requestHeaders = <String, dynamic>{};
    requestHeaders.addAll(request.headers);
    _printMapAsTable(requestHeaders, header: 'Headers');
    if (request.method != 'GET') {
      final dynamic data = request.url.data;
      if (data != null) {
        if (data is Map)
          _printMapAsTable(request.url.data as Map?, header: 'Body');
        if (data is http.MultipartRequest) {
          final formDataMap = {}..addEntries(data.fields.entries);
          // ..addEntries(data.files);
          _printMapAsTable(formDataMap,
              header: 'Form data | ${data.contentLength}');
        }
      } else {
        if (request is http.MultipartRequest) {
          _printBlock("Files");
          _printList(request.files.map((e) => e.filename).toList());
          _printMapAsTable(request.fields, header: 'Fields');
        } else if (request is http.Request) {
          try {
            _printMapAsTable(json.decode(request.body) as Map?, header: 'Body');
          } catch (e) {
            if (request is http.Request) _printBlock(request.body);
          }
        }
      }
    }

    return request;
  }

  @override
  onInterceptResponse(http.Response response) {
    _printResponseHeader(response);
    final responseHeaders = <String, String>{};
    response.headers.forEach((k, list) => responseHeaders[k] = list.toString());
    _printMapAsTable(responseHeaders, header: 'Headers');

    logPrint('╔ Body');
    logPrint('║');
    _printResponse(response);
    logPrint('║');
    _printLine('╚');
    return response;
  }
}
