
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_helper/models/controllers/chats/chat_model.dart';
import 'package:firebase_helper/models/controllers/chats/message_model.dart';
import 'package:firebase_helper/models/controllers/user/user.dart';
import 'package:firebase_helper/models/controllers/user/user_cubit.dart';
import 'package:firebase_helper/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  static ChatCubit get(context)=>BlocProvider.of(context);


  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final TextEditingController messageTextController = TextEditingController();
  List<ChatModel> chats=[];
  ChatModel ?currentChat ;
  List<MessageModel> chatMessages= [];

  @override
  Future<void>close()async {
    if(_chatsStream!=null){
      _chatsStream!.cancel();
    }
    if(_chatMessagesStream!=null){
      _chatMessagesStream!.cancel();
    }
    if(_currentChatStream!=null){
      _currentChatStream!.cancel();
    }
    if(_targetUserChatStream!=null){
      _targetUserChatStream!.cancel();
    }
    super.close();
  }

   StreamSubscription<QuerySnapshot<Map<String, dynamic>>> ?_chatsStream;
   StreamSubscription<QuerySnapshot<Map<String, dynamic>>> ?_chatMessagesStream;
   StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> ?_currentChatStream;
   StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> ?_targetUserChatStream;
   String _targetUserLastSeen= "";





  getCurrentChats({required BuildContext context}){
    UserCubit userCubit = UserCubit();

    String myUid= CacheHelper.getData(key: "uId");
     _chatsStream= firebaseFirestore.collection("users").doc(myUid).collection("chats").snapshots(includeMetadataChanges: true).listen((event) {
      chats = [];
      for (var element in event.docs) {
        _createNewChatModel(element: element, userCubit: userCubit);
      }
    });
  }



  getAndUpdateCurrentChat({required String chatId}){
    String uId = CacheHelper.getData(key:"uId");

    _currentChatStream = firebaseFirestore.collection("users").doc(uId).collection("chats").doc(chatId).snapshots(includeMetadataChanges: true).listen((event) {
      ChatModel newChatModel = ChatModel.fromMap(event.data()!);
      if(newChatModel != currentChat){
        _updateSeenOnChatPage(chatModel: newChatModel, uId: uId, chatId: chatId);
        currentChat = newChatModel ;
      }
    });

  }

  _updateSeenOnChatPage({required ChatModel chatModel , required String  uId ,required String chatId }){
    _updateChatInfo(chatModel: chatModel.copyWith(unSeenMessageCount: 0 , lastMessageSeenTimeStamp: DateTime.now().toString()), firstDoc: uId, secondDoc: chatId);

  }

  getChatUserLastSeen({required String chatId}){
    String uId = CacheHelper.getData(key:"uId");

    _targetUserChatStream = firebaseFirestore.collection("users").doc(chatId).collection("chats").doc(uId).snapshots(includeMetadataChanges: true).listen((event) {
      _targetUserLastSeen = event.data()!["lastMessageSeenTimeStamp"];
    });
  }

  getChatMessages({required String chatId}){
    chatMessages=[];
    String uId = CacheHelper.getData(key: "uId");
    _chatMessagesStream= firebaseFirestore.collection("users").doc(uId).collection("chats").doc(chatId).collection("messages").orderBy("timeStamps").snapshots(includeMetadataChanges: true).listen((event){
      chatMessages = [];

       for (var element in event.docs) {
          MessageModel messageModel = MessageModel.fromMap(element.data());
          messageModel.isSent = !element.metadata.hasPendingWrites;

          if(DateTime.parse(element.data()["timeStamps"]).isBefore(DateTime.parse(_targetUserLastSeen))){
            messageModel.isMessageSeen=true;
          }else{
            print("Time Vs ${messageModel.originalTimeStamps} vs ${_targetUserLastSeen}");
          }
          chatMessages.add(messageModel);
        }
       chatMessages=chatMessages.reversed.toList();
      emit(GetChatMessagesSuccessState());


    });


  }




  _createNewChatModel({required QueryDocumentSnapshot<Map<String, dynamic>> element ,required UserCubit userCubit})async{
    UserModel? userModel = await userCubit.getUser(uId: element.id);
    Map<String,dynamic> value = element.data();
    value.addAll(userModel!.toMap());
    ChatModel chatModel= ChatModel.fromMap(value);
    if(chats.any((element) => element.chatId==chatModel.chatId)){
      return;
    }
    chats.add(chatModel);
    emit(GetUserChatsSuccessState());

  }

  sendMessage({
    required String receiverId ,
    required String message
})async{
    String senderId=CacheHelper.getData(key: "uId");


    MessageModel messageModel = MessageModel(
        senderId: senderId,
        receiverId: receiverId,
        timeStamps: DateTime.now().toString(),
        message: message);
    if(!await _checkIfChatDocExist(firstDoc: messageModel.senderId, secondDoc: messageModel.receiverId)){
      _createChatDoc(firstDoc: messageModel.senderId, secondDoc: messageModel.receiverId);
    }
    _addMessageToCollection(messageModel: messageModel);
    if(!await _checkIfChatDocExist(firstDoc: messageModel.receiverId, secondDoc: messageModel.senderId)){
      _createChatDoc(firstDoc: messageModel.receiverId, secondDoc: messageModel.senderId);
    }
    _addMessageToCollection(messageModel: messageModel , senderCollection: false);

  }

  Future<bool> _checkIfChatDocExist({required String firstDoc , required String secondDoc})async{
    return await firebaseFirestore.collection("users").
    doc(firstDoc).
    collection("chats").
    doc(secondDoc).get().then((value) {
      return value.exists;
    });
  }

  _addMessageToCollection({required MessageModel messageModel ,bool senderCollection = true }){
    firebaseFirestore.collection("users").
    doc(senderCollection?messageModel.senderId:messageModel.receiverId).
    collection("chats").
    doc(senderCollection?messageModel.receiverId:messageModel.senderId).collection("messages").add(messageModel.toMap()).then((value) {

      getAndUpdateChatInfoAfterMessageSent(messageModel: messageModel , sender: senderCollection ,);
    });
  }


 Future<ChatModel?>  _getChatInfo({required String firstDoc , required String secondDoc})async{
    return await firebaseFirestore.collection("users").doc(firstDoc).collection("chats").doc(secondDoc).get().then((value) {
      return ChatModel.fromMap(value.data()!);
    });
  }
  _updateChatInfo({required ChatModel chatModel , required String firstDoc , required String secondDoc}){
    firebaseFirestore.collection("users")
        .doc(firstDoc)
        .collection("chats")
        .doc(secondDoc)
        .set(chatModel.toMap());
  }

  getAndUpdateChatInfoAfterMessageSent({required MessageModel messageModel,bool sender = true})async{

    ChatModel ? oldChatModel = await _getChatInfo(firstDoc:sender?messageModel.senderId:messageModel.receiverId ,secondDoc: sender?messageModel.receiverId:messageModel.senderId);
    if(oldChatModel!=null){
      ChatModel newChatModel = oldChatModel.copyWith(
        lastMessage: messageModel.message,
        lastSenderId: messageModel.senderId,
        lastMessageTimeStamp: messageModel.timeStamps,
        unSeenMessageCount: sender?0:oldChatModel.unSeenMessageCount+1
      );
      _updateChatInfo(chatModel: newChatModel, firstDoc: sender?messageModel.senderId:messageModel.receiverId, secondDoc: sender?messageModel.receiverId:messageModel.senderId);
    }

    }


  _createChatDoc({required String firstDoc , required String secondDoc}){
    ChatModel chatModel =ChatModel
      (lastMessage: "",
        lastSenderId: "",
        lastMessageTimeStamp: "",
        lastMessageSeenTimeStamp: DateTime.now().toString(),
        unSeenMessageCount: 0);
    _updateChatInfo(chatModel: chatModel, firstDoc: firstDoc, secondDoc: secondDoc);
  }


}
