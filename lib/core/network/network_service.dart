import 'package:alice/alice.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

import '../config/app_config_provider.dart';
import '../storage/storage.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  late final Dio dio;
  late final Alice alice;
  late final AliceDioAdapter aliceDioAdapter;

  static NetworkService get instance => _instance;

  NetworkService._internal() {
    alice = Alice();
    aliceDioAdapter = AliceDioAdapter();
    alice.addAdapter(aliceDioAdapter);

    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(_AuthInterceptor());
    dio.interceptors.add(_TokenSaverInterceptor());

    if (AppConfigProvider.instance.showNetworkInterceptors) {
      dio.interceptors.add(aliceDioAdapter);
    }

    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        retries: 2,
        retryDelays: const <Duration>[
          Duration(seconds: 1),
          Duration(seconds: 2),
        ],
      ),
    );
  }
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    //TODO(annurdien) Add custom headers
    options.headers['Content-Type'] = 'application/json';
    options.headers['Custom-Header'] = 'your-custom-value';

    final String? token = await HiveAppStorage.instance.getValue<String>(
      StorageKey.authToken,
    );
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}

class _TokenSaverInterceptor extends Interceptor {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    // TODO(annurdien): Update to match response data structure
    final String? token = response.data?['token'];
    if (token != null) {
      await HiveAppStorage.instance.setValue(StorageKey.authToken, token);
    }

    super.onResponse(response, handler);
  }
}
