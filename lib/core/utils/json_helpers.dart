typedef JsonMap = Map<String, dynamic>;

JsonMap asJsonMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return <String, dynamic>{};
}

List<JsonMap> extractList(Object? payload) {
  final value = extractData(payload);
  if (value is List) {
    return value.map(asJsonMap).toList();
  }
  if (value is Map) {
    for (final key in const ['content', 'items', 'data', 'results']) {
      final nested = value[key];
      if (nested is List) {
        return nested.map(asJsonMap).toList();
      }
    }
  }
  return <JsonMap>[];
}

Object? extractData(Object? payload) {
  if (payload is Map) {
    for (final key in const ['data', 'result', 'payload']) {
      if (payload.containsKey(key)) {
        return payload[key];
      }
    }
  }
  return payload;
}

String stringValue(JsonMap json, List<String> keys, {String fallback = ''}) {
  for (final key in keys) {
    final value = json[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString();
    }
  }
  return fallback;
}

int intValue(JsonMap json, List<String> keys, {int fallback = 0}) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    final parsed = int.tryParse(value?.toString() ?? '');
    if (parsed != null) {
      return parsed;
    }
  }
  return fallback;
}
