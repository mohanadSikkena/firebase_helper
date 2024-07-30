
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_helper/core/cache/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../controllers/user/user_cubit.dart';
import '../core/observers/go_router_observer/go_router_observer.dart';
import '../views/screens/authentication/email_activation/email_activation.dart';
import '../views/screens/authentication/forget_password/forget_password.dart';
import '../views/screens/authentication/login/login.dart';
import '../views/screens/authentication/signup/signup.dart';
import '../views/screens/bottomNavigationBar/bottom_navigation_bar.dart';
import '../views/screens/chat_details/chat_details.dart';
import '../views/screens/all_chats/current_chats.dart';
import '../views/screens/profile/profile_page.dart';
import '../views/screens/users/all_users_screen.dart';
import '../views/widgets/screen_widgets/profile/profile_picture/update_profile_image.dart';


class CustomRouter{
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static bool _skipEmailVer=false;
  static final _router = GoRouter(
    observers: [MyGoRouterObserver()],
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    redirect: (context , state){
      if(FirebaseAuth.instance.currentUser!=null && CacheHelper.getData(key: "uId") !=null){
        if(!FirebaseAuth.instance.currentUser!.emailVerified){

          if(state.extra=="force-skip"||_skipEmailVer){
            _skipEmailVer = true;
            return null;
          }
          return "/email-verification";
        }
        return null;
      }
      if(state.fullPath == "/signup"||state.fullPath=="/login/forget-password"){
        return null;
      }
      return "/login";
    },
      routes: [
        _navigationBarRoute,
        _loginRoute,
        _signUpRoute,
        _emailVerification,
        _chatDetailsRoute,
        _allUsers,
        _updateProfileImage
      ],

  );



  static final _navigationBarRoute = StatefulShellRoute.indexedStack(

      builder: (context, state, navigationShell) {
        return HomeBottomNavigationBar(
            widget: navigationShell);
      },

      branches: [
        StatefulShellBranch(routes: [_home]),
        StatefulShellBranch(routes: [_dummyRoute,_profileRoute]),
      ]);


  static final _chatDetailsRoute=GoRoute(
      path: '/chat/:chatId',
      name: "chatDetails",
      builder:(context,state){
        return  ChatDetails(chatId: state.pathParameters["chatId"]!,);
      }
  );
  static final _allUsers=GoRoute(
      path: '/all-users',
      name: "allUsers",
      builder:(context,state){
        return  const AllUsersScreen();
      }
  );

  static final _updateProfileImage=GoRoute(
      path: '/update-profile-image',
      name: "updateProfileImage",

      builder:(context,state){
        Map<String,dynamic> extra =state.extra as Map<String,dynamic>;
        return BlocProvider.value(value: extra['cubit'] as UserCubit ,child: ShowImageBeforeUpload(image: extra['image'] as File,), );



      }
  );



  static final _home=GoRoute(
      path: '/',
      name: "home",
      builder:(context,state){
        return const AllChatsScreen();
      }
  );
      static final _dummyRoute = GoRoute(
    name: "dummyRoute",
    path: "/dummy",
    builder: (context, state) =>const Placeholder(),
  );
      static final _profileRoute=GoRoute(
      path: '/profile/:id',
      name: "profile",
      builder:(context,state){
        return ProfileScreen(userUid: state.pathParameters["id"]!,);
      }
  );
  static final _emailVerification=GoRoute(
      path: '/email-verification',
      builder:(context,GoRouterState state){
        return const EmailActivationScreen();
      }
  );



  static final _loginRoute=GoRoute(
      path: '/login',
      routes: [
        _forgetPassword
      ],
      builder:(context,GoRouterState state){
        return const LoginScreen();
      }
  );
  static final _signUpRoute=GoRoute(
      path: '/signup',
      builder:(context,GoRouterState state){
        return SignUpScreen();
      }
  );
  static final _forgetPassword=GoRoute(
      path: 'forget-password',
      builder:(context,GoRouterState state){
        return const ForgotPasswordScreen();
      }
  );

  static get router => _router;
}