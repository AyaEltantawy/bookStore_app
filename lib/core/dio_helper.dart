// // import 'package:banhawy/core/router/router.dart';
// // import 'package:banhawy/public/constant.dart';
//
// import 'package:bookstore_app/core/utils/snack_bar.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:get_storage/get_storage.dart';
//
// import 'package:dio/dio.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import 'magic_router/magic_router.dart';
//
//
// class DioHelper {
//   static const _baseUrl = 'https://yuki.technoraft.com/api/';
//
//   static Dio dioSingleton = Dio()..options.baseUrl = _baseUrl;
//
//   static Future<Response<dynamic>> post(String path, bool isAuh,
//       {FormData? formData,
//         encoding,
//         Map<String, dynamic>? body,
//         Function(int, int)? onSendProgress}) async {
//     bool result = await InternetConnectionChecker().hasConnection;
//     if (result == true) {
//       print('YAY! Free cute dog pics!');
//     } else {
//       Utils.showSnackBar(
//           MagicRouter.currentContext!, 'You are disconnected from the internet');
//     }
//     dioSingleton.options.headers =
//     isAuh ? {'Authorization': 'Bearer ${AppStorage.getToken}'} : null;
//     print('pathhh $path');
//     final response = dioSingleton.post(path,
//         data: formData ?? (body == null ? null : FormData.fromMap(body)),
//         options: Options(
//             requestEncoder: encoding,
//             headers: {
//               'Authorization': 'Bearer ${AppStorage.getToken}',
//               'Accept': 'application/json',
//               'Accept-Language': 'en',
//             },
//             followRedirects: false,
//             contentType: Headers.formUrlEncodedContentType,
//             receiveDataWhenStatusError: true,
//             sendTimeout: const Duration(seconds: 1),
//             //60 seconds
//             // 60 seconds
//             validateStatus: (status) {
//               return status! < 500;
//             }),
//         onSendProgress: onSendProgress);
//     print("response $response");
//     return response;
//   }
//
//   static Future<Response<dynamic>> put(String path, bool isAuh,
//       {FormData? formData,
//         Map<String, dynamic>? body,
//         Function(int, int)? onSendProgress}) async {
//     bool result = await InternetConnectionChecker().hasConnection;
//     if (result == true) {
//       print('YAY! Free cute dog pics!');
//     } else {
//       Utils.showSnackBar(
//           MagicRouter.currentContext, 'You are disconnected from the internet');
//     }
//     dioSingleton.options.headers =
//     isAuh ? {'Authorization': 'Bearer ${AppStorage.getToken}'} : null;
//     final response = dioSingleton.put(path,
//         data: formData ?? FormData.fromMap(body!),
//         options: Options(
//             headers: {
//               'Authorization': 'Bearer ${AppStorage.getToken}',
//               'Accept': 'application/json',
//               //'Accept-Language': isEn(MagicRouter.currentContext) ? 'en' : 'ar',
//             },
//             followRedirects: false,
//             receiveDataWhenStatusError: true,
//             //  sendTimeout: 10 * 1000,
//             //60 seconds
//             //  receiveTimeout: 10 * 1000,
//             // 60 seconds
//             validateStatus: (status) {
//               return status! < 500;
//             }),
//         onSendProgress: onSendProgress);
//     return response;
//   }
//
//   static Future<Response<dynamic>> delete(
//       String path, {
//         Map<String, dynamic>? body,
//       }) {
//     try {
//       dioSingleton.options.headers = {
//         'Authorization': 'Bearer ${AppStorage.getToken}'
//       };
//       final response = dioSingleton.delete(
//         path,
//         data: body,
//         options: Options(
//             headers: {
//               'Authorization': 'Bearer ${AppStorage.getToken}',
//               'Accept': 'application/json'
//             },
//             followRedirects: false,
//             validateStatus: (status) {
//               return status! < 500;
//             }),
//       );
//       return response;
//     } on FormatException catch (_) {
//       throw FormatException("Unable to process the data");
//     } catch (e) {
//       throw e;
//     }
//   }
//
//   static Future<Response<dynamic>>? get(String path, {dynamic body}) async {
//     // final String currentTimeZone =
//     //     await FlutterNativeTimezone.getLocalTimezone();
//     if (AppStorage.isLogged) {
//       bool result = await InternetConnectionChecker().hasConnection;
//       if (result == true) {
//         print('YAY! Free cute dog pics!');
//       } else {
//         Utils.showSnackBar(
//           MagicRouter.currentContext,
//           'You are disconnected from the internet',
//         );
//       }
//       dioSingleton.options.headers = {
//         'Authorization': 'Bearer ${AppStorage.getToken}',
//         'Accept': 'application/json',
//         //'Accept-Language': isEn(MagicRouter.currentContext) ? 'en' : 'ar',
//         // "x-timezone": currentTimeZone
//       };
//     }
//     print(dioSingleton.options.headers);
//     final response = dioSingleton.get(path,
//         queryParameters: body,
//         options: Options(
//           //  sendTimeout: 10 * 1000, //60 seconds
//           //  receiveTimeout: 10 * 1000, // 60 seconds
//         ));
//     dioSingleton.options.headers = null;
//     return response;
//   }
//
//   static Future<void>? launchURL(url) async {
//     if (!await launch(
//       url,
//     )) throw 'Could not launch $url';
//   }
// }