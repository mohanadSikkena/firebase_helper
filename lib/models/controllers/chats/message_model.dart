

import 'package:firebase_helper/shared/network/local/cache_helper.dart';
import 'package:intl/intl.dart';

class MessageModel {
  String senderId;
  String receiverId;
  String timeStamps;
  String originalTimeStamps;
  String message;
  bool isSender;
  bool isSent;
  bool isMessageSeen;


//<editor-fold desc="Data Methods">
  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.timeStamps,
    required this.message,
    this.originalTimeStamps = "",
    this.isSender=false,
    this.isSent = false,
    this.isMessageSeen = false
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageModel &&
          runtimeType == other.runtimeType &&
          senderId == other.senderId &&
          receiverId == other.receiverId &&
          timeStamps == other.timeStamps &&
          message == other.message);

  @override
  int get hashCode =>
      senderId.hashCode ^
      receiverId.hashCode ^
      timeStamps.hashCode ^
      message.hashCode;

  @override
  String toString() {
    return 'MessageModel{ senderId: $senderId, receiverId: $receiverId, timeStamps: $timeStamps, message: $message,}';
  }

  MessageModel copyWith({
    String? senderId,
    String? receiverId,
    String? timeStamps,
    String? message,
    String? originalTimeStamps,
  }) {
    return MessageModel(
      senderId: senderId ?? this.senderId,
      originalTimeStamps: originalTimeStamps ?? this.originalTimeStamps,
      receiverId: receiverId ?? this.receiverId,
      timeStamps: timeStamps ?? this.timeStamps,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'timeStamps': timeStamps,
      'message': message,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {

    return MessageModel(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      originalTimeStamps: map["timeStamps"] as String,
      // timeStamps:formattedTimeStamp(timeStampString: map['timeStamps']) ,
      timeStamps: map['timeStamps'] ,
      message: map['message'] as String,
      isSender:map['senderId'] == CacheHelper.getData(key: "uId")
    );
  }

//</editor-fold>
}
// String formattedTimeStamp({required String timeStampString}){
//   DateTime now =DateTime.now();
//   DateTime timeStamp =DateTime.parse(timeStampString);
//
//   if(timeStamp.day== now .day){
//     return (DateFormat('hh:mm').format(timeStamp));
//   }
//   else if(timeStamp.year !=now.year){
//     return (DateFormat('yyyy MM dd hh:mm').format(timeStamp));
//
//   }
//   else{
//     return (DateFormat('dd-MM').format(timeStamp));
//   }
// }
