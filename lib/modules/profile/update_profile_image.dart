import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_helper/models/controllers/user/user_cubit.dart';
import 'package:firebase_helper/shared/styles/text_styles.dart';
import 'package:firebase_helper/shared/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/network/remote/remote_images.dart';
import '../../shared/styles/colors.dart';

class UpdateProfileImage extends StatefulWidget {
  const UpdateProfileImage({
    super.key,
  });

  @override
  State<UpdateProfileImage> createState() => _UpdateProfileImageState();
}

class _UpdateProfileImageState extends State<UpdateProfileImage> {
  int ? selectedPhoto;

  @override
  void initState() {
  selectedPhoto =  RemoteImages.getImageIndexIfAvailable(image: UserCubit.get(context).user.image);
  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1.sh*0.85,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: ListView(
          children: [
             Padding(
              padding: EdgeInsets.symmetric(vertical:16.0.h ,),
              child: Center(child: Text("Select Your Avatar" , style:  ConstTextStyles.mainStyle,)),
            ),

            GridView.builder(
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,) ,
                itemCount: RemoteImages.allImages.length,
                itemBuilder: (context , i)=>Container(

                  margin: const EdgeInsets.symmetric(vertical:16),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color:selectedPhoto==i? ConstColors.primaryColor:ConstColors.lightGrey,
                      shape: BoxShape.circle
                  ),

                  child: CircleAvatar(
                    radius: 80.r,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: (){
                        setState(() {
                          selectedPhoto=i;
                        });
                      },
                      child: CachedNetworkImage(imageUrl: RemoteImages.allImages[i],),
                    ),
                  ),
                )),

            Padding(
              padding: EdgeInsets.only(top: 46.h , bottom: 20.h),
              child: Row(
                children: [
                  Expanded(
                    child: DefaultButton(
                        color: ConstColors.primaryColor.withOpacity(0.3),
                        text: "Cancel",
                        onPressed: () {
                          Navigator.pop(context);
                        }),

                  ),
                  SizedBox(width: 26.w,),
                  Expanded(
                    child: DefaultButton(
                        text: "Save",
                        onPressed: () {
                          if(selectedPhoto!=null){
                            UserCubit.get(context).updateUserProfileImage(image: RemoteImages.allImages[selectedPhoto!]);
                          }
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
