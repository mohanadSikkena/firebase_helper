


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/helpers/remote_images/remote_images.dart';

class CacheHelper{
  static late SharedPreferences sharedPreferences;

  static Future init()async{
    sharedPreferences=await SharedPreferences.getInstance();
  }

  static const String _fcmToken="fcmToken";
  static Future<bool> setFcmToken(String? value) async {
    bool isSet = await sharedPreferences.setString(_fcmToken, value!);
    return isSet;
  }
  static Future putInt({
    required String key, 
    required int value
  })async{
    return await sharedPreferences.setInt(key,value );
  }
  static Future putData({
    required String key,
    required String value
  })async{
    return await sharedPreferences.setString(key,value );
  }

  static Future putList({
    required String key, 
    required List<String> value
  })async{
    return await sharedPreferences.setStringList(key, value);
  }

  static Future<bool> cacheUserImage(
      {required BuildContext context, required String userImage}) async {
    bool getImageSuccess = true;
    CachedNetworkImageProvider image = CachedNetworkImageProvider(userImage);
    await precacheImage(
      image,
      context,
      onError: (e, stackTrace) {
        getImageSuccess = false;
      },
    );
    return getImageSuccess;
  }

  static cacheDefaultImages({required BuildContext context}) async {
    for (var element in RemoteImages.allImages) {
      CachedNetworkImageProvider image = CachedNetworkImageProvider(element);
      precacheImage(
        image,
        context,
        onError: (e, stackTrace) {},
      ).then((value) {});
    }
  }



  static getInt({
    required String key
  }){
    return  sharedPreferences.getInt(key);

  }


  static getList({required String key}){
    return sharedPreferences.getStringList(key);
  } 
  static Future<bool> putBool({required String key , required bool value})async{
    return await  sharedPreferences.setBool(key, value);
  }
  static getData({
    required String key
  }){
      return  sharedPreferences.get(key);

  }
}