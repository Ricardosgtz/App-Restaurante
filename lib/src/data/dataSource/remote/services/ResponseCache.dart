import 'dart:convert';

/// 💾 Sistema de caché en memoria para responses HTTP
class ResponseCache {

  static final ResponseCache _instance = ResponseCache._internal();
  factory ResponseCache() => _instance;
  ResponseCache._internal();
  final Map<String, CacheEntry> _cache = {};
  static String generateKey(String url, {Map<String, dynamic>? params}) {
    if (params == null || params.isEmpty) {
      return url;
    }
    final sortedParams = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return '$url?${json.encode(sortedParams)}';
  }

  void set(
    String key,
    dynamic data, {
    Duration duration = const Duration(minutes: 5),
  }) {
    _cache[key] = CacheEntry(
      data: data,
      timestamp: DateTime.now(),
      duration: duration,
    );
  }

  dynamic get(String key) {
    final entry = _cache[key];
    if (entry == null) {
      return null;
    }
    
    if (entry.isExpired()) {
      _cache.remove(key);
      return null;
    }
    return entry.data;
  }

  void remove(String key) {
    _cache.remove(key);
  }

  void removeByPattern(String pattern) {
    final keysToRemove = _cache.keys.where((key) => key.contains(pattern)).toList();
    for (final key in keysToRemove) {
      _cache.remove(key);
    }
  }

  void clear() {
    final count = _cache.length;
    _cache.clear();
  }


  void clearExpired() {
    final expiredKeys = _cache.entries
        .where((entry) => entry.value.isExpired())
        .map((entry) => entry.key)
        .toList();
    
    for (final key in expiredKeys) {
      _cache.remove(key);
    }
  }

  CacheStats getStats() {
    final now = DateTime.now();
    int expired = 0;
    int valid = 0;
    
    for (final entry in _cache.values) {
      if (entry.isExpired()) {
        expired++;
      } else {
        valid++;
      }
    }
    
    return CacheStats(
      total: _cache.length,
      valid: valid,
      expired: expired,
    );
  }
  List<String> get keys => _cache.keys.toList();
}

class CacheEntry {
  final dynamic data;
  final DateTime timestamp;
  final Duration duration;

  CacheEntry({
    required this.data,
    required this.timestamp,
    required this.duration,
  });

  bool isExpired() {
    return DateTime.now().difference(timestamp) > duration;
  }

  Duration remainingTime() {
    final elapsed = DateTime.now().difference(timestamp);
    final remaining = duration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }
}

class CacheStats {
  final int total;
  final int valid;
  final int expired;

  CacheStats({
    required this.total,
    required this.valid,
    required this.expired,
  });

  @override
  String toString() {
    return 'CacheStats(total: $total, valid: $valid, expired: $expired)';
  }
}

class CacheDuration {
  static const Duration veryShort = Duration(minutes: 1);
  static const Duration short = Duration(minutes: 5);
  static const Duration medium = Duration(minutes: 15);
  static const Duration long = Duration(hours: 1);
  static const Duration veryLong = Duration(hours: 24);
  

  static const Duration categories = Duration(hours: 1);
  static const Duration products = Duration(minutes: 15); 
  static const Duration orders = Duration(minutes: 5);   
  static const Duration userProfile = Duration(minutes: 30);
}