import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_helper/models/controllers/app/app_cubit.dart';
import 'package:firebase_helper/models/router/router.dart';
import 'package:firebase_helper/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';
import 'models/observers/bloc_observer.dart';


void main() async {
  Stopwatch stopwatch =  Stopwatch()
    ..start();

  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ), CacheHelper.init()
  ]);

  Bloc.observer = MyBlocObserver();
  log('app executed in ${stopwatch.elapsed}');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late final AppLinks _appLinks;
  StreamSubscription<String>?_linkSubscription;



  _initDeepLinks(){
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.stringLinkStream.listen((url) {
      CustomRouter.router.push(url) ;
    });
  }

  @override
  void initState() {
    _initDeepLinks();
    super.initState();
  }
  @override
  void dispose() {
    _linkSubscription!.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      // Set your design reference size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            // BlocProvider(
            //     lazy: false,
            //     create: (context)=>UserCubit()),
            BlocProvider(
                lazy: false,
                create: (context)=>AppCubit()),

          ],
          child: MaterialApp.router(
            routerConfig: CustomRouter.router,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                fontFamily: "Poppins"
            ),
            title: 'My App',
          ),
        );
      },
    );
  }
}

