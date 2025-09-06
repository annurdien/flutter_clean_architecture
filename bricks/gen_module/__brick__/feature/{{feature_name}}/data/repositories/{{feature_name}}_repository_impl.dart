import 'package:fpdart/fpdart.dart';

import '../../../../core/entity/error/error_mapper.dart';
import '../../../../core/entity/error/failures.dart';
import '../../domain/entities/{{feature_name}}.dart';
import '../../domain/repositories/{{feature_name}}_repository.dart';
import '../data_sources/remote/{{feature_name}}_remote_data_source.dart';
import '../models/{{feature_name}}_model.dart';

class {{feature_name.pascalCase()}}RepositoryImpl implements {{feature_name.pascalCase()}}Repository {
  {{feature_name.pascalCase()}}RepositoryImpl({required this.remote});
  final {{feature_name.pascalCase()}}RemoteDataSource remote;

  @override
    Future<Either<Failure, {{feature_name.pascalCase()}}>> get{{feature_name.pascalCase()}}() async {
    try {
      final {{feature_name.camelCase()}} = await remote.get{{feature_name.pascalCase()}}();
      return Right<Failure, {{feature_name.pascalCase()}}>({{feature_name.camelCase()}}.toDomain());
    } catch (e, stackTrace) {
      return Left<Failure, {{feature_name.pascalCase()}}>(ErrorMapper.map(e, stackTrace));
    }
  }
}
