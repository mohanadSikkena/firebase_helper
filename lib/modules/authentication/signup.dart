
import 'package:firebase_helper/models/controllers/signup/signup_cubit.dart';
import 'package:firebase_helper/models/errors/error.dart';
import 'package:firebase_helper/models/validation/validator.dart';
import 'package:firebase_helper/shared/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../shared/styles/colors.dart';
import '../../shared/widgets/custom_textfield.dart';
import '../../shared/widgets/default_button.dart';
import 'introduction.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          signupScreenHandleStates(state, context);
        },
        builder: (context, state) {
          SignupCubit cubit = SignupCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.0.w),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const IntroductionWidget(
                      isLoginPage: false,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 52.h),
                      child: CustomTextField(
                        text: "Enter Email",
                        validator: cubit.emailValidator,
                        controller: cubit.emailController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 18.h),
                      child: CustomTextField(
                        text: "Create User name",
                        validator: UserNameValidation(),
                        controller: cubit.usernameController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 18.h),
                      child: CustomTextField(
                        text: "Contact number",
                        validator: PhoneValidation(),
                        controller: cubit.numberController,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffF0EFFF),
                        borderRadius: BorderRadius.circular(8.r)
                      ),
                      margin: EdgeInsets.only(top: 18.h),
                      padding: EdgeInsets.only(left: 12.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Gender : ",style:TextStyle(color: ConstColors.secondaryColor,fontSize: 15.sp,fontWeight: FontWeight.w400)),
                          addRadioButton(context: context, buttonValue: 1, text: "Male"),
                          addRadioButton(context: context, buttonValue: 2, text: "Female"),
                        ],
                      )
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 18.h),
                      child: InkWell(
                        onTap: (){
                          showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: DateTime.now(),
                              lastDate: DateTime.now()).then((value) {
                            DateFormat outputFormat = DateFormat("dd/MM/yyyy");
                                cubit.dateOfBirthController.text=outputFormat.format(value!).toString();
                          }).onError((error, stackTrace) {});
                        },
                        child: CustomTextField(
                          text: "Date Of Birth",
                          enabled: false,
                          suffixIcon: const Icon(Icons.date_range),
                          validator: DateValidator(),
                          controller: cubit.dateOfBirthController,
                        ),
                      ),
                    ),



                    Padding(
                      padding: EdgeInsets.only(top: 18.h),
                      child: CustomTextField(
                        text: "Password",
                        isPassword: true,
                        validator: PasswordValidation(),
                        controller: cubit.passwordController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 18.h),
                      child: CustomTextField(
                        text: "Confrim Password",
                        isPassword: true,
                        validator:
                            ConfirmPasswordValidation(cubit.passwordController),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 46.h , bottom: 20.h),
                      child: DefaultButton(
                          text: "Register",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              cubit.signup();
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget addRadioButton({required BuildContext context ,required int buttonValue ,required String text })=>Row(
    children: [
      Text(text),
      Radio(value: buttonValue, groupValue: SignupCubit.get(context).selectedGenderValue, onChanged: (value){
        SignupCubit.get(context).changeGenderValue(value!);
      }),
    ],
  );

  void signupScreenHandleStates(SignupState state, BuildContext context) {
    if (state is CreateUserSuccessState ||
        state is CreateUserFailState ||
        state is SignupFailState) {
      context.pop();
    }
    if (state is SignupLoadingState) {
      showStyledPopLoading(context);
    }

    if (state is CreateUserFailState) {
      ErrorHelper.firebaseAuthErrorMessage(
          error: state.error, context: context);
    }

    if (state is SignupFailState) {
      if (state.error == CustomErrors.userAlreadyExistsError) {
        SignupCubit.get(context).emailValidator.emailExist = true;
        _formKey.currentState!.validate();
        SignupCubit.get(context).emailValidator.emailExist = false;
      } else {
        ErrorHelper.firebaseAuthErrorMessage(
            error: state.error, context: context);
      }
    }

    if(state is CreateUserSuccessState){
      context.go("/");
    }
  }
}
