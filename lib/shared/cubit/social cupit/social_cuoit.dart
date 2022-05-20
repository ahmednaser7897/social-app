// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:io';
//import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:social_app/screens/chat%20screen/chats.dart';
import 'package:social_app/screens/social%20screens/feeds.dart';
import 'package:social_app/screens/social%20screens/settings.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/chat%20cuipt/chat_cuipt.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_states.dart';
import 'package:social_app/shared/models/loge%20in%20models.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/shared/models/post_model.dart';
//import 'package:flutter_sound/flutter_sound.dart';
import 'dart:async';
//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_app/shared/models/story%20model.dart';
import 'package:social_app/shared/shared_preferences/shared_preferences.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class SocialCupit extends Cubit<SocialState>{
  SocialCupit():super(IntiAppState());
  static SocialCupit get(context)=>BlocProvider.of(context);
  
  List<Widget> screens=[const FeedScreen(),const ChatScreen(),SettingScreen()];
  List titls=
  [
    ['Home','الاحداث'],
    ['Chats',"المحادثات"],
    //['Notifications',"الاشعارات"],
    ['Setting',"الاعدادات"]
  ];

  var moodl=(CachHelper.getData(key: "mood")==null)?true:CachHelper.getData(key: "mood");
  void changMood(value){
     moodl=value;
     CachHelper.setData(key: "mood", value: moodl).then((value) {emit(Mood());});
     print('l mood is $isEnglish');
  }

  var isEnglish=(CachHelper.getData(key:"lan")==null)?true:CachHelper.getData(key: "lan");
  void changLang(value){
     isEnglish=value;
     CachHelper.setData(key: "lan", value: isEnglish).then((value) {emit(ChangLange());});
     print('english is $isEnglish');
  }


  int indix =0;
  changBottomBarIndix(value,{context})async{
    indix=value;
    print("indix is $indix");
    if(indix==1) {
      ChatCupit.get(context).getChats();
    }
    if(indix==2){
      getUserData();
    }
    if(indix==0) {
      getAllStorys();
    }
    emit(ChangBottomBarIndix());
  }

//get users data
  UserModel userModel=UserModel.ec();
  getUserData(){
    emit(LodingGetUserData());
    FirebaseFirestore.instance.collection("users").doc(uId).get().then((value){
      userModel=UserModel.fromJasn(value.data()!);
      emit(ScGetUserData());
    }).catchError((onError){
      print("error feom getUserData ${onError.toString()} ");
      emit(ErrorGetUserData(onError.toString()));
    });
  }
  emptyUserData(){
    userModel=UserModel.ec();
    emit(EmptyUserData());
  }

  List<UserModel> users=[];
  getAllUser(){
    emit(LodingGetAllUserData());
    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      users=[];
       event.docs.forEach((element) {
        users.add(UserModel.fromJasn(element.data()));
        emit(ScGetAllUserData());
      });
      emit(ScGetAllUserData());
    });
  }
  
  Future<UserModel>getOnePerson(personid)async{
   UserModel user=UserModel.ec();
   await FirebaseFirestore.instance.collection("users").doc(personid).get().then((value){
     user=UserModel.fromJasn(value.data()!);
   });
   return user;
 }

//get posts data
  List<PostModel> posts=[];
  List<int> likesNum=[];
  List<int> commentsNum=[];
  List<String>postIds=[];
  getPosts()async{
    emit(LodingGetPostsData());
      FirebaseFirestore.instance.collection("posts").snapshots().listen((event) {
      posts=[];
      likesNum=[];
      commentsNum=[];
      postIds=[];
      int i=0;
      event.docs.forEach((element) async{
        await getOnePostLikesNumber(element.id).then((value1)async {
          await getOnePostCommentsNumber(element.id).then((value)async{
            await isliked(element.id).then((value2){
              //print(" comment number for post ${element.id} is ${value.docs.length}");
              commentsNum.add(value);
              //print("likes number for post ${element.id} is ${value1.docs.length}");
              likesNum.add(value1);
              PostModel temp=PostModel.fromJasn(element.data());
              temp.isLiked=(value2=="d")?true:false;
              posts.add(temp);
              postIds.add(element.id);
              i++;
              if(i==event.docs.length-1) {
                emit(ScGetPostsData());
              }
           });
          });
        });
      });
      emit(ScGetAllPostsData());
    });
  }
  Future<int> getOnePostLikesNumber(postId)async{
    emit(LodingGetLikesNumber());
    int n=0;
    await FirebaseFirestore.instance.collection("posts").doc(postId).collection("likes")
    .get().then((value) {
      n=value.docs.length;
      emit(ScGetLikesNumber());
    });
    return n;
  }
  Future<int> getOnePostCommentsNumber(postId)async{
    emit(LodingGetCommentsNumber());
    int n=0;
    await FirebaseFirestore.instance.collection("posts").doc(postId).collection("comment")
    .get().then((value) {
      n=value.docs.length;
      emit(ScGetCommentsNumber());
    });
    return n;
  }
  
  addPostToFav(postId){
    emit(LodingAddPostToFav());
    FirebaseFirestore.instance.collection("users").doc(uId).collection("favposts").doc(postId).set({}).then((value) {
      emit(ScAddPostToFav());
    }).catchError((onError){
       print("error from addPostToFav ${onError.toString()} ");
      emit(ErrorAddPostToFav());
    });
  }
  
  deletFromFav(postId){
    emit(LodingDeleteFromFavp());
    FirebaseFirestore.instance.collection("users").doc(uId).collection("favposts").doc(postId).delete().then((value) {
      emit(ScDeleteFromFavp());
    }).catchError((onError){
       print("error from deletFromFav ${onError.toString()} ");
      emit(ErrorDeleteFromFavp());
    });
  }
  Future<PostModel> getOnePostData(postId)async{
    PostModel post=PostModel.ec();
      await FirebaseFirestore.instance.collection("posts").doc(postId).get().then((value) {
       post=PostModel.fromJasn(value.data()!);
     });
     return post;
  }
 //problem
  List<PostModel> favPosts=[];
  List<String> favPostsId=[];
  getFavPosts(){
    emit(LodingGetFavPost());
    favPosts=[];
    favPostsId=[];
    FirebaseFirestore.instance.collection("users").doc(uId).collection("favposts").snapshots().listen((event) {
    event.docs.forEach((element) async {
      await getOnePostData(element.id).then((value) {
        favPosts.add(value);
        favPostsId.add(element.id);
        print(favPosts.length);
        print(favPosts);
         emit(ScGetFavPost());
      });
    }); 
      emit(ScGetFavPost());
    });
  }
  
  List<PostModel> myPosts=[];
  List<String>myPostIds=[];
  getMyPosts(userId){
    emit(LodingGetMyPosts());
    FirebaseFirestore.instance.collection("posts")
    .where("uId",isEqualTo: userId,).get().then((value) {
      myPosts=[];
      myPostIds=[];
      value.docs.forEach((element) {
        myPosts.add(PostModel.fromJasn(element.data()));
        myPostIds.add(element.id);
      });
      emit(ScGetMyPosts());
    }).catchError((onError){
      print("error feom getMyPosts ${onError.toString()} ");
      emit(ErrorGetMyPosts());
    });
  }

  var picker=ImagePicker();
  File ?postImage;
  Future getpostImage()async{
    emit(LodingPickePostImage());
    var pickerFile=await picker.pickImage(source:ImageSource.gallery );
    if(pickerFile!=null){
      postImage=File(pickerFile.path);
      emit(ScPickePostImage());
    }else{
      print("error feom getpostImage1 ${onError.toString()} ");
      emit(ErrorPickePostImage(onError.toString()));
    } 
  }
  
  void removePostImage(){
    postImage=null;
    emit(RemovePostImage());
  }
  
  Future uploadPost({@required text})async{
    await firebase_storage.FirebaseStorage.instance.ref()
    .child("posts/${Uri(path: postImage!.path).pathSegments.last}")
    .putFile(postImage!).then((value) {
      value.ref.getDownloadURL().then((value) {
        craetePost(text: text,postImage:value);
        emit(AddPostWithImage());
      }).catchError((onError){
         print("error feom getdPost url ${onError.toString()} ");
      });
      
    }).catchError((onError){
       print("error feom uploadPost url ${onError.toString()} ");
    });
  }
  
  Future craetePost({@required text,postImage})async{
    emit(LodingCreatePost());
    PostModel post=PostModel(
      date: DateFormat.yMMMd().format(DateTime.now()),
      text: text,
      name: userModel.name,
      image: userModel.image,
      uId: uId??"",
      postImage: postImage??""
    );
    await FirebaseFirestore.instance.collection("posts").add(post.toMap()).then((value) {

      emit(ScCreatePost());
    }).catchError((onError){
      print("error feom craetePost ${onError.toString()} ");
      emit(ErrorCreatePost(onError.toString()));
    });

  }
  setLikes(postId,{indix}){
    emit(LodingPostsLik());
    posts[indix].isLiked=true;
    likesNum[indix]=likesNum[indix]+1;
    FirebaseFirestore.instance.collection("posts").doc(postId).collection("likes").doc(uId)
    .set({"like":true}).then((value){
      emit(ScPostsLik());
    }).catchError((onError){
      print("error feom setLikes ${onError.toString()} ");
      emit(ErrorPostsLik(onError.toString()));
    });
  }

  void delLikes(postIds,{indix}){
    emit(LodingPostsDisLik());
    posts[indix].isLiked=false;
    likesNum[indix]=likesNum[indix]-1;
    FirebaseFirestore.instance.collection("posts").doc(postIds).collection("likes").doc(uId)
    .delete().then((value){
      emit(ScPostsDisLik());
    }).catchError((onError){
      print("error feom setLikes ${onError.toString()} ");
      emit(ErrorPostsDisLik(onError.toString()));
    });
  }
  String _a="";
  isliked (postIds)async{
    await FirebaseFirestore.instance.collection("posts").doc(postIds)
    .collection("likes").doc(uId).get().then((value) {
      if(value.exists) {
        _a="d";
      } else {
        _a="l";
      }
    });
    return _a;
  }

// get comments data
  setComment({@required postId,@required name,@required uId,@required image,@required text,i}){
   emit(LodingAddComment());
   commentsNum[i]=commentsNum[i]+1;
   CommentModel comment=CommentModel(image: image,date: DateTime.now().toString(),
   name: name,text: text,uId: uId,);
   FirebaseFirestore.instance.collection("posts").doc(postId).collection("comment").add(comment.toMap()).then((value) {
     emit(ScAddComment());
     //getPosts();
   }).catchError((onError){
      print("error from setComment ${onError.toString()} ");
      emit(ErrorAddComment());
   });
 }
 
  List<CommentModel> comments=[];
  List<String> commentId=[];
  getComments(postId){
   emit(LodingGetComment());
   print(postId);
   FirebaseFirestore.instance.collection("posts").doc(postId).collection("comment")
   .snapshots().listen((event) {
     comments=[];
     commentId=[];
     event.docs.forEach((element) { 
       comments.add(CommentModel.fromJasn(element.data()));
       commentId.add(element.id);
     });
     emit(ScGetComment());
     
   });
    print("comments.length is ${comments.length}");
 }
  
  deleteComment(postId,commentId,i){
   emit(LodingDeleteComment());
   commentsNum[i]=commentsNum[i]-1;
   FirebaseFirestore.instance.collection("posts").doc(postId).collection("comment")
   .doc(commentId).delete().then((value) {
     emit(ScDeleteComment());
   }).catchError((onError){
      print("error feom deleteComment ${onError.toString()}");
      emit(ErrorDeleteComment());
   });
 }

//get settings data  
  File ?profileImage;
  Future getProfileImage()async{
    emit(LodingPickeProfileImage());
    var pickerFile=await picker.pickImage(source:ImageSource.gallery );
    if(pickerFile!=null){
      profileImage=File(pickerFile.path);
      emit(ScPickeProfileImage());
    }else{
       print("error feom getProfileImage ${onError.toString()} ");
      emit(ErrorPickeProfileImage(onError.toString()));
    } 
  }
  
  File ?coverImage;
  Future getCoverImage()async{
    emit(LodingPickeCoverImage());
    var pickerFile=await picker.pickImage(source:ImageSource.gallery );
    if(pickerFile!=null){
      coverImage=File(pickerFile.path);
      emit(ScPickeCoverImage());
    }else{
       print("error feom getCoverImage  ${onError.toString()} ");
      emit(ErrorPickeCoverImage(onError.toString()));
    }
  }

  uplodeProfileImage({ @required name,@required bio,@required  phone}){
    emit(LodingUpdateProfileImage());
    firebase_storage.FirebaseStorage.instance.ref()
    .child("users/${Uri.file(profileImage!.path).pathSegments.last}")
    .putFile(profileImage!).then((value){
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, bio: bio, phone: phone,image: value);
        changMyPostsPoto(value);
      }).catchError((onError){
        print("error feom uplodeCoverImage  ${onError.toString()} ");
        emit(ErrorUpdateCoverImage(onError.toString()));
      });
      emit(ScUpdateProfileImage());
    }).catchError((onError){
      print("error feom uplodeProfileImage  ${onError.toString()} ");
      emit(ErrorUpdateProfileImage(onError.toString()));
    });
  }
  changMyPostsPoto(image)async{
    emit(LodingChangMyPostsPoto());
    await FirebaseFirestore.instance.collection("posts").where("uId",isEqualTo: uId)
    .get().then((value) {
      value.docs.forEach((element) {
        element.reference.update({"image":image});
      });
      emit(ScChangMyPostsPoto());
    }).catchError((onError){
      print("error feom changMyPostsPoto  ${onError.toString()} ");
      emit(ErrorChangMyPostsPoto());
    });
  }

  uplodeCoverImage({ @required name,@required bio,@required  phone}) {
    emit(LodingUpdateCoverImage());
     firebase_storage.FirebaseStorage.instance.ref()
    .child("users/${Uri.file(coverImage!.path).pathSegments.last}")
    .putFile(coverImage!).then((value){
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, bio: bio, phone: phone,cover: value);
      }).catchError((onError){
        print("error feom uplodeCoverImage  ${onError.toString()} ");
        emit(ErrorUpdateCoverImage(onError.toString()));
      });
      emit(ScUpdateCoverImage());
    }).catchError((onError){
      print("error feom uplodeCoverImage  ${onError.toString()} ");
      emit(ErrorUpdateCoverImage(onError.toString()));
    });
  }
  
  void updateUser({ @required name,@required bio,@required  phone,image, cover}) {
    UserModel user =UserModel(
        name: name, phone:phone, email:userModel.email, uId: userModel.uId,
        image: image??userModel.image,
        isEmailVerified: userModel.isEmailVerified,
        bio: userModel.bio,
        cover: cover??userModel.cover,
        state: true,
     );
    FirebaseFirestore.instance.collection("users").doc(uId).update(user.toMap()).then((value){
      getUserData();
      emit(ScUpdateProfile());
    }).catchError((onError){
      print("error feom uplodeCoverImage  ${onError.toString()} ");
      emit(ErrorUpdateProfile(onError.toString()));
    }); 
  }

 //follow
  followPerson(personid){
   emit(LodingFollowPerson());
   if(personid!=uId){
     FirebaseFirestore.instance.collection("users").doc(uId).collection("followings")
   .doc(personid).set({}).then((value) {
     emit(ScFollowPerson());
   }).catchError((onError){
     print("error feom followPerson  ${onError.toString()} ");
      emit(ErrorFollowPerson());
   });

   FirebaseFirestore.instance.collection("users").doc(personid).collection("followers")
   .doc(uId).set({}).then((value) {
     emit(ScFollowPerson());
   }).catchError((onError){
     print("error feom followPerson  ${onError.toString()} ");
      emit(ErrorFollowPerson());
   });
   }else {
     emit(ScFollowPerson());
   }
   
 }
 
  unFollowPerson(personid){
   emit(LodingUnFollowPerson());
   print(personid);
   FirebaseFirestore.instance.collection("users").doc(uId).collection("followings")
   .doc(personid).delete().then((value) {
     emit(ScUnFollowPerson());
   }).catchError((onError){
     print("error feom followPerson  ${onError.toString()} ");
      emit(ErrorUnFollowPerson());
   });

   FirebaseFirestore.instance.collection("users").doc(personid).collection("followers")
   .doc(uId).delete().then((value) {
     emit(ScUnFollowPerson());
   }).catchError((onError){
     print("error feom followPerson  ${onError.toString()} ");
      emit(ErrorUnFollowPerson());
   });
 }
 //problem
  List<UserModel>followings=[];
  getfollowings()async{
   emit(LodingGetFollowings());
    followings=[];
   await FirebaseFirestore.instance.collection("users").doc(uId).collection("followings")
   .get().then((value) {
    
     value.docs.forEach((element)async {
      await getOnePerson(element.id).then((value){
         followings.add(value);
         print("followings  id is ${element.id}");
         emit(ScGetAllFollowings());
       });
     });
     emit(ScGetFollowings());
   }).catchError((onError){
     print("error feom getfollowings  ${onError.toString()} ");
      emit(ErrorGetFollowings());
   });
 } 
 //problem
  List<UserModel>followers=[];
  getfollowers()async{
   emit(LodingGetFollowers());
   followers=[];
   await FirebaseFirestore.instance.collection("users").doc(uId).collection("followers")
   .get().then((value) {
     value.docs.forEach((element) async {
        await getOnePerson(element.id).then((value){
         followers.add(value);
          print("follower id is ${element.id}");
          emit(ScGetFollowers());
       }); 
       emit(ScGetAllFollowers());
     });
     
   }).catchError((onError){
     print("error feom getollowers  ${onError.toString()} ");
      emit(ErrorGetFollowers());
   });
 } 
  
  Map<String,int>profileNumbers={};
  getProfileNumbers(personId){
    profileNumbers={};
    emit(LodingGetProfileNumbers());
    try{
      FirebaseFirestore.instance.collection("users").doc(personId).collection("followings").snapshots().listen((event) {
        profileNumbers.addAll({"followings":event.docs.length});
        //print("followings : ${event.docs.length}");
        emit(ScGetProfileNumbers());
      });
      
      FirebaseFirestore.instance.collection("users").doc(personId).collection("followers").snapshots().listen((event) {
        profileNumbers.addAll({"followers":event.docs.length});
        //print("followers : ${event.docs.length}");
        emit(ScGetProfileNumbers());
      });
      
      FirebaseFirestore.instance.collection("users").doc(personId).collection("favposts").snapshots().listen((event) {
        profileNumbers.addAll({"favposts":event.docs.length});
        emit(ScGetProfileNumbers());
      });
      
      FirebaseFirestore.instance.collection("posts").where("uId",isEqualTo: personId).where("postImage",isNotEqualTo: "").snapshots().listen((event) {
        profileNumbers.addAll({"image":event.docs.length});
        emit(ScGetProfileNumbers());
      });
  
    }catch(e){
      print("erorr from getProfileNumbers is ${e.toString()}");
    }
    
  }
  
  String _f="";
  Future<String> isfollow (personIds)async{
    await FirebaseFirestore.instance.collection("users").doc(uId)
    .collection("followings").doc(personIds).get().then((value) {
      if(value.exists) {
        _f="f";
      } else {
        _f="u";
      }
    });
    
    return _f;
  }

//Seearch
  
  List<UserModel> searchedUsers=[];
  searchByName(String text){
    emit(LodingSearch());
    FirebaseFirestore.instance.collection("users").get().then((value) {
      searchedUsers=[];
      value.docs.forEach((element) {
        if(text==""){
           emit(ScSearch());
        }else{
          if(element["name"].contains(text)){
            searchedUsers.add(UserModel.fromJasn(element.data()));
          }
          emit(ScSearch());
        } 
      });
    }).catchError((onError){
      print("error feom searchByName  ${onError.toString()} ");
      emit(ErrorSearch());
    });
  }

// story
File ?storyImage;
  Future getStoryImage()async{
    emit(LodingPickeStoryImage());
    var pickerFile=await picker.pickImage(source:ImageSource.gallery );
    if(pickerFile!=null){
      storyImage=File(pickerFile.path);
      emit(ScPickeStoryImage());
    }else{
      print("error feom getStoryImage1 ${onError.toString()} ");
      emit(ErrorPickeStoryImage(onError.toString()));
    } 
  }
  
  void removeStoryImage(){
    storyImage=null;
    emit(RemoveStoryImage());
  }
  
  Future uploadStory({@required text})async{
    await firebase_storage.FirebaseStorage.instance.ref()
    .child("storys/${Uri(path: storyImage!.path).pathSegments.last}")
    .putFile(storyImage!).then((value) {
      value.ref.getDownloadURL().then((value) {
        craeteStory( text: text,storyImage:value);
        emit(AddStoryWithImage());
      }).catchError((onError){
         print("error feom getdStory url ${onError.toString()} ");
      });
      
    }).catchError((onError){
       print("error feom uploadStory url ${onError.toString()} ");
    });
  }
  
  Future craeteStory({@required text,storyImage,storyVideo})async{
    emit(LodingCreateStory());
    StoryModel story=StoryModel(
      date: DateTime.now().toString(),
      text: text,
      name: userModel.name,
      image: userModel.image,
      uId: uId??"",
      storyImage: storyImage??"",
      video: storyVideo??""
    );
    await FirebaseFirestore.instance.collection("users").doc(uId).collection("storys").add(story.toMap()).then((value) {

      emit(ScCreateStory());
    }).catchError((onError){
      print("error feom craeteStory ${onError.toString()} ");
      emit(ErrorCreateStory(onError.toString()));
    });

  }
 
 List<UserStorys>userStorys=[];
  void getAllStorys(){
   emit(LodingGetAllStoris());
   userStorys=[];
   users.forEach((element) {
      UserStorys oneUserStory=UserStorys(user:element,storys: [] );
      FirebaseFirestore.instance.collection("users").doc(element.uId).collection("storys")
      .get().then((value) {
        value.docs.forEach((element1){
          oneUserStory.storys.add(StoryModel.fromJasn(element1.data()));
          emit(ScGetStoris());
        });
        if(oneUserStory.storys.isNotEmpty) {
          userStorys.add(oneUserStory);
        }
        emit(ScGetAllStoris()); 
    }).catchError((onError){
        print("error feom getAllStorys ${onError.toString()}");
        emit(ErrorGetAllStoris());
    });
    });
 }
  
 List<StoryItem> storyItems=[];
 Future getStoryItems(UserStorys myStory,StoryController stc)async{
   storyItems=[];
   emit(LodingGetMyStorisItem());
   myStory.storys.forEach((element) {
      if(element.storyImage!=""){
        print(element.image);
         storyItems.add(StoryItem.pageImage(url:element.storyImage,
          controller: stc,caption:element.text, )
      );
      }
      else{
        storyItems.add(StoryItem.text(title: element.text, backgroundColor: mainColor,));
      } 
      emit(ScGetMyStorisItem());
  });
 }
}






