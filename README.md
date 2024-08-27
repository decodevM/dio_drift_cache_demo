# Flutter Dio Cache Demo

This is a sample Flutter application demonstrating how to use Dio with caching via Drift for API requests. It showcases how to implement caching with the `dio_cache_interceptor` package and Drift for SQLite database integration.

## Getting Started

### Prerequisites

Ensure you have Flutter installed on your machine. You will also need to have the following dependencies:

- `dio`
- `dio_cache_interceptor`
- `pretty_dio_logger`
- `dio_cache_interceptor_db_store`
- `path_provider`
- `path`
- `sqlite3_flutter_libs`

## Notes on Android

### Included platforms

Note that, on Android, this library will bundle sqlite3 for all of the following platforms:

- `arm64-v8a`
- `armeabi-v7a`
- `x86`
- `x86_64`

If you don't intend to release to 32-bit `x86` devices, you'll need to apply a
[filter](https://developer.android.com/ndk/guides/abis#gc) in your `build.gradle`:

```gradle
android {
    defaultConfig {
        ndk {
            abiFilters 'armeabi-v7a', 'arm64-v8a', 'x86_64'
        }
    }
}
```

### Installation

**Clone the repository:**

   ```bash
   git clone https://github.com/decodevM/dio_drift_cache_demo.git
   ```
**Navigate to the project directory:**

   ```bash
   cd flutter-dio-cache-demo
   ```
**Get dependencies:**

   ```bash
   flutter pub get
   ```
**Run the project:**

   ```bash
   flutter run 
   ```

   
   