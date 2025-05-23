
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';


class AppStorage {
  static final GetStorage box = GetStorage();

  static Future<void> init() async => await GetStorage.init();

  // static Future<void> cacheUserInfo(UserModel userModel) =>
  //     box.write('user', userModel.toJson());
  //
  // static UserModel? get getUserInfo {
  //   UserModel? userModel;
  //   if (box.hasData('user')) {
  //     userModel = UserModel.fromJson(box.read('user'));
  //   }
  //   return userModel;
  // }
  // static HomeModel? get getHomeData{
  //   HomeModel? homeModel;
  //   if (box.hasData('data')) {
  //     homeModel = HomeModel.fromJson(box.read('data'));
  //   }
  //   return homeModel;
  // }

  // static bool get isLogged => getUserInfo != null;
  //
  // // static int? get getUserId => getUserInfo?.data?.id;
  // //
  // set saveToken(String? value) {
  //
  //   value= getUserInfo?.data?.token;
  //
  // }
  // set saveBanners (List<Banners>? banners){
  //   banners = getHomeData?.data?.banners;
  //
  //
  // }

  // static String? get getToken => getUserInfo?.data?.token??'';
  //
  // // static User? get getUserData => getUserInfo?.data?.user;
  // static get getData => getHomeData?.data;
  // // static List<Banners>? get getBanners => getHomeData?.data?.banners;


  static Future<void> eraseBox() async {
    await box.erase();
  }
}