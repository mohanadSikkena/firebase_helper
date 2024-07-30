
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_helper/repositories/vidos/video_repository.dart';
import 'package:uuid/uuid.dart';
import '../../core/cache/cache_helper.dart';
import '../../models/chat/chat_model.dart';
import '../../models/user/user.dart';
import '../../models/message/message_model.dart';
import '../images/image_repository.dart';
import '../notifications/notification_repository.dart';
import '../user/user_repository.dart';

class ChatRepository{
  static final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  static updateChatImage({required String chatId, required String uId , required String image}){
    _firebaseFirestore.collection("users").doc(chatId).collection("chats").doc(uId).update({
      "chatImage":image
    });
  }
  static _createChat({required Map<String,dynamic>map , required String firstDoc , required String secondDoc}){
    log("_updateChatInfo  fired");
    _firebaseFirestore.collection("users")
        .doc(firstDoc)
        .collection("chats")
        .doc(secondDoc)
        .set(map);
  }

  static _createChatDoc({required String firstDoc , required String secondDoc})async{
    UserModel ? userModel = await UserRepository.getUser(uId: secondDoc);
    if(userModel!=null){
      ChatModel chatModel =ChatModel
        (
          lastMessage: "",
          lastSenderId: "",

          lastMessageType: MessageTypes.text,
          unSeenMessageCount: 0,
          chatId: userModel.uId,
          chatImage: userModel.image,
          chatName: userModel.name);

      _createChat(map: chatModel.toMapUpdateLastMessageTimeStampAndLastSeen(), firstDoc: firstDoc, secondDoc: secondDoc);

    }
  }



  static sendTextMessage({required String receiverId , required String message}){
    String senderId=CacheHelper.getData(key: "uId");
    MessageModel messageModel = MessageModel(
      messageType: MessageTypes.text,
      senderId: senderId,
      receiverId: receiverId,
      message: message,  );

    _sendMessage(messageModel: messageModel);
}


static sendVideoMessage({required String receiverId, required File video})async{
  String senderId=CacheHelper.getData(key: "uId");
  MessageModel messageModel = MessageModel(
    messageType: MessageTypes.video,
    senderId: senderId,
    receiverId: receiverId,
    message:await VideoRepository.getVideoThumbnail(videoPath: video.path)??video.path,  );
  Future.wait([
    _sendMessage(messageModel: messageModel),
    VideoRepository.compressAndUploadVideoToFirebase(video: video,distension: "/chats/videos/$senderId/${const Uuid().v4()}")
  ]).then((value) {
    if(value[1].$1 as bool){
      Future.wait([
        _updateMessage(id: value[0].$1 as String, messageModel: messageModel, message: value[1].$2),
        _updateMessage(id: value[0].$2, messageModel: messageModel, message: value[1].$2 ,firstMessage: false)
      ]);
    }
  });
}
static sendImageMessage({required String receiverId , required File image}){
    String senderId=CacheHelper.getData(key: "uId");
    MessageModel messageModel = MessageModel(
      messageType: MessageTypes.image,
      senderId: senderId,
      receiverId: receiverId,
      message: image.path,  );

    Future.wait([
       _sendMessage(messageModel: messageModel),
      ImageRepository.compressAndUploadImageToFirebase(image: image,distension: "/chats/images/$senderId/${const Uuid().v4()}")
    ]).then((value) {
      if(value[1].$1 as bool){
        Future.wait([
          _updateMessage(id: value[0].$1 as String, messageModel: messageModel, message: value[1].$2),
          _updateMessage(id: value[0].$2, messageModel: messageModel, message: value[1].$2 ,firstMessage: false)
        ]);
      }
    });
}

  static Future<void> _updateMessage({required String id,bool firstMessage= true ,required MessageModel messageModel,required String message})async{
     await _firebaseFirestore.collection("users").
    doc(firstMessage?messageModel.senderId:messageModel.receiverId).
    collection("chats").
    doc(firstMessage?messageModel.receiverId:messageModel.senderId).collection("messages").doc(id).update({
       "message":message
     });
  }


  static Future<(String,String)>_sendMessage({
    required MessageModel messageModel
  })async{
    String firstMessageId;
    String secondMessageId;

    if(!await _checkIfChatDocExist(firstDoc: messageModel.senderId, secondDoc: messageModel.receiverId)){
      _createChatDoc(firstDoc: messageModel.senderId, secondDoc: messageModel.receiverId);
    }
    firstMessageId =await _addMessageToCollection(messageModel: messageModel);
    if(!await _checkIfChatDocExist(firstDoc: messageModel.receiverId, secondDoc: messageModel.senderId)){
      _createChatDoc(firstDoc: messageModel.receiverId, secondDoc: messageModel.senderId);
    }
    secondMessageId = await _addMessageToCollection(messageModel: messageModel , senderCollection: false);
  return (firstMessageId,secondMessageId);
  }
  static Future<bool> _checkIfChatDocExist({required String firstDoc , required String secondDoc})async{
    return await _firebaseFirestore.collection("users").
    doc(firstDoc).
    collection("chats").
    doc(secondDoc).get().then((value) {
      return value.exists;
    });
  }

  static Future<String> _addMessageToCollection({required MessageModel messageModel ,bool senderCollection = true })async{
    String messageId = await _firebaseFirestore.collection("users").
    doc(senderCollection?messageModel.senderId:messageModel.receiverId).
    collection("chats").
    doc(senderCollection?messageModel.receiverId:messageModel.senderId).collection("messages").add(messageModel.toMap()).then((value) async{
      if(!senderCollection){

        final token =await UserRepository.getFcmForAnyUser(uId: messageModel.receiverId);
        final senderUser =await UserRepository.getNameAndImageForCurrentUser();

        FirebaseNotificationRepository.sendNotificationToSelectedDevice
          (
            message: messageModel.message,//message
            title: senderUser.$1, //sender name,
            imageUrl: senderUser.$2,
            targetToken: token);
      }
      return value.id;
    });
    _updateChatInfoAfterMessageSent(messageModel: messageModel , sender: senderCollection ,);
  return messageId;
  }

  static _updateChatInfoAfterMessageSent({required MessageModel messageModel,bool sender = true})async{
    log("_updateChatInfoAfterMessageSent-> _updateChatInfo");
    Map<String,dynamic> map= {
      "lastMessage":messageModel.message,
      "lastSenderId":messageModel.senderId,
      "lastMessageType":messageModel.messageType.toJson(),
      "unSeenMessageCount":sender?0:FieldValue.increment(1),
      "lastMessageTimeStamp":FieldValue.serverTimestamp()
    };
    updateChat(map: map, firstDoc: sender?messageModel.senderId:messageModel.receiverId, secondDoc: sender?messageModel.receiverId:messageModel.senderId);
  }

  static updateChat({required Map<String,dynamic>map , required String firstDoc , required String secondDoc}){
    log("_updateChatInfo  fired");
    _firebaseFirestore.collection("users")
        .doc(firstDoc)
        .collection("chats")
        .doc(secondDoc)
        .update(map);
  }

}