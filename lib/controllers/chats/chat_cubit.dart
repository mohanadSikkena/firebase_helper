
import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_helper/core/cache/cache_helper.dart';
import 'package:firebase_helper/repositories/chat/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/chat/chat_model.dart';
import '../../models/message/message_model.dart';


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
    if(_targetUserChatStream!=null){
      _targetUserChatStream!.cancel();
    }
    super.close();
  }

   StreamSubscription<QuerySnapshot<Map<String, dynamic>>> ?_chatsStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> ?_chatMessagesStream;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      get chatMessagesStream => _chatMessagesStream;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> ?_targetUserChatStream;
   Timestamp ?  _targetUserLastSeen ;



   
   


  getChatUserLastSeen({required String chatId}){
    String uId = CacheHelper.getData(key:"uId");

    _targetUserChatStream = firebaseFirestore.collection("users").doc(chatId).collection("chats").doc(uId).snapshots(includeMetadataChanges: true).listen((event) {
      _targetUserLastSeen = event.data()?["lastMessageSeenTimeStamp"];
      if(_targetUserLastSeen!=null){
        CacheHelper.putInt(key: chatId, value:_targetUserLastSeen!.millisecondsSinceEpoch );
      }
      List<MessageModel> unSeenMessages = chatMessages.where((element) => !element.isMessageSeen).toList();

      for (var element in unSeenMessages) {
        if(element.isSent){
          if(element.timeStamps!.toDate().isBefore(_targetUserLastSeen!.toDate())){
            element.isMessageSeen = true;
          }
        }
      }

      emit(GetChatMessagesSuccessState());

    });



  }
  getChatMessages({required String chatId}){
    chatMessages=[];
    String uId = CacheHelper.getData(key: "uId");
    _chatMessagesStream= firebaseFirestore.collection("users").
    doc(uId).collection("chats").doc(chatId).collection("messages").orderBy("timeStamps" ,descending: true ).snapshots(includeMetadataChanges: true).listen((event){
      if(!event.metadata.isFromCache ){
        _updateSeenOnChatPage(uId: uId, chatId: chatId);
      }
      chatMessages = [];
      print(event.docs.length);
       for (var element in event.docs) {
          _createMessageModelAtChatScreen(messageData: element);
       }
      emit(GetChatMessagesSuccessState());

    });








  }
















  getTargetUserLastSeenFromCache ({required String uId}){
    int data =CacheHelper.getInt(key: uId)??0;
    _targetUserLastSeen =Timestamp.fromMillisecondsSinceEpoch(data);
  }

  _updateSeenOnChatPage({required String  uId ,required String chatId }){
    Map<String,dynamic> map ={
      "unSeenMessageCount":0,
      'lastMessageSeenTimeStamp': FieldValue.serverTimestamp(),
    };
    log("_updateSeenOnChatPage-> _updateChatInfo");
    ChatRepository.updateChat(map:map, firstDoc: uId, secondDoc: chatId);

  }



  _createMessageModelAtChatScreen({required QueryDocumentSnapshot<Map<String, dynamic>>messageData})async{
    try{
      MessageModel messageModel = MessageModel.fromMap(messageData.data());
      messageModel.isSent = !messageData.metadata.hasPendingWrites;
      if(messageData.data()["timeStamps"] !=null &&_targetUserLastSeen!=null){
        if(messageData.data()["timeStamps"].toDate().isBefore(_targetUserLastSeen!.toDate())){
          messageModel.isMessageSeen=true;
        }
      }
      print("message model ${messageModel.message} + ${messageModel.timeStamps?.toDate()}");
      await messageModel.getVideoThumbnailImage();
      chatMessages.add(messageModel);
    }
    catch(e){
      log("Craete MessageModel At ChatsPage E ${e.toString()}");
      emit(GetChatMessagesFailState());
    }
  }
  getCurrentChats({required BuildContext context}){
    String myUid= CacheHelper.getData(key: "uId");
    _chatsStream= firebaseFirestore.collection("users").doc(myUid).collection("chats").orderBy("lastMessageTimeStamp" , descending:true).snapshots(includeMetadataChanges: true).listen((event) async {
      chats = [];
      emit(GetUserChatsLoadingState());
      for (var element in event.docs) {
       await  _createChatModelAtChatsScreen(element: element , context: context);
      }
      emit(GetUserChatsSuccessState());
    });

  }
  _createChatModelAtChatsScreen({required QueryDocumentSnapshot<Map<String, dynamic>> element  ,required BuildContext context})async{
    Map<String,dynamic> value = element.data();
    ChatModel chatModel= ChatModel.fromMap(value);
    if(chats.any((element) =>element.chatId ==chatModel.chatId )){
      ChatModel oldChatModel = chats.firstWhere((element)=> element.chatId==chatModel.chatId);
      chats[chats.indexOf(oldChatModel)]=chatModel;
      return ;
    }
    chats.add(chatModel);
    await CacheHelper.cacheUserImage(context: context, userImage: chatModel.chatImage);
  }







  bool _showFABLabel = true;

  bool get showFABLabel => _showFABLabel;

  bool chatsScreenChangeScrollDirection(UserScrollNotification notification){

      if(notification.direction==ScrollDirection.forward){
        _showFABLabel=true;
      }
      if(notification.direction==ScrollDirection.reverse){
        _showFABLabel = false;
      }
      emit(ChangeChatsScreenScrollDirection());

      return true;
  }

  bool _hideLabel = true;

  bool get hideLabel => _hideLabel;

  void onEnd(){
    _hideLabel = !_hideLabel;
    emit(ChangeChatsScreenScrollDirection());

  }


}
