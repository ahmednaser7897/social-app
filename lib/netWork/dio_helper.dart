import 'package:dio/dio.dart';


class DioHelper{
  static late  Dio dio;
  static inti(){
    dio=Dio(
      BaseOptions(
        baseUrl: "",
        receiveDataWhenStatusError: true,
      )
    );
  }
  Future<Response> getData ({
    required String url,
    Map<String, dynamic> ?querys,
    String lang='en',
    String ?token
    })async{
      dio.options.headers={
        'lang':lang,
        'Authorization':token??"",
        'Content-Type':'application/json'
      };
      return await dio.get(url,queryParameters:querys );

  }
  Future<Response> postData ({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic> ?querys,
    String lang='en',
    String ?token
    })async{
      dio.options.headers={
        'lang':lang,
        'Authorization':token??"",
        'Content-Type':'application/json'
      };
      return await dio.post(url,queryParameters:querys,data: data );

  }
  Future<Response> putData ({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic> ?querys,
    String lang='en',
    String ?token
    })async{
      dio.options.headers={
        'lang':lang,
        'Authorization':token??"",
        'Content-Type':'application/json'
      };
      return await dio.put(url,queryParameters:querys,data: data );
  }
}