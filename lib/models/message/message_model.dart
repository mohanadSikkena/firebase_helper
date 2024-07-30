

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_helper/core/cache/cache_helper.dart';
import 'package:firebase_helper/views/widgets/screen_widgets/chat_details/video_message_widget.dart';
import 'package:intl/intl.dart';

import '../../repositories/vidos/video_repository.dart';




class MessageModel {
  String senderId;
  String receiverId;
  Timestamp ?timeStamps;
  Timestamp ?originalTimeStamps;
  String  stringTimeStamp;
  String message;
  bool isSender;
  bool isSent;
  bool isMessageSeen;
  MessageTypes messageType;

  String? thumbnail="";

//<editor-fold desc="Data Methods">
  MessageModel({
    required this.senderId,
    required this.receiverId,
    this.timeStamps,
    required this.message,
   this.originalTimeStamps,
    this.stringTimeStamp = "",
    this.isSender=false,
    this.isSent = false,
    this.isMessageSeen = false,
    required this.messageType
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
    Timestamp? timeStamps,
    String? message,
    Timestamp? originalTimeStamps,
    String ?stringTimeStamp,
    MessageTypes? messageType
  }) {
    return MessageModel(
      senderId: senderId ?? this.senderId,
      originalTimeStamps: originalTimeStamps ?? this.originalTimeStamps,
      receiverId: receiverId ?? this.receiverId,
      timeStamps: timeStamps ?? this.timeStamps,
      message: message ?? this.message,
      stringTimeStamp: stringTimeStamp??this.stringTimeStamp,
      messageType: messageType??this.messageType
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'timeStamps': FieldValue.serverTimestamp(),
      'message': message,
      'messageType' :messageType.toJson()
    };
  }

  getVideoThumbnailImage() async{
    if(messageType==MessageTypes.video){
      thumbnail= await VideoRepository.getVideoThumbnail(videoPath: message);
    }
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      originalTimeStamps: map["timeStamps"] ,
      timeStamps: map['timeStamps'] ,
      message: map['message'] as String,
      isSender:map['senderId'] == CacheHelper.getData(key: "uId"),
      stringTimeStamp: formattedTimeStamp(inputTimeStamp:map['timeStamps'],),
      messageType: map['messageType']!=null?MessageTypes.fromJson(map['messageType']):MessageTypes.text,
    );
  }

//</editor-fold>
}


String formattedTimeStamp({required Timestamp ? inputTimeStamp}){
  DateTime now =DateTime.now();
  if(inputTimeStamp ==null){
    return "";
  }

  DateTime timeStamp =inputTimeStamp.toDate();

  if(timeStamp.day== now .day){
    return (DateFormat('hh:mm').format(timeStamp));
  }
  else if(timeStamp.year !=now.year){
    return (DateFormat('yyyy MM dd hh:mm').format(timeStamp));

  }
  else{
    return (DateFormat('dd-MM').format(timeStamp));
  }
}

enum MessageTypes{
  text , image , video;
  String toJson() => name;
  static MessageTypes fromJson(String json) => values.byName(json);

}