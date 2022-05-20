
class PostModel {
   String name="";
    String uId="";
   String image="";
   String date="";
   String text="";
   String postImage="";
   bool isLiked=false;

  PostModel( 
   {
    required this.name,
    required this.uId,
    required this.image,
    required this.date,
    required this.postImage,
    required this.text
  });
  PostModel.ec();
  PostModel.fromJasn(Map<String, dynamic> jasn) {
    name = jasn['name'];
    uId = jasn['uId'];
    image = jasn['image'];
    date = jasn['date'];
    postImage = jasn['postImage'];
    text = jasn['text'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'text': text,
      'date': date,
      'postImage': postImage,
    };
  }
}

class CommentModel{
  late String text;
  late String name;
  late String image;
  late String uId;
  late String date;
  CommentModel({
    required this.name,
    required this.uId,
    required this.image,
    required this.date,
    required this.text
  });

  CommentModel.fromJasn(Map<String, dynamic> jasn) {
    name = jasn['name'];
    uId = jasn['uId'];
    image = jasn['image'];
    date = jasn['date'];
    text = jasn['text'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'text': text,
      'date': date,
    };
  }
}
