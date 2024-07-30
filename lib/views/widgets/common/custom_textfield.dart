
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../theme/colors/colors.dart';
import '../../../theme/styles/textfield_style.dart';
import '../../../utils/helpers/validation/validator.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final bool isPassword;
  final Widget ?suffixIcon;
  final Validator?validator;
  final bool enabled;
  final TextEditingController ? controller ;
  final bool expands;
  final int ? maxLines ;

   const CustomTextField({super.key , required this.text , this.isPassword = false ,this.validator , this.controller , this.suffixIcon ,this.enabled=true , this.expands = false , this.maxLines = 1 }  );

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPassword= true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(

      enabled:widget.enabled,
      controller : widget.controller,
      validator:(ss){
        if(widget.validator==null){
          return null;
        }
        return widget.validator!.validation(ss!) ? null : widget.validator!.errorMessage();
      },
      // minLines: ,
      maxLines: widget.maxLines,
      obscureText: showPassword && widget.isPassword,
      decoration: TextFieldStyle.inputDecoration.copyWith(
          hintText: widget.text,
          suffixIcon:widget.suffixIcon ?? (widget.isPassword ? IconButton(onPressed: (){
            setState(() {
              showPassword =!showPassword;
            });
          }, icon: Icon(showPassword?Icons.visibility:Icons.visibility_off)):null)
      ),
      style:TextStyle(color: ConstColors.secondaryColor,fontSize: 15.sp,fontWeight: FontWeight.w400),

    );
  }
}
