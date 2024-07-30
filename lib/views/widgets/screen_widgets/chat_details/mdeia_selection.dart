import 'dart:io';

import 'package:firebase_helper/theme/text_styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../repositories/chat/chat_repository.dart';
import '../../../../repositories/images/image_repository.dart';
import '../../../../repositories/vidos/video_repository.dart';

void showMediaPickerDialog(BuildContext context ,String chatId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Choose Media'),
        content: SizedBox(
          height: 120.h,
          width: 1.sw,
          child: GridView.count(crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              ElevatedButton(
                onPressed: () async {
                  context.pop();
                  File ? imageFile =  await ImageRepository.getImageAsFile();
                            if(imageFile !=null){
                              ChatRepository.sendImageMessage(receiverId: chatId, image: imageFile);
                            }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Example background color
                ),
                child: const Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, color: Colors.white),
                    SizedBox(height: 5),
                    Text('Image', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              ElevatedButton(

                onPressed: () async {
                  context.pop();
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Example background color
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.videocam, color: Colors.white),
                    SizedBox(height: 5),
                    Text('Soon', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}