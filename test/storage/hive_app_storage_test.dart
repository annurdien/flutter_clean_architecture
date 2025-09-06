import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/core/storage/hive_app_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

import 'test_storage_key.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box<dynamic> {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HiveAppStorage hiveAppStorage;
  late MockHiveInterface mockHive;
  late MockHiveBox mockSecureBox;
  late MockHiveBox mockNonSecureBox;
  late MockFlutterSecureStorage mockFlutterSecureStorage;

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/path_provider'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            return '.';
          }
          return null;
        },
      );

  setUp(() {
    mockHive = MockHiveInterface();
    mockSecureBox = MockHiveBox();
    mockNonSecureBox = MockHiveBox();
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    hiveAppStorage = HiveAppStorage.test(
      hive: mockHive,
      secureStorage: mockFlutterSecureStorage,
    );

    // Stubbing Hive's init and box opening
    when(() => mockHive.isAdapterRegistered(any())).thenReturn(true);
    when(() => mockHive.init(any())).thenAnswer((_) async {});
    when(
      () => mockHive.openBox<dynamic>(
        any(),
        encryptionCipher: any(named: 'encryptionCipher'),
      ),
    ).thenAnswer((_) async => mockSecureBox);
    when(
      () => mockHive.openBox<dynamic>('non_secure_box'),
    ).thenAnswer((_) async => mockNonSecureBox);

    // Stubbing box retrieval
    when(() => mockSecureBox.get(any())).thenReturn('secure_value');
    when(() => mockNonSecureBox.get(any())).thenReturn('non_secure_value');
    when(
      () => mockSecureBox.put(any(), any()),
    ).thenAnswer((_) => Future.value());
    when(
      () => mockNonSecureBox.put(any(), any()),
    ).thenAnswer((_) => Future.value());
    when(() => mockSecureBox.delete(any())).thenAnswer((_) => Future.value());
    when(
      () => mockNonSecureBox.delete(any()),
    ).thenAnswer((_) => Future.value());
    when(() => mockSecureBox.clear()).thenAnswer((_) async => 0);
    when(() => mockNonSecureBox.clear()).thenAnswer((_) async => 0);

    // Stubbing encryption key generation
    when(
      () => mockFlutterSecureStorage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => null);
    when(
      () => mockFlutterSecureStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) => Future.value());
    when(() => mockHive.generateSecureKey()).thenReturn(Uint8List(32));
  });

  Future<void> initStorage() async {
    await hiveAppStorage.init();
  }

  group('HiveAppStorage Tests', () {
    test('init initializes Hive and opens boxes', () async {
      await initStorage();

      verify(() => mockHive.init(any())).called(1);
      verify(
        () => mockHive.openBox<dynamic>(
          'secure_box',
          encryptionCipher: any(named: 'encryptionCipher'),
        ),
      ).called(1);
      verify(() => mockHive.openBox<dynamic>('non_secure_box')).called(1);
    });

    test('getValue returns value from correct box', () async {
      await initStorage();
      final String? secureValue = await hiveAppStorage.getValue<String>(
        TestStorageKey.testSecure,
      );
      final String? nonSecureValue = await hiveAppStorage.getValue<String>(
        TestStorageKey.testNonSecure,
      );

      expect(secureValue, 'secure_value');
      expect(nonSecureValue, 'non_secure_value');
      verify(() => mockSecureBox.get('testSecure')).called(1);
      verify(() => mockNonSecureBox.get('testNonSecure')).called(1);
    });

    test('setValue puts value in correct box', () async {
      await initStorage();
      await hiveAppStorage.setValue(
        TestStorageKey.testSecure,
        'new_secure_value',
      );
      await hiveAppStorage.setValue(
        TestStorageKey.testNonSecure,
        'new_non_secure_value',
      );

      verify(
        () => mockSecureBox.put('testSecure', 'new_secure_value'),
      ).called(1);
      verify(
        () => mockNonSecureBox.put('testNonSecure', 'new_non_secure_value'),
      ).called(1);
    });

    test('deleteValue deletes value from correct box', () async {
      await initStorage();
      await hiveAppStorage.deleteValue(TestStorageKey.testSecure);
      await hiveAppStorage.deleteValue(TestStorageKey.testNonSecure);

      verify(() => mockSecureBox.delete('testSecure')).called(1);
      verify(() => mockNonSecureBox.delete('testNonSecure')).called(1);
    });

    test('deleteAll clears both boxes', () async {
      await initStorage();
      await hiveAppStorage.deleteAll();

      verify(() => mockSecureBox.clear()).called(1);
      verify(() => mockNonSecureBox.clear()).called(1);
    });
  });
}
