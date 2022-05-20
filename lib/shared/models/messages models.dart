// ignore_for_file: file_names

class MessageModel {
   String sId="";
   String rId="";
   String date="";
   String text="";
   String image="";
   String file="";
  MessageModel.ec();
  MessageModel({required this.file,
    required this.sId,
    required this.rId,
    required this.date,
    required this.text,
    required this.image,
  });

  MessageModel.fromJasn(Map<String, dynamic> jasn) {
    rId = jasn['rId'];
    sId = jasn['sId'];
    date = jasn['date'];
    text = jasn['text'];
    image=jasn['image'];
    file=jasn['file'];
  }

  Map<String, dynamic> toMap() {
    return {
      'rId': rId,
      'sId': sId,
      'text': text,
      'date': date,
      'image':image,
      'file':file
    };
  }
}
class ChatModel{
  late String uid;
  late String image;
  late String name;
  ChatModel({required this.image,required this.name, required this.uid});

   ChatModel.fromJasn(Map<String, dynamic> jasn) {
    uid = jasn['uid'];
    name = jasn['name'];
    image=jasn['image'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'image':image
    };
  }

}