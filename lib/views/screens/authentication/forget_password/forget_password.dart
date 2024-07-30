import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_helper/views/widgets/common/custom_dialog.dart';
import 'package:firebase_helper/views/widgets/common/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/helpers/errors/error.dart';
import '../../../../utils/helpers/validation/validator.dart';
import '../../../widgets/common/default_button.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword(BuildContext context)async {
    if (_formKey.currentState!.validate()) {
      try{
        showStyledPopLoading(context);
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text).then((value){
          context.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset email sent!')),
          );
        });
      }on FirebaseAuthException catch(e){
        if(context.mounted){
          context.pop();
          CustomErrors error = ErrorHelper.firebaseAuthErrors(error: e.code);
          ErrorHelper.firebaseAuthErrorMessage(error: error, context: context);
        }



      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Forgot Password'),
      ),
      body: Center(
        child: Padding(padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               const Text(

                  "Forgot your password? Don't worry, just enter your email below and we'll send you a link to reset it.",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 40.h),
                CustomTextField(
                  controller: _emailController,
                  text: "Enter your registered email",

                  validator: EmailValidation()

                ),
                const SizedBox(height: 20),
                DefaultButton(text: "Reset Password", onPressed: (){
                  _resetPassword(context);
                })
              ],),
          ),
        ),
      ),
    );
  }
}