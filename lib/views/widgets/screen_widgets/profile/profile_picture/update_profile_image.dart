import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_helper/repositories/images/image_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../controllers/user/user_cubit.dart';
import '../../../../../core/cache/cache_helper.dart';
import '../../../../../theme/colors/colors.dart';
import '../../../../../theme/text_styles/text_styles.dart';
import '../../../../../utils/helpers/remote_images/remote_images.dart';
import '../../../common/default_button.dart';

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
              padding: EdgeInsets.symmetric(vertical:16.0.h ,),
              child: Column(
                children: [
                  Text(
                    "Or select an image from your gallery:",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 16.h),
                  Row(children: [
                    Expanded(
                      child: DefaultButton(
                        text: "Gallery",
                        onPressed: () async {
                          File ? imageFile =  await ImageRepository.getImageAsFile();
                          if(imageFile!=null){

                            if(!context.mounted){
                              return;
                            }
                          context.pushNamed('updateProfileImage' ,
                              extra: {
                            "image":imageFile,
                                "cubit":UserCubit.get(context)
                          }
                          );
                          }
                        }
                      ),
                    ),
                  ],
                  ),])),
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

class ShowImageBeforeUpload extends StatelessWidget {
  final File image;
  const ShowImageBeforeUpload({super.key , required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [InkWell(
          onTap: ()async{
            UserCubit.get(context).compressAndUploadImageToFirebase(image: image);
            context.goNamed("profile", pathParameters: {"id":CacheHelper.getData(key: "uId")});
            },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0.w),
            child: Text("Save"),
          ),
        )],
      ),
      body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30),
          foregroundDecoration:BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: ConstColors.primaryColor,
                  width: 4
              ),
          ) ,
          child: CircleAvatar(

            radius: 170.r,
              child: Image.file(image)
          ),
      )

    );
  }
}

