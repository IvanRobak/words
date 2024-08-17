// services/cache_manager_service.dart

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Кастомний CacheManager для використання в додатку
final customCacheManager = CacheManager(
  Config(
    'customCacheKey',
    stalePeriod: const Duration(days: 7), // Термін зберігання кешу
    maxNrOfCacheObjects: 100, // Максимальна кількість кешованих об'єктів
  ),
);
