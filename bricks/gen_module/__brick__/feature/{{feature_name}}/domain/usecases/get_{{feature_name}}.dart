import 'package:fpdart/fpdart.dart';

import '../../../../core/entity/error/failures.dart';
import '../entities/{{feature_name}}.dart';
import '../repositories/{{feature_name}}_repository.dart';

class Get{{feature_name.pascalCase()}}UseCase {
  const Get{{feature_name.pascalCase()}}UseCase(this._repo);
  final {{feature_name.pascalCase()}}Repository _repo;
  Future<Either<Failure, {{feature_name.pascalCase()}}>> call() => _repo.get{{feature_name.pascalCase()}}();
}
