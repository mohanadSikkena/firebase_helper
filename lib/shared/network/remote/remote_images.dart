

import 'dart:math';

class RemoteImages{
  static const String _url="https://firebasestorage.googleapis.com/v0/b/fir-helper-c5a43.appspot.com/o/images%2Fprofile_image_";

  static final List<String> _maleImages=[
    "${_url}1.png?alt=media&token=ee75e915-81ef-4ffa-ba2c-09ecc314d2f7",
    "${_url}3.png?alt=media&token=2a3acea6-5245-494d-bcb6-10e2e20b4273",
    "${_url}4.png?alt=media&token=357de854-8620-4c8e-825e-c3fb23f48046",
  ];
  static final List<String> _femaleImages=[
    "${_url}2.png?alt=media&token=be76323a-13b3-4885-9352-147302a7b7b3",
    "${_url}5.png?alt=media&token=52305248-d00a-4eda-8be6-775c361e310f",
    "${_url}6.png?alt=media&token=eab4044f-6f93-4163-aced-ed2c57b8170a"
  ];
  static final List<String> _allImages=[
    "${_url}1.png?alt=media&token=ee75e915-81ef-4ffa-ba2c-09ecc314d2f7",
    "${_url}2.png?alt=media&token=be76323a-13b3-4885-9352-147302a7b7b3",
    "${_url}3.png?alt=media&token=2a3acea6-5245-494d-bcb6-10e2e20b4273",
    "${_url}4.png?alt=media&token=357de854-8620-4c8e-825e-c3fb23f48046",
    "${_url}5.png?alt=media&token=52305248-d00a-4eda-8be6-775c361e310f",
    "${_url}6.png?alt=media&token=eab4044f-6f93-4163-aced-ed2c57b8170a"
  ];


  static List<String> get allImages => _allImages;

  static String getRandomImage({required int gender}){
    int image = Random().nextInt(3);
    return gender ==1 ? _maleImages[image]:_femaleImages[image];
  }

  static int ? getImageIndexIfAvailable({required String image}){
    if(_allImages.contains(image)){
      return _allImages.indexOf(image);
    }

    return null;
  }
}