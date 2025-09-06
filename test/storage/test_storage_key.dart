import 'package:flutter_clean_architecture/core/storage/storage.dart';

enum TestStorageKey implements BaseStorageKey {
  testSecure(isSecure: true),
  testNonSecure(isSecure: false);

  const TestStorageKey({required this.isSecure});

  @override
  final bool isSecure;

  @override
  String get name => toString().split('.').last;
}
