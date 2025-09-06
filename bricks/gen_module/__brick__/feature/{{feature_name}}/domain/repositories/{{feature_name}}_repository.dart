import 'package:fpdart/fpdart.dart';

import '../../../../core/entity/error/failures.dart';
import '../entities/{{feature_name}}.dart';

abstract class {{feature_name.pascalCase()}}Repository {
  Future<Either<Failure, {{feature_name.pascalCase()}}>> get{{feature_name.pascalCase()}}();
}
