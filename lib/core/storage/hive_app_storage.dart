import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'app_storage.dart';
import 'storage_keys.dart';

/// An implementation of [AppStorage] that uses Hive for data storage.
///
/// It manages two boxes: a secure (encrypted) box for sensitive data and a
/// non-secure box for regular data. The encryption key for the secure box
/// is stored using [FlutterSecureStorage].
class HiveAppStorage implements AppStorage {
  static const String _secureBoxName = 'secure_box';
  static const String _nonSecureBoxName = 'non_secure_box';
  static const String _encryptionKeyStorageKey = 'hive_encryption_key';

  static final HiveAppStorage instance = HiveAppStorage();

  @visibleForTesting
  HiveAppStorage.test({
    required HiveInterface hive,
    required FlutterSecureStorage secureStorage,
  }) : _hive = hive,
       _secureStorage = secureStorage;

  late final Box<dynamic> _secureBox;
  late final Box<dynamic> _nonSecureBox;
  final HiveInterface _hive;
  final FlutterSecureStorage _secureStorage;
  bool _initialized = false;

  HiveAppStorage()
    : _hive = Hive,
      _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> init() async {
    if (_initialized) return; // Prevent double initialization
    final Directory appDocumentDir = await getApplicationDocumentsDirectory();
    await _hive.initFlutter(appDocumentDir.path);

    final Uint8List encryptionKey = await _getOrGenerateEncryptionKey();

    _secureBox = await _hive.openBox(
      _secureBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );

    _nonSecureBox = await _hive.openBox(_nonSecureBoxName);
    _initialized = true;
  }

  Future<Uint8List> _getOrGenerateEncryptionKey() async {
    final String? storedKey = await _secureStorage.read(
      key: _encryptionKeyStorageKey,
    );

    if (storedKey == null) {
      final List<int> newKey = _hive.generateSecureKey();
      await _secureStorage.write(
        key: _encryptionKeyStorageKey,
        value: base64UrlEncode(newKey),
      );
      return Uint8List.fromList(newKey);
    }

    return base64Url.decode(storedKey);
  }

  Box<dynamic> _getBox(BaseStorageKey key) {
    return key.isSecure ? _secureBox : _nonSecureBox;
  }

  @override
  Future<T?> getValue<T>(BaseStorageKey key) async {
    if (!_initialized) {
      // Storage not ready yet; gracefully return null instead of throwing.
      return null;
    }
    return _getBox(key).get(key.name) as T?;
  }

  @override
  Future<void> setValue<T>(BaseStorageKey key, T value) async {
    if (!_initialized) return; // Silently ignore if storage not ready.
    await _getBox(key).put(key.name, value);
  }

  @override
  Future<void> deleteValue(BaseStorageKey key) async {
    if (!_initialized) return;
    await _getBox(key).delete(key.name);
  }

  @override
  Future<void> deleteAll() async {
    if (!_initialized) return;
    await _secureBox.clear();
    await _nonSecureBox.clear();
  }

  /// Whether the storage has completed initialization.
  bool get isInitialized => _initialized;
}
