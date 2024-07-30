


import 'package:dio/dio.dart';

class DioHelper{
  static late Dio dio;
  static Future<void> init()async{
    dio = Dio(
        BaseOptions(receiveDataWhenStatusError: true , )
    );
  }



  static Future<Response> getData(
      {
        required String url,

      }
      )async{
    return await dio.get(
      url,

    );

  }
  static Future<Response> getImage(
      {
        required String url,

      }
      )async{
    return await dio.get(
      url,
        options: Options(responseType: ResponseType.bytes)

    );

  }


  static Future<Response> setData({
    required String url,
    required dynamic query,
    String ? token,
    CancelToken? cancelToken

  }) async{
    return await dio.post(

        url,
        data: query,

        cancelToken: cancelToken ?? CancelToken(),
        options: Options(
          headers: {
            'Content-Type':'application/json',
            'Authorization':'Bearer $token '
          },
          receiveDataWhenStatusError: true,
          validateStatus: (_) => true,
        )
    );
  }
}