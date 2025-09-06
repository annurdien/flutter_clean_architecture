import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/{{feature_name}}_model.dart';

part '{{feature_name}}_api.g.dart';

@RestApi()
abstract class {{feature_name.pascalCase()}}Api {
  factory {{feature_name.pascalCase()}}Api(Dio dio, {String baseUrl}) = _{{feature_name.pascalCase()}}Api;

  @GET('/{{feature_name}}')
  Future<{{feature_name.pascalCase()}}Model> get{{feature_name.pascalCase()}}();
}