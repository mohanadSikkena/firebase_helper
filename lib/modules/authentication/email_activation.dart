import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_helper/models/controllers/user/user_cubit.dart';
import 'package:firebase_helper/modules/authentication/login.dart';
import 'package:firebase_helper/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmailActivationScreen extends StatelessWidget {
  const EmailActivationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            UserCubit.get(context).userSignOut().then((value) {
              context.go('/login');

              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const LoginScreen()));
            });
          },
          icon:const Icon(Icons.exit_to_app,color: Colors.red,),
        ),
        centerTitle: true,
        title: const Text('Activate Your Email'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:16.0),
            child: InkWell(
              onTap: (){
              context.go("/",extra: "force-skip");
              },
              child: const Text("Skip" , style: TextStyle(fontSize: 16),),
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email, size: 80, color: ConstColors.primaryColor),
              const SizedBox(height: 20),
              const Text(
                'Check your inbox!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
             const  SizedBox(height: 10),
              const Text(
                'We have sent an email to your registered email address. Please click the activation link to complete the registration process.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
             const  SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {

                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                },
                child:const  Text('Resend Activation Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}