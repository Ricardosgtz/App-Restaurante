import 'dart:convert';

/// 💾 Sistema de caché en memoria para responses HTTP
class ResponseCache {
  // Singleton
  static final ResponseCache _instance = ResponseCache._internal();
  factory ResponseCache() => _instance;
  ResponseCache._internal();

  // Almacén de caché
  final Map<String, CacheEntry> _cache = {};

  /// 🔑 Generar key única para la petición
  static String generateKey(String url, {Map<String, dynamic>? params}) {
    if (params == null || params.isEmpty) {
      return url;
    }
    final sortedParams = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return '$url?${json.encode(sortedParams)}';
  }

  /// 💾 Guardar en caché
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
    print('💾 Cache saved: $key (expires in ${duration.inMinutes}min)');
  }

  /// 📦 Obtener de caché
  dynamic get(String key) {
    final entry = _cache[key];
    
    if (entry == null) {
      print('❌ Cache miss: $key');
      return null;
    }
    
    // Verificar si expiró
    if (entry.isExpired()) {
      print('⏰ Cache expired: $key');
      _cache.remove(key);
      return null;
    }
    
    print('✅ Cache hit: $key (${entry.remainingTime().inSeconds}s remaining)');
    return entry.data;
  }

  /// 🗑️ Eliminar entrada específica
  void remove(String key) {
    _cache.remove(key);
    print('🗑️ Cache removed: $key');
  }

  /// 🧹 Limpiar caché específico por patrón
  void removeByPattern(String pattern) {
    final keysToRemove = _cache.keys.where((key) => key.contains(pattern)).toList();
    for (final key in keysToRemove) {
      _cache.remove(key);
    }
    print('🧹 Cache cleared for pattern: $pattern (${keysToRemove.length} entries)');
  }

  /// 🔥 Limpiar toda la caché
  void clear() {
    final count = _cache.length;
    _cache.clear();
    print('🔥 Cache cleared: $count entries removed');
  }

  /// 🧹 Limpiar caché expirada
  void clearExpired() {
    final expiredKeys = _cache.entries
        .where((entry) => entry.value.isExpired())
        .map((entry) => entry.key)
        .toList();
    
    for (final key in expiredKeys) {
      _cache.remove(key);
    }
    
    print('🧹 Expired cache cleared: ${expiredKeys.length} entries');
  }

  /// 📊 Obtener estadísticas de caché
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

  /// 📋 Listar todas las keys
  List<String> get keys => _cache.keys.toList();
}

/// 📦 Entrada de caché
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

/// 📊 Estadísticas de caché
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

/// 🎯 Políticas de caché predefinidas
class CacheDuration {
  static const Duration veryShort = Duration(minutes: 1);
  static const Duration short = Duration(minutes: 5);
  static const Duration medium = Duration(minutes: 15);
  static const Duration long = Duration(hours: 1);
  static const Duration veryLong = Duration(hours: 24);
  
  // Para datos específicos
  static const Duration categories = Duration(hours: 1);    // Raramente cambian
  static const Duration products = Duration(minutes: 15);   // Pueden cambiar
  static const Duration orders = Duration(minutes: 5);      // Cambian frecuentemente
  static const Duration userProfile = Duration(minutes: 30); // Moderado
}