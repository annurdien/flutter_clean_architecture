/// Base contract for all storage keys.
///
/// This abstraction ensures consistency across different key types.
/// Every storage key must define whether it is stored securely
/// (e.g., in an encrypted box) or in plain storage, and must also
/// expose its string name for persistence.
abstract class BaseStorageKey {
  /// Whether the key should be stored in a secure storage container.
  bool get isSecure;

  /// The unique string identifier for this storage key.
  String get name;
}

/// Enum containing all keys used for local storage.
///
/// By centralizing all keys in one place, this enum:
/// - Prevents typos when accessing storage.
/// - Makes it easier to audit all available keys.
/// - Provides a clear distinction between secure and non-secure keys.
///
/// Each key carries an `isSecure` flag to determine
/// whether it should be stored in an encrypted box
/// (e.g., Keychain/Secure Storage) or regular storage
/// (e.g., SharedPreferences/Hive).
enum StorageKey implements BaseStorageKey {
  authToken(isSecure: true),
  refreshToken(isSecure: true),
  isFirstLaunch(isSecure: false),
  appTheme(isSecure: false);

  /// Creates a storage key definition.
  const StorageKey({required this.isSecure});

  @override
  final bool isSecure;

  /// The string identifier of this key (e.g. `"authToken"`).
  ///
  /// This uses Dart's built-in [Enum.name] property to return
  /// only the case name, without the enum type prefix.
  @override
  String get name => toString().split('.').last;
}
