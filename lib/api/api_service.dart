import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_db_store/dio_cache_interceptor_db_store.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Singleton class to manage API requests and caching
class ApiService {
  // Private constructor
  ApiService._privateConstructor();

  // Singleton instance
  static final ApiService instance = ApiService._privateConstructor();

  // Dio instance
  late final Dio _dio;

  // Cache options for Dio
  late final CacheOptions _cacheOptions;

  /// Initializes Dio with caching and logging capabilities
  Future<void> init() async {
    // Get the application documents directory (persistent storage)
    final dir = await getTemporaryDirectory();
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    print(dir.path);
    // Configure cache store to use SQLite database
    final CacheStore cacheStore = DbCacheStore(
      databasePath: p.join(dir.path, 'cache.db'), // Path to SQLite DB
      logStatements: true, // Log SQL statements (useful for debugging)
    );

    // Define cache options for Dio
    _cacheOptions = CacheOptions(
      store: cacheStore,
      policy:
          CachePolicy.refreshForceCache, // Always refresh but cache responses
      hitCacheOnErrorExcept: [], // Fallback to cache if there's an error
    );

    // Initialize Dio and add interceptors
    _dio = Dio()
      ..interceptors.addAll([
        DioCacheInterceptor(options: _cacheOptions), // Cache interceptor
        PrettyDioLogger(
          // Logging interceptor for debugging
          requestBody: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: true,
        ),
      ]);
  }

  /// Fetch data from the API with caching support
  Future<List<dynamic>?> getDataFromApi(int start) async {
    try {
      final response = await _dio.get(
        'https://jsonplaceholder.typicode.com/todos?_start=$start&_limit=20',
        options: _cacheOptions.toOptions(), // Apply cache options
      );

      return response.data;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }
}
