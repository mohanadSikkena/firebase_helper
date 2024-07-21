
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_helper/models/controllers/chats/chat_cubit.dart';
import 'package:firebase_helper/modules/authentication/forget_password.dart';
import 'package:firebase_helper/modules/authentication/signup.dart';
import 'package:firebase_helper/modules/bottomNavigationBar/bottom_navigation_bar.dart';
import 'package:firebase_helper/modules/chat/chat_details.dart';
import 'package:firebase_helper/modules/home/home_page.dart';
import 'package:firebase_helper/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../modules/authentication/email_activation.dart';
import '../../modules/authentication/login.dart';
import '../../modules/profile/profile_page.dart';
import '../observers/go_router_observer.dart';

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
        _chatDetailsRoute
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
  static final _home=GoRoute(
      path: '/',
      name: "home",
      builder:(context,state){
        return const HomePage();
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