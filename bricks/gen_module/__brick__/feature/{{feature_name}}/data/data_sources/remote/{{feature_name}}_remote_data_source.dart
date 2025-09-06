import '../../api/{{feature_name}}_api.dart';
import '../../models/{{feature_name}}_model.dart';

abstract class {{feature_name.pascalCase()}}RemoteDataSource {
  Future<{{feature_name.pascalCase()}}Model> get{{feature_name.pascalCase()}}();
}

class {{feature_name.pascalCase()}}RemoteDataSourceImpl implements {{feature_name.pascalCase()}}RemoteDataSource {
  {{feature_name.pascalCase()}}RemoteDataSourceImpl(this._api);
  final {{feature_name.pascalCase()}}Api _api;

  @override
  Future<{{feature_name.pascalCase()}}Model> get{{feature_name.pascalCase()}}() => _api.get{{feature_name.pascalCase()}}();
}
