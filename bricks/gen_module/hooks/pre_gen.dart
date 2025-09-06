import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) {
  final feature = context.vars['feature_name'] as String?;
  if (feature == null || feature.isEmpty) {
    context.logger.err('feature_name is required');
    exit(1);
  }
  final valid = RegExp(r'^[a-z0-9_]+$');
  if (!valid.hasMatch(feature)) {
    context.logger.err(
      'feature_name must be snake_case (lowercase, numbers, underscore)',
    );
    exit(1);
  }

  final targetDir = Directory('lib/feature/$feature');
  if (targetDir.existsSync()) {
    context.logger.warn('Feature folder already exists: lib/feature/$feature');
  }

  // Derived naming variants
  final pascal = feature
    .split('_')
    .where((p) => p.isNotEmpty)
    .map((p) => p[0].toUpperCase() + p.substring(1))
    .join();
  context.vars['pascal_feature_name'] = pascal; // e.g. order_history -> OrderHistory
  final title = feature
    .split('_')
    .where((p) => p.isNotEmpty)
    .map((p) => p[0].toUpperCase() + p.substring(1))
    .join(' ');
  context.vars['title_feature_name'] = title; // e.g. order_history -> Order History

  // entity_fields expected as list (dynamic list per brick.yaml)
  // entity_fields may arrive as a List (expected) or a single String (user passed one arg)
  final dynamic raw = context.vars['entity_fields'];
  List<String> rawItems;
  if (raw is List) {
    rawItems = raw.cast<String>();
  } else if (raw is String) {
    // Allow comma or space separated entries
    rawItems = raw.split(RegExp(r'[ ,]+'));
  } else {
    rawItems = <String>[];
  }

  final cleaned = rawItems
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .map((e) => e.replaceAll(',', ''))
      .where((e) => e.contains(':'))
      .toList();
  if (cleaned.isEmpty) {
    cleaned.add('id:String');
  }
  context.vars['entity_fields'] = cleaned; // ensure list sanitized

  final entityParams = StringBuffer();
  final modelParams = StringBuffer();
  final modelToEntity = StringBuffer();
  for (final f in cleaned) {
    final idx = f.indexOf(':');
    if (idx == -1) continue;
    final name = f.substring(0, idx);
    final type = f.substring(idx + 1);
    entityParams.writeln('    required $type $name,');
    modelParams.writeln('    required $type $name,');
    modelToEntity.writeln('    $name: $name,');
  }
  context.vars['entity_params'] = entityParams.toString().trimRight();
  context.vars['model_params'] = modelParams.toString().trimRight();
  context.vars['model_to_entity'] = modelToEntity.toString().trimRight();
}
