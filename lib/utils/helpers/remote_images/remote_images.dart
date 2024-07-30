

import 'dart:math';

class RemoteImages{
  static const String _url="https://firebasestorage.googleapis.com/v0/b/fir-helper-c5a43.appspot.com/o/images%2Fprofile_image_";


  static final List<String> _maleImages=[
    "${_url}1.png?alt=media&token=f9cc1a7e-2773-4159-b97c-6f89149dc796",
    "${_url}3.png?alt=media&token=f3f4449d-0fdb-4434-bfc1-2cbf1763391f",
    "${_url}4.png?alt=media&token=d590ef95-cb7e-4907-a275-855d3b68c302",
  ];
  static final List<String> _femaleImages=[
    "${_url}2.png?alt=media&token=720494b3-50ef-4a03-a0f3-8b15f7760a21",
    "${_url}5.png?alt=media&token=c460fb17-b967-4088-ad46-7838a45a10b8",
    "${_url}6.png?alt=media&token=88f7b1f6-950f-4d56-b9ba-067aa2d20172"
  ];
  static final List<String> _allImages=[
    "${_url}1.png?alt=media&token=f9cc1a7e-2773-4159-b97c-6f89149dc796",
    "${_url}2.png?alt=media&token=720494b3-50ef-4a03-a0f3-8b15f7760a21",
    "${_url}3.png?alt=media&token=f3f4449d-0fdb-4434-bfc1-2cbf1763391f",
    "${_url}4.png?alt=media&token=d590ef95-cb7e-4907-a275-855d3b68c302",
    "${_url}5.png?alt=media&token=c460fb17-b967-4088-ad46-7838a45a10b8",
    "${_url}6.png?alt=media&token=88f7b1f6-950f-4d56-b9ba-067aa2d20172"
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