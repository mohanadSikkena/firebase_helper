


import 'dart:io';

import 'package:firebase_helper/core/cache/cache_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoRepository{
  static final ImagePicker _picker = ImagePicker();



  static Future<String?> getVideoThumbnail({required String videoPath})async{
    String ? isAlreadyCached = await CacheHelper.getData(key: videoPath);
    // print(isAlreadyCached);
    // print(videoPath);
    // // if(isAlreadyCached!=null){
    //   return isAlreadyCached;
    // }
    print(videoPath);
    String? thumbnailOfVideo=await VideoThumbnail.thumbnailFile(video:videoPath ,thumbnailPath:"${(await getTemporaryDirectory()).path}/${const Uuid().v4()}");
    if(thumbnailOfVideo!=null){
      await CacheHelper.putData(key: videoPath, value:thumbnailOfVideo);
    }
    print(thumbnailOfVideo);
    return thumbnailOfVideo;
  }

  static Future<XFile?> pickVideo()async{
    XFile ? video = await _picker.pickVideo(source: ImageSource.gallery);
    return video;
  }
  static Future getVideoAsFile()async{
    XFile ?pickedVideo = await pickVideo();
    if(pickedVideo ==null){
      return null;
    }
    File videoAsFile= File(pickedVideo.path);
    return videoAsFile;
  }

  static bool isFileVideo(){
    return true;
  }
  static Future<File?> compressVideo({required File video})async{
    MediaInfo ?compressedVideo =await VideoCompress.compressVideo(video.path , quality:VideoQuality.LowQuality);
    if(compressedVideo==null){
      return null;
    }
    return compressedVideo.file;
  }
  static Future <String>uploadVideoToFirebase({required File video , required String distension})async{
    String url = "";
    Reference reference = FirebaseStorage.instance.ref();
    UploadTask uploadTask = reference.child("$distension/").putFile(video);
    uploadTask.snapshotEvents.listen((event)async {
      if(TaskState.success== event.state){
      }
    });
    await uploadTask.whenComplete(() async{
      url = await uploadTask.snapshot.ref.getDownloadURL();
    });

    return url;

  }

  static Future<(bool,String)> compressAndUploadVideoToFirebase({required File video , required String distension})async{
    late String url;
    File ? compressedVideo =await compressVideo(video: video);
    if(compressedVideo!=null){
      url= await uploadVideoToFirebase(video: compressedVideo, distension: distension);
    }else{
      url= await uploadVideoToFirebase(video: video, distension: distension);
    }
    return (true,url);
  }

}