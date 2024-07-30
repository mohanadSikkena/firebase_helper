
import 'package:firebase_helper/repositories/user/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../controllers/login/login_cubit.dart';
import '../../../../theme/colors/colors.dart';
import '../../../../utils/helpers/errors/error.dart';
import '../../../../utils/helpers/validation/validator.dart';
import '../../../widgets/common/custom_dialog.dart';
import '../../../widgets/common/custom_textfield.dart';
import '../../../widgets/common/default_button.dart';
import '../../../widgets/screen_widgets/authentication/introduction.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state)async {
          if(state is LoginFailState){
            context.pop();
            if(state.error ==CustomErrors.emailOrPasswordError){
              LoginCubit.get(context).loginValidator.loginFailed=true;
              _formKey.currentState!.validate();
            }else{
              ErrorHelper.firebaseAuthErrorMessage(error: state.error, context: context);
            }

          }
          if(state is LoginLoadingState){
            showStyledPopLoading(context);
          }
          if(state is LoginSuccessState){
             UserRepository.setFcmForCurrentUser();
            context.pop();
            context.go("/");
          }
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Scaffold(

            appBar: AppBar(),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.0.w),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const IntroductionWidget(),
                    Padding(
                      padding: EdgeInsets.only(top: 53.h),
                      child: CustomTextField(
                        controller: cubit.emailController,
                        text: "Enter your Email",
                        validator: EmailValidation(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 38.h),
                      child: CustomTextField(text: "Password",
                        isPassword: true,
                        controller: cubit.passwordController,
                        validator: cubit.loginValidator,),
                    ),
                    Padding(padding: EdgeInsets.only(left: 198.w, top: 17),
                      child: InkWell(
                          onTap: () {
                           context.go('/login/forget-password');
                          },
                          child: Text("Forgot password ?",
                            style: TextStyle(color: ConstColors.lightGrey,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400),)),
                    ),
                    Padding(padding: EdgeInsets.only(top: 46.h),
                      child: DefaultButton(text: "Login", onPressed: () {
                        cubit.loginValidator.loginFailed = false;
                        if (_formKey.currentState!.validate()) {
                          cubit.login();
                        }
                      })
                      ,),


                  ],
                ),
              ),
            ),

          );
        },
      ),
    );
  }
}
