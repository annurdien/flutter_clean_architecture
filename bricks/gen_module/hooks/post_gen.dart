import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) {
  final feature = context.vars['feature_name'] as String;
  final pascal = _pascalCase(feature);
  final moduleClass = '${pascal}Module';
  _updateBootstrap(feature, moduleClass, context.logger);
  _relocateFeatureFolder(feature, context.logger);
}

// Updates bootstrap markers with new module import & instance (idempotent)
void _updateBootstrap(String feature, String moduleClass, Logger logger) {
  final file = File('lib/bootstrap.dart');
  if (!file.existsSync()) {
    logger.warn(
      'bootstrap.dart not found, skipping automatic module insertion',
    );
    return;
  }
  final content = file.readAsStringSync();
  final importMarker = '// === mason:feature_imports ===';
  final listMarker = '// === mason:feature_modules ===';
  var updated = content;

  if (!content.contains(moduleClass)) {
    updated = updated.replaceFirst(
      importMarker,
      "import 'feature/$feature/dependency/${feature}_module.dart';\n$importMarker",
    );
  }
  if (!updated.contains('$moduleClass()')) {
    updated = updated.replaceFirst(
      listMarker,
      '$moduleClass(),\n      $listMarker',
    );
  }
  if (updated != content) {
    file.writeAsStringSync(updated);
    logger.info('Updated bootstrap.dart with $moduleClass');
  } else {
    logger.info('bootstrap.dart already had $moduleClass');
  }
}

String _pascalCase(String input) => input
    .split('_')
    .map((p) => p.isEmpty ? p : p[0].toUpperCase() + p.substring(1))
    .join();

// Moves generated feature folder from ./feature/<name> to ./lib/feature/<name>
// if the brick template was laid out without the leading lib/ path.
void _relocateFeatureFolder(String feature, Logger logger) {
  final src = Directory('feature/$feature');
  if (!src.existsSync()) {
    return; // already correct or nothing to move
  }
  final targetParent = Directory('lib/feature');
  if (!targetParent.existsSync()) {
    targetParent.createSync(recursive: true);
  }
  final dstPath = 'lib/feature/$feature';
  final dst = Directory(dstPath);
  if (dst.existsSync()) {
    logger.warn(
      'Destination $dstPath already exists; leaving original at ${src.path}. Move manually.',
    );
    return;
  }
  try {
    src.renameSync(dstPath);
    logger.info('Moved feature folder to $dstPath');
  } catch (e) {
    logger.err('Failed to move feature folder automatically: $e');
  }
}
