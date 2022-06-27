import 'package:analyzer/dart/element/element.dart';
import 'package:backfit/backfit.dart';
import 'package:backfit_generator/src/annotations_processor.dart';
import 'package:backfit_generator/src/type_helper.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as path;
import 'package:source_gen/source_gen.dart';

Builder backfitGeneratorFactoryBuilder() =>
    PartBuilder([BackfitGenerator()], '.backfit.dart',
        header: "// GENERATED CODE - DO NOT MODIFY BY HAND\n");

final _annotationsProcessor = AnnotationsProcessor();
final _dartFmt = DartFormatter();
String? _baseUrl;

class BackfitGenerator extends GeneratorForAnnotation<BackfitService> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final annotation =
        _annotationsProcessor.getClassAnnotation(element as ClassElement);

    _baseUrl = annotation.peek('baseUrl')?.stringValue;
    try {
      return DartFormatter().format(_generateClass(element) +
          _generateImplClass(element).replaceFirst('class', 'mixin'));
    } catch (e) {
      return "/*$e*/";
    }
  }
}

String _generateClass(ClassElement element) {
  final serviceClass = Class(
    (c) => c
      ..name = '${element.displayName}Service'
      ..extend = refer(element.displayName)
      ..mixins.add(refer('_\$${element.name}'))
      ..constructors.add(Constructor(//UnnamedConstructor
          (cons) => cons..body = Code('_client = BackfitClient();')))
      ..constructors.add(Constructor(
          (cons) => cons // factory constructor for providing own client.
            ..name = 'withClient'
            ..requiredParameters.add(Parameter((p) => p
              ..name = 'client'
              ..type = refer('BackfitClient')))
            ..body = Code('_client = client;')
            ..build())),
  );
  final emitter = DartEmitter();
  return _dartFmt.format('${serviceClass.accept(emitter)}');
}

String _generateImplClass(ClassElement element) {
  final backfit = Class((c) => c
    ..name = '_\$${element.name}'
    ..implements.add(refer(element.name))
    ..fields.addAll([
      Field((f) => f
        ..name = '_client'
        ..type = refer('BackfitClient?')),
      Field((f) => f
        ..name = '_validStatuses'
        ..type = refer('List<int>')
        ..modifier = FieldModifier.final$
        ..assignment = Code('''
  [
    HttpStatus.ok,
    HttpStatus.created,
    HttpStatus.accepted,
    HttpStatus.nonAuthoritativeInformation,
    HttpStatus.partialContent,
  ]
      '''))
    ])
    ..methods.addAll(_parseMethods(element.methods))
    ..build());
  final emitter = DartEmitter();
  return _dartFmt.format('${backfit.accept(emitter)}');
}

Iterable<Method> _parseMethods(List<MethodElement> methodElements) =>
    methodElements
        .where((m) => m.isAbstract && m.metadata.isNotEmpty)
        .map(_parseMethod);

Method _parseMethod(MethodElement element) => Method((b) => b
  ..name = element.name
  ..returns = refer(element.returnType.getDisplayString(withNullability: true))
  ..modifier = MethodModifier.async
  ..annotations.add(refer('override'))
  ..requiredParameters.addAll(_parseRequiredParameters(element.parameters))
  ..optionalParameters.addAll(_parseOptionalParameters(element.parameters))
  ..body = _parseBody(element)
  ..build());

Code _parseBody(MethodElement element) {
  final _methodAnnotation = _annotationsProcessor.getMethodAnnotations(element);

  if (_methodAnnotation.any((e) => e?.type == Multipart)) {
    return _parseMultipart(element);
  }

  Type methodType = _annotationsProcessor.getMethodType(element);

  String url = '';
  String method = 'post';

  if (methodType == Get) {
    method = 'get';
  } else if (methodType == Post) {
    method = 'post';
  }

  url = path.url.join(
      "\${_client!.baseUrl}",
      _baseUrl ?? "",
      _methodAnnotation
          .firstWhere((annotation) => annotation?.type == methodType,
              orElse: () => null)
          ?.reader
          .peek('url')
          ?.stringValue);

  final bodyParams = _annotationsProcessor.getMethodAnnotation(element, Body);

  final pathParams = _annotationsProcessor.getMethodAnnotation(element, Path);

  final queryParams = _annotationsProcessor.getMethodAnnotation(element, Query);

  final headerParams =
      _annotationsProcessor.getMethodAnnotation(element, Header);

  final hasHeaders = headerParams.isNotEmpty;

  final headers = Map.fromEntries(headerParams.map((p) =>
      MapEntry<String, String>(
          "'${p.reader.peek('key')?.stringValue}'", '${p.element?.name}')));

  pathParams.forEach((p) {
    final pathId = p.reader.peek('path')?.stringValue;
    final pathParam = p.element?.name;

    url = url.replaceAll('{$pathId}', '\$$pathParam');
  });

  String queryString = queryParams.map((p) {
    final queryId = p.reader.peek('query')?.stringValue;
    final queryParam = p.element?.name;
    return '$queryId=\$$queryParam';
  }).join('&');

  if (queryString != '') {
    url += '?$queryString';
  }

  if (bodyParams.length > 1) {
    throw InvalidGenerationSourceError('Only one body param is allowed.');
  }
  final bodyParam = bodyParams.isEmpty ? null : bodyParams.first.element;

  bool shouldGenerateBody = bodyParam != null;
  bool bodyNeedsDeserialization = shouldGenerateBody &&
      !bodyParam.type.isDartCoreMap &&
      !bodyParam.type.isDartCoreString;
  if (bodyNeedsDeserialization) {
    final ClassElement bodyClassElement =
        bodyParam.type.element as ClassElement;

    final toJsonElement =
        bodyClassElement.lookUpConcreteMethod('toJson', bodyParam.library!);

    if (toJsonElement == null) {
      throw InvalidGenerationSourceError(
          'Class ${bodyClassElement.displayName} must implement '
          'method toJson to convert ${bodyClassElement.displayName} object into map data');
    }
  }

  final sb = StringBuffer();

  final _typeArgs = typeArgs(element.returnType);

  final bool doesReturnCall =
      callTypeChecker.isAssignableFromType(_typeArgs.elementAt(1));

  if (!doesReturnCall) {
    throw InvalidGenerationSourceError(
        'Should return Response ---- \n\n $_typeArgs');
  }

  final _retType = _typeArgs.elementAt(2);
  final type = _typeArgs.last;
  final needDeserialization = needsDeserialization(type);

  if (needDeserialization) {
    final fromJsonElement =
        (type.element as ClassElement?)?.getNamedConstructor('fromJson') ??
            (type.element as ClassElement)
                .lookUpConcreteMethod('fromJson', type.element!.library!);

    if (fromJsonElement == null) {
      throw InvalidGenerationSourceError(
          'Class ${type.element!.name} must implement factory or '
          'static method fromJson to convert map data into ${type.element!.name} object');
    }
  }
  var _postBody = (methodType == Post && shouldGenerateBody)
      ? ", body: ${bodyNeedsDeserialization ? "${bodyParams.elementAt(0).element!.name}.toJson()" : "${bodyParams.elementAt(0).element!.name}"} "
      : "";

  sb.write('final res = await _client!.$method(Uri.parse(\'$url\')$_postBody');
  if (hasHeaders) {
    sb.write(', headers: $headers');
  }
  sb.write(');');

  if (coreIterableTypeChecker.isAssignableFromType(_retType)) {
    var data = '(json.decode(res.body) as List)';

    if (!type.isDynamic) {
      data = "$data.map((it) => $type.fromJson(it))";
    }

    if (_retType.isDartCoreList) {
      data = "$data.toList()";
    } else if (_retType.isDartCoreSet) {
      data = "$data.toSet()";
    }

    sb.write('''


return ${_typeArgs.elementAt(1).name}(
    data: _validStatuses.contains(res.statusCode) && res.body.isNotEmpty ?  $data : null,
    statusCode: res.statusCode,
    reasonPhrase: res.reasonPhrase,
    headers: HttpHeaders.fromMap(res.headers),
  );
''');
  } else if (coreMapTypeChecker.isAssignableFromType(_retType)) {
    var data = '(json.decode(res.body) as Map)';

    sb.write('''

return ${_typeArgs.elementAt(1).name}(
    data: _validStatuses.contains(res.statusCode) && res.body.isNotEmpty ? $data : null,
    statusCode: res.statusCode,
    reasonPhrase: res.reasonPhrase,
    headers: HttpHeaders.fromMap(res.headers),
  );
''');
  } else {
    if (_typeArgs.length > 4) {
      throw InvalidGenerationSourceError(
          "Only upto 4 levels of depth in the return type of a call is supported.. \ne.g., Future<Call<List<List<T>>>> is not supported");
    }
    var data = 'json.decode(res.body)';
    if (!type.isDynamic) data = '${type.name}.fromJson($data)';

    sb.write('''

return ${_typeArgs.elementAt(1).name}(
    data:  _validStatuses.contains(res.statusCode) && res.body.isNotEmpty ?  $data : null,
    statusCode: res.statusCode,
    reasonPhrase: res.reasonPhrase,
    headers: HttpHeaders.fromMap(res.headers),
  );
''');
  }
  return Code(sb.toString());
}

Code _parseMultipart(MethodElement element) {
  final _methodAnnotation = _annotationsProcessor.getMethodAnnotations(element);
  final emitter = DartEmitter();

  String url = path.url.join(
      "\${_client!.baseUrl}",
      _baseUrl ?? "",
      _methodAnnotation
          .firstWhere((annotation) => annotation?.type == Post,
              orElse: () => null)
          ?.reader
          .peek('url')
          ?.stringValue);

  final sb = StringBuffer();

  final _typeArgs = typeArgs(element.returnType);
  final _retType = _typeArgs.elementAt(2);
  final pathParams = _annotationsProcessor.getMethodAnnotation(element, Path);

  final type = _typeArgs.last;
  final needDeserialization = needsDeserialization(type);

  if (needDeserialization) {
    final fromJsonElement =
        (type.element as ClassElement?)?.getNamedConstructor('fromJson') ??
            (type.element as ClassElement)
                .lookUpConcreteMethod('fromJson', type.element!.library!);

    if (fromJsonElement == null) {
      throw InvalidGenerationSourceError(
          'Class ${type.element!.name} must implement factory or '
          'static method fromJson to convert map data into ${type.element!.name} object');
    }
  }
  pathParams.forEach((p) {
    final pathId = p.reader.peek('path')?.stringValue;
    final pathParam = p.element?.name;

    url = url.replaceAll('{$pathId}', '\$$pathParam');
  });

  sb.write("""
    final request = MultipartRequest('POST', Uri.parse(\'$url\'));
  """);

  final fileParams =
      _annotationsProcessor.getMethodAnnotation(element, PartFile);

  fileParams.forEach((f) {
    final field = f.reader.peek('field')?.stringValue;
    final contentType = f.reader.peek('contentType')?.stringValue.split("/");
    final filePath = f.element?.name;
    sb.writeln("if($filePath!=null) {");
    if (f.element!.type.isDartCoreList) {
      sb.writeln("for (final _\$x in $filePath) {");
      sb.writeln("final bytes = await _\$x.readAsBytes();");
      sb.writeln(
          "request.files.add(MultipartFile.fromBytes('$field', bytes, filename: _\$x.name, contentType: MediaType('${contentType![0]}', '${contentType[1]}')));");
      sb.writeln("}");
    } else {
      sb.writeln("final bytes = await $filePath.readAsBytes();");
      sb.writeln(
          "request.files.add(MultipartFile.fromBytes('$field', bytes, filename: $filePath.name, contentType: MediaType('${contentType![0]}', '${contentType[1]}')));");
    }
    sb.writeln("}");
  });

  final fieldParams =
      _annotationsProcessor.getMethodAnnotation(element, PartField);
  fieldParams.forEach((f) {
    final field = f.reader.peek('field')?.stringValue;
    final value = f.element?.name;
    sb.writeln("request.fields['$field'] = $value;");
  });

  var data;

  if (coreIterableTypeChecker.isAssignableFromType(_retType)) {
    data = '(json.decode(data) as List)';

    if (!type.isDynamic) {
      data = "$data.map((it) => $type.fromJson(it))";
    }

    if (_retType.isDartCoreList) {
      data = "$data.toList()";
    } else if (_retType.isDartCoreSet) {
      data = "$data.toSet()";
    }
  } else if (coreMapTypeChecker.isAssignableFromType(_retType)) {
    data = '(json.decode(data) as Map)';
  } else {
    if (_typeArgs.length > 4) {
      throw InvalidGenerationSourceError(
          "Only upto 4 levels of depth in the return type of a call is supported.. \ne.g., Future<Call<List<List<T>>>> is not supported");
    }
    data = 'json.decode(data)';
    if (!type.isDynamic) data = '${type.name}.fromJson($data)';
  }

  sb.writeln("""
   final res = await _client!.send(request);
   final data = await res.stream.bytesToString();

return ${_typeArgs.elementAt(1).name}(
    data: _validStatuses.contains(res.statusCode) && data.isNotEmpty ? $data : null,
    statusCode: res.statusCode,
    reasonPhrase: res.reasonPhrase,
    headers: HttpHeaders.fromMap(res.headers),
  );
  """);
  return Code(sb.toString());
}

Iterable<Parameter> _parseRequiredParameters(
        List<ParameterElement> parameters) =>
    parameters
        .where((parameter) => parameter.isNotOptional)
        .map(_parseParameter);

Iterable<Parameter> _parseOptionalParameters(
        List<ParameterElement> parameters) =>
    parameters.where((parameter) => parameter.isOptional).map(_parseParameter);

Parameter _parseParameter(ParameterElement param) => Parameter((p) {
      p
        ..name = param.name
        ..type = refer(param.type.getDisplayString(withNullability: true));
    });
