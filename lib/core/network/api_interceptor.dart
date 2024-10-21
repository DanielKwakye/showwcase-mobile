
import 'package:dio/dio.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';

class ApiInterceptor extends Interceptor {

  ApiInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    String token = await AppStorage.getAuthTokenVal();
    if (token.isNotEmpty) {
      options.headers.addAll({"Authorization":  token,});
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      response.statusCode = 200;
    }
    else if (response.statusCode == 401) {
    }
    return super.onResponse(response, handler);
  }

}
