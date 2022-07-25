import 'package:dio/dio.dart';

class BaseProvider {
  final Dio _dioClient = Dio();

  Future<dynamic> get({
    required String url,
    Map<String, dynamic>? params,
    Function(dynamic)? formatter,
  }) async {
    try {
      Response response = await _dioClient.get(url, queryParameters: params);
      print(response.realUri);

      var data = response.data;
      if (formatter != null) {
        data = formatter(response.data);
      }

      return data;
    } catch (ex) {
      if (ex is DioError) {
        print('ERROR: ${ex.error}');
        print(ex.response?.realUri);
      }

      return null;
    }
  }
}
