import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../models/controllers/user/user_cubit.dart';
import '../../models/validation/validator.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/text_styles.dart';
import '../../shared/widgets/custom_textfield.dart';
import '../../shared/widgets/default_button.dart';

class EditProfileBottomSheet extends StatefulWidget {
  const EditProfileBottomSheet({super.key});

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  final TextEditingController numberController = TextEditingController();

  final TextEditingController dateOfBirthController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();



  @override
  void initState() {
    // TODO: implement initState
    UserCubit cubit = UserCubit.get(context);
    numberController.text = cubit.user.phoneNumber;
    dateOfBirthController.text=cubit.user.dateOfBirth;
    usernameController.text=cubit.user.name;
    bioController.text=cubit.user.bio;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    UserCubit cubit = UserCubit.get(context);
    return SizedBox(
      height: 1.sh*0.85,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.0.w),
          child: ListView(
            children: [
              SizedBox(height: 30.h,),

              Center(
                child: Text("Edit Profile" , style: ConstTextStyles.mainStyle.copyWith(fontSize: 18.sp),),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: CustomTextField(
                    text: "Name",
                    validator: UserNameValidation(),
                    controller: usernameController
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: CustomTextField(
                    text: "Contact number",
                    validator: PhoneValidation(),
                    controller: numberController
                ),
              ),Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: CustomTextField(
                    enabled: false,
                    text: "Date Of Birth",
                    validator: DateValidator(),
                    controller: dateOfBirthController
                ),
              ),Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: CustomTextField(
                    text: "Enter Your Bio",
                    validator: RequiredField(),
                    controller:bioController
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 46.h , bottom: 20.h),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultButton(
                          color: ConstColors.primaryColor.withOpacity(0.3),
                          text: "Cancel",
                          onPressed: () {
                            context.pop();
                          }),

                    ),
                    SizedBox(width: 26.w,),
                    Expanded(
                      child: DefaultButton(
                          text: "Save",
                          onPressed: () {
                            if (_formKey.currentState!.validate() ){
                              cubit.updateUserProfile(
                                  name:usernameController.text ,
                                  phone: numberController.text,
                                  bio: bioController.text,
                                  date: dateOfBirthController.text);
                            }

                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
