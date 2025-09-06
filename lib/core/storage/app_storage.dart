import 'storage_keys.dart';

/// Abstract interface for a key-value storage service.
///
/// This abstraction allows for the underlying storage implementation (e.g., Hive,
/// SharedPreferences) to be swapped without changing the application code that
/// uses it.
abstract class AppStorage {
  /// Initializes the storage service. This must be called before any other
  /// methods are used.
  Future<void> init();

  /// Reads a value from storage.
  ///
  /// [key] The [StorageKey] to read from.
  /// Returns a [Future] that completes with the value, or `null` if the key
  /// does not exist. The return type `T` must match the stored value's type.
  Future<T?> getValue<T>(BaseStorageKey key);

  /// Writes a value to storage.
  ///
  /// [key] The [StorageKey] to write to.
  /// [value] The value to write. The type `T` must be a primitive type
  /// supported by Hive (e.g., int, String, bool, List, Map).
  Future<void> setValue<T>(BaseStorageKey key, T value);

  /// Deletes a value from storage.
  ///
  /// [key] The [StorageKey] to delete.
  Future<void> deleteValue(BaseStorageKey key);

  /// Deletes all data from both secure and non-secure storage.
  Future<void> deleteAll();
}
