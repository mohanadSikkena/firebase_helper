

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_helper/core/cache/cache_helper.dart';
import 'package:firebase_helper/core/network/dio_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:notification_permissions/notification_permissions.dart';


class FirebaseNotificationRepository{
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static String ? _fcmToken;
  static int _testI = 0;
  static final FlutterLocalNotificationsPlugin _localNotificationPlugin =FlutterLocalNotificationsPlugin();
  static const AndroidInitializationSettings _androidInitializationSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
  static const DarwinInitializationSettings _iosInitializationSettings = DarwinInitializationSettings();
  static String ? _googleAccessToken;




  static  AndroidNotificationDetails _androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'com.example.FirebaseHelper',
    'FirebaseHelper',
    playSound: true,
    enableVibration: true,
    importance: Importance.max,
    priority: Priority.max,
  );
  static const DarwinNotificationDetails _iOSPlatformChannelSpecifics = DarwinNotificationDetails();
  static  NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: _androidPlatformChannelSpecifics,
      iOS: _iOSPlatformChannelSpecifics);


  static const InitializationSettings initializationSettings = InitializationSettings(
      android: _androidInitializationSettings, iOS: _iosInitializationSettings );
  static  getFcmToken()async{
    _fcmToken = await _firebaseMessaging.getToken();
    CacheHelper.setFcmToken(_fcmToken);
    return _fcmToken;
  }

  static Future<void> showBackgroundNotification(RemoteMessage message)async{
    if(message.notification!=null){
      log("message notifivation ${message.notification?.title}");
    }else{
      log("no message received");
    }
  }
  static Future <void> initializeFirebaseMessagingOptions()async{
    FirebaseMessaging.instance.setAutoInitEnabled(true);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.onBackgroundMessage(FirebaseNotificationRepository.showBackgroundNotification);
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        FirebaseNotificationRepository.showNotification(message);}
    });
  }

  static Future<ByteArrayAndroidBitmap> _imageToBitmap({required String url})async{
   Response image = await DioHelper.getImage(url: url);
   ByteArrayAndroidBitmap androidBitmap = ByteArrayAndroidBitmap.fromBase64String(base64.encode(image.data));
   return androidBitmap;
  }




  static askForPermission()async{
    await NotificationPermissions.requestNotificationPermissions();
  }
  static  _setAndroidPlatformChannelSpecifics({RemoteNotification? notification})async{
    ByteArrayAndroidBitmap? largeIcon =notification?.android?.imageUrl != null?await _imageToBitmap(url:notification!.android!.imageUrl!):null;
    // print()
    _androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'com.example.FirebaseHelper',
      'FirebaseHelper',
      playSound: true,
      enableVibration: true,
      largeIcon: largeIcon,
      importance: Importance.max,
      priority: Priority.max,
    );
  }

  static showNotification(RemoteMessage? msg) async {
   await _setAndroidPlatformChannelSpecifics(notification: msg!.notification);
    await _localNotificationPlugin.initialize(initializationSettings);
    await _localNotificationPlugin.show(
        _testI, msg.notification!.title, msg.notification!.body,

        platformChannelSpecifics,
        payload: null);
    _testI++;
  }

  static _getAccessToken()async{
    const serviceAccountJson = {
      "type": "service_account",
      "project_id": "fir-helper-c5a43",
      "private_key_id": "b8193b797f1038d39aeede5776319423811d72f2",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCOUdEerrrHUdoy\nYq7okoqZ2xgPEQKRydfF3qmChA9pQRyO50xrIlaacz8sJKcomRadtipvjbDdEPzN\nDBHCLuiqaEWCALE++qvuNXTJ/AHHKv91fP46xxslAefThibqrM4TfHeKc1uXURLx\nJGto9aRi3GgYBE5l/qml510Q+asuWi/YBRebr8YQLhXn6yj93POv4vyssmscVhim\nQC/ffsCKhWj08lOoLFUEHmW+46DmyI/xCIk1BrdmZ3Wh9kIfrGQ5m5gUutPYnMh0\nnNl4NmPVGErpXA4idKAsaW6stPqWZDmD4UoApgZHygkYCMHuesR/yapPivseDB2Y\n0m2BfIWxAgMBAAECggEAA77dGHs6W/4oSYsvVak43JokV/Rd2b7MkivG0LIiqOWw\n/etrp3L2TiCz8oV3oMOARN/pqsxTC0swwnS+3ICl8iL5MVXmh36XzjBTkooY9RTv\n0QSPhelKw/6SccHmF4ChkjTqyhbSVXkpkA8iHiQ/RbRnSO26fBS0gkx3tpEOxqyu\n6CWiLBcgCFofpFyBzn0XHrzdqxkfGkHo3KmsRPDy7vnyabp+LxbVjqVP9DFK68/t\nj6dYKkEriCyEz/FImuv2G7Cs8XyuY49dWZT7DXqqbHIcNbagbxnM30rzrfVbXM48\nSziXIUof2KoeAAeAiSenY2JXqiTLsqUp1q9dvZq5AQKBgQDFaUt1cIg9GQVNFQEP\n5g2bh0wnKrKh0KvC0FGJF0BW2YzL1GjAhIfie+5UAHASVowqFNE9dbgpv64y2OoO\nSmhJFsU/xiEhVkb5IFM5G9LKJECYF82hNcXp0y7flPjwF5hUftInrLnBwSPvr5tV\n0UL43Si8YVjDyL5tXmhwo1uytQKBgQC4jtKzAtQLLivfXx9Tx7TdSjG6NAyFWcOF\nEWZwXkReTbGjtLULx7TbKIieWCa+9qP4rteeoHlj5LKVekAg7FYAWlmTWvIOnUQZ\n/nM1my8h5ZoYP1MYAfYT/Vnwj4Gpwj17mfHQHoq7zONUOJciZhheLrh2SemhkX6n\n0fud2gW4jQKBgDoG+WdL7MAI2sYNpoJF3ToaSwg4RMnLzLE3CsCBVSgySnCfvyrX\nyhmI1EVc25SIXCsCc37dW4TqEwpfOG168ayKRPC6DIMAGVyhY9UlmJBSl6odVRRN\n+h8BNIYEBCiOxvgPTzbaTr/lReruc3qGSGlemNrGwpDKMS900L5LRmkBAoGBALR6\n7u8iD+yTDVJWOlN605Mn0DNQXQI3Au3pUy0F8oPqJJJ70CSh+mnrXJbEi7dpiHZT\nvQYh1jPq3P0yXO4VUBDuSfTBFj9WadelrlK43EGgv62Al6i9mkB4HHEUVW+GRQvP\nQtsMUw1OUuz0nk+EWcYYmEkNBMz8dEh3H0GBiOCtAoGAHGqpvHKW/lwPJdV/JryS\n2rpOkAyRBverysnNi5qD24bKR8Tp0qpKQTiDPJsXijDg/7nzKBML7uCyBs0A8XLQ\nApRtp/hWNHG7p2zrIaJxnukf8pznY0x0SRo5H3MWxtIj2Vswjy8Ie1XBvfDaNR6c\nGyLXR0JhGhxoyb8M7cAUTWY=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebasehelper@fir-helper-c5a43.iam.gserviceaccount.com",
      "client_id": "108735110392477788447",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebasehelper%40fir-helper-c5a43.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"

    };

    const List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",


    ];

    try{
      if(_googleAccessToken==null){
        AutoRefreshingAuthClient client= await clientViaServiceAccount(
            ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes);
        AccessCredentials credentials = await obtainAccessCredentialsViaServiceAccount(
            ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes ,
            client);

        client.close();
        _googleAccessToken =credentials.accessToken.data;

      }
      return _googleAccessToken;

    } catch (e){
      print(e);
        }
  }

  // fir-helper-c5a43
  static sendNotificationToSelectedDevice({ required String message , required String title , required String ? targetToken,String ?imageUrl})async{
    final String serverKey= await _getAccessToken();
    const String endpointFirebaseCloudMessaging = "https://fcm.googleapis.com/v1/projects/fir-helper-c5a43/messages:send";
    // const String targetToken="c5wNH2JPQPm0MP7Fo8EBpD:APA91bGTGes0Sc97Nwv8SA6fUAEcv957ZbgVTcr7e6NPJfwC5WF6-t2HYDSnIU3G2H3wcPMN4MnQHCe1g13gwt6auMcpCTIL7SeOiFyNU4KVF9_85QLkvA4W9icEGuI-_2XcAK9otYC7";
    final Map<String,dynamic> notification ={
      'message':{
        'token': targetToken,
        'notification':{
          "title":title,
          "body": message,
          "imageUrl": message
        }
      }
    };
    
    DioHelper.setData(url: endpointFirebaseCloudMessaging , query: notification , token: serverKey);
  }


}