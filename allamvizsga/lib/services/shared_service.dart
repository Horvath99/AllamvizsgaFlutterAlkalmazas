import 'dart:convert';
import 'package:allamvizsga/models/login_response_model.dart';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/cupertino.dart';

class SharedService{
  static int? userId = null;
  static String? userName = null;
  static String? difficulty = "Konnyu";

  static Future<bool> isLoggedIn() async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist("login_details");
    return isKeyExist;
  }

  static Future<LoginResponseModel?> loginDetails() async{
    var isKeyExist = 
    await APICacheManager().isAPICacheKeyExist("login_details");

    if(isKeyExist){
      var cacheData = await APICacheManager().getCacheData("login_details");

      return loginResponseJson(cacheData.syncData);
    }
  }

  static Future<void> setLoginDetails(
    LoginResponseModel model,
  ) async{
    userId=model.userId;
    userName = model.userName;
    APICacheDBModel cacheDBModel = APICacheDBModel(
      key:"login_details",
      syncData: jsonEncode(model.toJson()) 
      );

      await APICacheManager().addCacheData(cacheDBModel);
  }

  static Future<void> logout(BuildContext context) async {
    await APICacheManager().deleteCache("login_details");
    Navigator.pushNamedAndRemoveUntil(
      context, 
      '/', 
      (route) => false
      );
  }

}