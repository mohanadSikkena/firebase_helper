


import 'package:shared_preferences/shared_preferences.dart';

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