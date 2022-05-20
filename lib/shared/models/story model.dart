// ignore_for_file: file_names

import 'package:social_app/shared/models/loge%20in%20models.dart';

enum MediaType {
  image,
  video,
}
class UserStorys{
  late UserModel user;
  List<StoryModel> storys=[];
  UserStorys({required this.user,required this.storys});
}
class StoryModel {
  late String image;
  late String video;
  late String uId;
  late String text;
  late String storyImage;
  late String name;
  late String date;
   StoryModel({
    required this.uId,
    required this.image,
    required this.text,
    required this.storyImage,
    required this.name,
    required this.video,
    required this.date
  });
  StoryModel.fromJasn(Map<String, dynamic> jasn) {
    name = jasn['name'];
    uId = jasn['uId'];
    image = jasn['image'];
    video = jasn['video'];
    date = jasn['date'];
    storyImage = jasn['storyImage'];
    text = jasn['text'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'text': text,
      'date': date,
      'storyImage': storyImage,
      'video':video,
    };
  }
}
