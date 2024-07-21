

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_helper/models/controllers/user/user.dart';
import 'package:firebase_helper/shared/network/local/cache_helper.dart';
import 'package:firebase_helper/shared/network/remote/remote_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());
  static UserCubit get(context) =>BlocProvider.of(context);


   UserModel ? _user = null;

  UserModel get user => _user!;

  setUser(UserModel oldUser){
    _user = oldUser;
  }

  List<UserModel> _users=[];

  List<UserModel> get users => _users;

  Future <void > getAllUsers()async{
    _users=[];
    emit(GetUsersDataLoadingState());
      await FirebaseFirestore.instance.collection('users').get().then((value){
        try{
          for (var element in value.docs) {
            UserModel newUser = UserModel.fromMap(element.data());
            if(newUser.uId !=_user?.uId){
              _users.add(newUser);
            }

          }
          emit(GetUsersDataSuccessState());

        }catch(e){
          emit(GetUsersDataFailState());
        }
      });


  }


  initProfilePage({required String uId,required BuildContext context }  )async{
    await getUser(uId: uId );
    if(_user !=null){
      if(context.mounted){
        await cacheUserImage(context: context);
      }

      emit(GetUserDataSuccessState());
    }else {
      emit(GetUserDataFailState());
    }
  }
  Future<UserModel?> getUser({required String uId})async {
    emit(GetUserDataLoadingState());
       return await FirebaseFirestore.instance.collection('users')
           .doc(uId)
           .get(const GetOptions(source: Source.serverAndCache)).then((value){
         try{
             return _user = UserModel.fromMap(value.data()!);
         }catch(e){
           emit(GetUserDataFailState());
           return null;
         }

       }).onError((error, stackTrace) {
         emit(GetUserDataFailState());
         return null;
       });
  }


  Future<void>userSignOut()async{
    emit(UserSignOutLoadingState());
    try{
      await CacheHelper.sharedPreferences.clear();
      await FirebaseAuth.instance.signOut();
      emit(UserSignOutSuccessState());

    }catch(e){
      emit(UserSignOutFailState());
    }
  }


  updateUserProfile({
    required String name,
    required String phone,
    required String bio,
    required String date
}){
    emit(UpdateUserDataLoadingState());
    UserModel model =_user!.copyWith(
      name: name,
      phoneNumber: phone,
      bio: bio,
      dateOfBirth: date
    );
    String uId=CacheHelper.getData(key: "uId");
    FirebaseFirestore.instance.collection("users").doc(uId).set(model.toMap()).then((value) {
      emit(UpdateUserDataSuccessState());
    }).catchError((e){
      emit(UpdateUserDataFailState());
    });

  }


  updateUserProfileImage({
    required String image,

}){
    emit(UpdateUserImageLoadingState());
    UserModel model =_user!.copyWith(
      image: image
    );
    String uId=CacheHelper.getData(key: "uId");
    FirebaseFirestore.instance.collection("users").doc(uId).set(model.toMap()).then((value) {
      emit(UpdateUserImageSuccessState());
    }).catchError((e){
      emit(UpdateUserImageFailState());
    });

  }
  Future<bool>cacheUserImage({required BuildContext context})async{

    bool getImageSuccess = true;
    CachedNetworkImageProvider image = CachedNetworkImageProvider(_user!.image);
    await precacheImage(
      image,
      context ,
      onError: (e,stackTrace){
        getImageSuccess = false;
        },
    ).then((value) {
      if(getImageSuccess){
        cacheDefaultImages(context: context);
      }
    });
    return getImageSuccess;

  }

  cacheDefaultImages({required BuildContext context})async{
    for (var element in RemoteImages.allImages) {
      CachedNetworkImageProvider image = CachedNetworkImageProvider(element);
      precacheImage(
      image,
      context ,
      onError: (e,stackTrace){
      },
      ).then((value) {
      });

    }


  }
}
