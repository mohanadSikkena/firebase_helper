
import 'package:cloud_firestore/cloud_firestore.dart';

import '../message/message_model.dart';

class ChatModel{
  String lastMessage;
  String lastSenderId;
  int unSeenMessageCount;


  String chatId;
  String chatImage;
  String chatName;


  MessageTypes lastMessageType;
  String stringTimeStamp;
  Timestamp? lastMessageSeenTimeStamp;
  Timestamp ?lastMessageTimeStamp;




//<editor-fold desc="Data Methods">
  ChatModel({
    required this.lastMessage,
    required this.lastSenderId,
    this.stringTimeStamp = "",
    this.lastMessageTimeStamp,
    this.lastMessageSeenTimeStamp,
    required this.unSeenMessageCount,
     required this.chatId ,
     required this.chatImage ,
     required this.chatName,
    required this.lastMessageType
  });


  @override
  String toString() {
    return 'ChatModel{lastMessage: $lastMessage, lastSenderId: $lastSenderId, unSeenMessageCount: $unSeenMessageCount, chatId: $chatId, chatImage: $chatImage, chatName: $chatName, stringTimeStamp: $stringTimeStamp, lastMessageSeenTimeStamp: $lastMessageSeenTimeStamp, lastMessageTimeStamp: $lastMessageTimeStamp}';
  }

  ChatModel copyWith({
    String? lastMessage,
    String? lastSenderId,
    Timestamp? lastMessageTimeStamp,
    String? chatImage,
    String? chatId,
    String? chatName,
    int? unSeenMessageCount,
    String?stringTimeStamp,
    Timestamp? lastMessageSeenTimeStamp,
    MessageTypes ?lastMessageType,
  }) {
    return ChatModel(
      lastMessage: lastMessage ?? this.lastMessage,
      lastSenderId: lastSenderId ?? this.lastSenderId,
      lastMessageTimeStamp: lastMessageTimeStamp ?? this.lastMessageTimeStamp,
      unSeenMessageCount: unSeenMessageCount ?? this.unSeenMessageCount,
      stringTimeStamp: stringTimeStamp??this.stringTimeStamp,
      chatName: chatName??this.chatName,
      chatImage: chatImage??this.chatImage,
      chatId: chatId??this.chatId,
      lastMessageSeenTimeStamp: lastMessageSeenTimeStamp??this.lastMessageSeenTimeStamp,
      lastMessageType: lastMessageType??this.lastMessageType
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastMessage': lastMessage,
      'lastSenderId': lastSenderId,
      'lastMessageTimeStamp': lastMessageTimeStamp,
      'lastMessageSeenTimeStamp': lastMessageSeenTimeStamp,
      'unSeenMessageCount': unSeenMessageCount,
      'chatName':chatName,
      'chatId':chatId,
      'chatImage':chatImage
    };
  }

  Map<String, dynamic> toMapUpdateLastMessageTimeStampAndLastSeen() {
    return {
      'lastMessage': lastMessage,
      'lastSenderId': lastSenderId,
      'lastMessageTimeStamp': FieldValue.serverTimestamp(),
      'lastMessageSeenTimeStamp':Timestamp.fromDate(DateTime(2001)),
      'unSeenMessageCount': unSeenMessageCount,
      'chatName':chatName,
      'chatId':chatId,
      'chatImage':chatImage
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      lastMessage: map['lastMessage'] as String,
      lastSenderId: map['lastSenderId'] as String,
      lastMessageTimeStamp:map['lastMessageTimeStamp'],
      lastMessageSeenTimeStamp:map['lastMessageSeenTimeStamp'],
      unSeenMessageCount: map['unSeenMessageCount'] as int,
        stringTimeStamp:formattedTimeStamp(inputTimeStamp:map['lastMessageTimeStamp'] ),
      lastMessageType: MessageTypes.fromJson(map['lastMessageType']),
      chatId: map["chatId"] ?? "",
      chatImage:map["chatImage"] ??"" ,
      chatName:map["chatName"] ??""
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatModel &&
          chatId == other.chatId &&
          lastMessageTimeStamp == other.lastMessageTimeStamp;

  @override
  int get hashCode => chatId.hashCode ^ lastMessageTimeStamp.hashCode;

//</editor-fold>
}