
import 'message_model.dart';

class ChatModel{
  String lastMessage;
  String lastSenderId;
  String lastMessageTimeStamp;
  int unSeenMessageCount;


  String lastMessageSeenTimeStamp;
  String chatId;
  String chatImage;
  String chatName;


//<editor-fold desc="Data Methods">
  ChatModel({
    required this.lastMessage,
    required this.lastSenderId,
    required this.lastMessageTimeStamp,
    required this.unSeenMessageCount,
    required this.lastMessageSeenTimeStamp,
     this.chatId = "",
     this.chatImage = "",
     this.chatName = ""
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatModel &&
          lastMessageTimeStamp == other.lastMessageTimeStamp &&
          chatId == other.chatId );


  @override
  String toString() {
    return 'ChatModel{' +
        ' lastMessage: $lastMessage,' +
        ' lastSenderId: $lastSenderId,' +
        ' lastMessageTimeStamp: $lastMessageTimeStamp,' +
        ' unSeenMessageCount: $unSeenMessageCount,' +
        ' chatId: $unSeenMessageCount,' +
        ' unSeenMessageCount: $unSeenMessageCount,' +
        '}';
  }

  ChatModel copyWith({
    String? lastMessage,
    String? lastSenderId,
    String? lastMessageTimeStamp,
    String? chatImage,
    String? chatId,
    String? chatName,
    int? unSeenMessageCount,
    String? lastMessageSeenTimeStamp,
  }) {
    return ChatModel(
      lastMessage: lastMessage ?? this.lastMessage,
      lastSenderId: lastSenderId ?? this.lastSenderId,
      lastMessageTimeStamp: lastMessageTimeStamp ?? this.lastMessageTimeStamp,
      unSeenMessageCount: unSeenMessageCount ?? this.unSeenMessageCount,
      chatName: chatName??this.chatName,
      chatImage: chatImage??this.chatImage,
      chatId: chatId??this.chatId,
      lastMessageSeenTimeStamp: lastMessageSeenTimeStamp??this.lastMessageSeenTimeStamp
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastMessage': this.lastMessage,
      'lastSenderId': this.lastSenderId,
      'lastMessageTimeStamp': this.lastMessageTimeStamp,
      'lastMessageSeenTimeStamp': this.lastMessageSeenTimeStamp,
      'unSeenMessageCount': this.unSeenMessageCount,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      lastMessage: map['lastMessage'] as String,
      lastSenderId: map['lastSenderId'] as String,
      lastMessageTimeStamp:map['lastMessageTimeStamp'],
      lastMessageSeenTimeStamp:map['lastMessageSeenTimeStamp'],
      unSeenMessageCount: map['unSeenMessageCount'] as int,
      chatId: map["uId"] ?? "",
      chatImage:map["image"] ??"" ,
      chatName:map["name"] ??""
    );
  }

//</editor-fold>
}