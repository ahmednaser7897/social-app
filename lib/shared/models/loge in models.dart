// ignore_for_file: file_names

class UserModel{
   String name="";
   String email="";
   String phone="";
   String uId="";
   String image="";
   String cover="";
   String bio="";
   bool ?state;
   bool ?isEmailVerified;
  UserModel.ec();
  UserModel({required this.email,required this.name,required this.phone,required this.uId,required this.image,required this.isEmailVerified,required this.bio,required this.cover,required this.state});
  UserModel.fromJasn(Map<String,dynamic> jasn){
    email=jasn['email'];
    name=jasn['name'];
    phone=jasn['phone'];
    uId=jasn['uId'];
    image=jasn['image'];
    cover=jasn['cover'];
    bio=jasn['bio'];
    isEmailVerified=jasn['isEmailVerified'];
    state=jasn['state'];
  }
  Map<String,dynamic> toMap(){
    return{
      'name':name,
      'email':email,
      'phone':phone,
      'uId':uId,
      'image':image,
      'cover':cover,
      'bio':bio,
      'isEmailVerified':isEmailVerified,
      'state':state
    };
  }
}