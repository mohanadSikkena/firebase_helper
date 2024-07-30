

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageRepository{
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?>pickImage()async{
    XFile ? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }
  static Future<File?>getImageAsFile()async{
    XFile ?pickedImage = await pickImage();
    if(pickedImage ==null){
      return null;
    }
    File imageAsFile= File(pickedImage.path);
    return imageAsFile;
  }
  static bool  _isFileImage({required String imagePath}){
    int lastIndex = imagePath.lastIndexOf(RegExp(r'(.png|.jpg|jpeg)$'));
    if(lastIndex<0){
      return false;
    }
    return true;
  }
  static bool ? _isImagePng({required File img}){
    String imagePath = img.absolute.path;

    if(!_isFileImage(imagePath: imagePath)){
      return null;
    }

    int lastIndex = imagePath.lastIndexOf(RegExp(r'(.png)$'));
    if(lastIndex >0){
      return true;
    }
    return false;
  }
  static compressImage({required File image})async{
    final Directory tempDirectory = await getTemporaryDirectory();
    _isImagePng(img: image);
    bool ?isImagePng= _isImagePng(img: image);
    if(isImagePng==null){

      return;
    }
    XFile? compressedImage =await FlutterImageCompress.compressAndGetFile(
        image.path,'${tempDirectory.path}/${image.path.split('/').last}' ,
        format: isImagePng ? CompressFormat.png:CompressFormat.jpeg,

        quality: 30
    );
    File compressedFileImage= File(compressedImage!.path);
    return compressedFileImage;
  }
  static Future <String>uploadImageToFirebase({required File image ,required String distension})async{
    String url = "";
    Reference reference = FirebaseStorage.instance.ref();
    UploadTask uploadTask = reference.child("$distension/").putFile(image);

    uploadTask.snapshotEvents.listen((event)async {
      if(TaskState.success== event.state){
      }
    });
    await uploadTask.whenComplete(() async{
      url = await uploadTask.snapshot.ref.getDownloadURL();
    });

    return url;
  }
  static Future<(bool,String)> compressAndUploadImageToFirebase({required File image , required String distension})async{
    File ? compressedImage =await ImageRepository.compressImage(image: image);
    if(compressedImage ==null){
      return (false,"");
    }
    String url = await uploadImageToFirebase(image: compressedImage, distension: distension);
    return (true,url);
  }

}