

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/cache/cache_helper.dart';
import '../../models/user/user.dart';
import '../notifications/notification_repository.dart';

class UserRepository{
  static Future<void>setFcmForCurrentUser()async{
    String uId = CacheHelper.getData(key: "uId");
    String  fcmToken = await FirebaseNotificationRepository.getFcmToken();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .update({"fcm":fcmToken});
  }

  static Future<(dynamic name,dynamic image)> getNameAndImageForCurrentUser()async{
    String uId  = CacheHelper.getData(key: "uId");
    DocumentSnapshot<Map<String, dynamic>> map=await FirebaseFirestore.instance
        .collection("users")
        .doc(uId).get();
    return (map.data()?["name"],map.data()?["image"]);
  }


  static Future<String?> getFcmForAnyUser({required String uId})async{
     DocumentSnapshot<Map<String, dynamic>> map=await FirebaseFirestore.instance
        .collection("users")
        .doc(uId).get();
     return map.data()?["fcm"];
  }


  static Future<UserModel?> getUser({required String uId}) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get(const GetOptions(source: Source.serverAndCache))
        .then((value) {
      try {
        return UserModel.fromMap(value.data()!);
      } catch (e) {
        return null;
      }
    }).onError((error, stackTrace) {
      return null;
    });
  }


}