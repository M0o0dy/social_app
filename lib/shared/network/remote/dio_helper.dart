import 'package:dio/dio.dart';
import 'package:social_app/shared/components/constance.dart';

class DioHelper {
  static late Dio dio;

  static init(){
    dio = Dio(

        BaseOptions(
          baseUrl: 'https://fcm.googleapis.com/fcm/send',
          receiveDataWhenStatusError: true,
          connectTimeout: 5000,
          receiveTimeout: 3000,

        ),

    );

  }
  static Future<Response> getData({
    required String url,
     Map<String, dynamic>?query,
    String lang = 'en',
    String? token,
  }) async {

    dio.options.headers = {
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':token??'',
    };
    return await dio.get(url,queryParameters: query, )
        .catchError((error){print('error is ${error.toString()}');});

  }


  static Future<Response> postData({

     Map<String, dynamic>?data,


  }) async {
    dio.options.headers = {
      'Content-Type':'application/json',
      'Authorization':'AAAA6RWoqU8:APA91bEMcv0M5qda5uqB0FVVY-NzDS8wJg5l32NST3CVowAiZZ-59g9K_wPYOzjt2LTRfPmlZsZmXaR4n8fykyZP1N84aIrxfeDxcRV2ParDPvci1nc_k2liTBIs9xVS_UYmT3Tc4wXh',
    };
    return await dio.post('https://fcm.googleapis.com/fcm/send',
      data: data, )
        .catchError((error){print('error is ${error.toString()}');});

  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic>data,
    Map<String, dynamic>?query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':token??'',
    };
    return await dio.put(url,queryParameters: query,data: data, )
        .catchError((error){print('error is ${error.toString()}');});

  }
}