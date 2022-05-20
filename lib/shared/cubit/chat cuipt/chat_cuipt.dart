// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/models/loge%20in%20models.dart';
import 'package:social_app/shared/models/messages%20models.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'chat_stats.dart';

class ChatCupit extends Cubit<ChatState>{
  ChatCupit():super(IntiChatState());
  static ChatCupit get(context)=>BlocProvider.of(context);
  
   
 //get chats data 
  late bool _isChat;
  Future<bool> isChat(resiverid,image,name)async{
   await FirebaseFirestore.instance.collection("users").doc(uId).collection("chats").doc(resiverid).get().then((value) {
     if(value.exists){
        _isChat= true;
     } 
     else {
       ChatModel chat=ChatModel(image: image,name: name,uid: resiverid);
        _isChat= false;
        FirebaseFirestore.instance.collection("users").doc(uId).collection("chats")
        .doc(resiverid).set(chat.toMap());
     }
   });
   return _isChat;
 }
 
  void send(MessageModel m,uId,resiverid){
  FirebaseFirestore.instance.collection("users").doc(uId).collection("chats").doc(resiverid). collection("message").add( m.toMap()).then((value) {
    emit(ScSendMessage());
    }).catchError((onError){
    emit(ErrorSendMessage());
    print('erorr from sendMessage is ${onError.toString()}');
  });
 }
  
  Future sendMessage({required String message,required resiverid,
    required String date,
    required String resivername,
    required String resiverimage,
   image, myfile})async{
    emit(LodingSendMessage());
    MessageModel m=MessageModel(date: date,text: message,sId: uId!,rId: resiverid
    ,image: image??"",
    file:myfile??"",
    );
    isChat(resiverid, resiverimage, resivername).then((value){
      send(m, uId, resiverid);
      send(m, resiverid,uId );
    }); 
  }
  
  List<MessageModel> messages=[];
  List<String>messagesId=[];
  void getMessages(resiverid){
    emit(LodingGetMessage());
    FirebaseFirestore.instance.collection("users").doc(uId).collection("chats").doc(resiverid).collection("message").orderBy("date").snapshots().listen((event) { 
      messages=[];
      messagesId=[];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJasn(element.data()));
        messagesId.add(element.id);
      });
      emit(ScGetMessage());
    });
  }
  var picker=ImagePicker();
  File ?chatImage;
  Future getChatImage()async{
    emit(LodingPickeChatImage());
    var pickerFile=await picker.pickImage(source:ImageSource.gallery );
    if(pickerFile!=null){
      chatImage=File(pickerFile.path);
      emit(ScPickeChatImage());
      return chatImage;
    }else{
       print("error feom getChatImage ${onError.toString()} ");
      emit(ErrorPickeChatImage(onError.toString()));
    } 
  }
  
  Future uploadMessage({required String message,required resiverid, required String date,
    required String resivername,
    required String resiverimage,
  })async{
       emit(LodingUpdateChatImage());
      await firebase_storage.FirebaseStorage.instance.ref().child("chats/${Uri.file(chatImage!.path).pathSegments.last}").putFile(chatImage!).then((value) {
        value.ref.getDownloadURL().then((value) {
          sendMessage(message:  message,resiverid:  resiverid,date:  date,image:  value,
          resiverimage: resiverimage,
          resivername:resivername
          );
          emit(ScUpdateChatImage());
        }).then((value) {
          removeChatImage();
        }).catchError((onError){
           emit(ErrorUpdateChatImage(onError.toString()));
            print('erorr from uploadMessage is ${onError.toString()}');
        });
      }).catchError((onError){
         emit(ErrorUpdateChatImage(onError.toString()));
         print('erorr from uploadMessage is ${onError.toString()}');
      });
    }
  
  void removeChatImage(){
    chatImage=null;
    emit(RemoveChatImage());
  }
  String chatInputText="";
  void changechatInputText(value){
    chatInputText=value;
    emit(ChangeInputText());
  }

  List<MessageModel>favMessages=[];
  List<String>favMessagesId=[];
  void getFavMessages(){
    emit(LodingGetFavMessage());
    FirebaseFirestore.instance.collection("users").doc(uId).collection("fav").orderBy("date").snapshots().listen((event) { 
      favMessages=[];
      favMessagesId=[];
      event.docs.forEach((element) {
        favMessages.add(MessageModel.fromJasn(element.data()));
        favMessagesId.add(element.id);
        //print(favMessagesId);
      });
      emit(ScGetFavMessage());
    });
  }

  void addToFav(int messageid){
    emit(LodingAddToFav());
    FirebaseFirestore.instance.collection("users").doc(uId).collection("fav").add(messages[messageid].toMap()).then((value) {
      emit(ScAddToFav());
    }).catchError((onError){
      emit(ErrorAddToFav(onError.toString()));
      print('erorr from addToFav is ${onError.toString()}');
    });
    
  }
  
   removeFromFav(messageid){
    emit(LodingDeleteFromFav());
    FirebaseFirestore.instance.collection("users").doc(uId).collection("fav").doc(messageid).delete().then((value) {
      print(messageid.toString());
      emit(ScDeleteFromFav());
    }).catchError((onError){
      emit(ErrorDeleteFromFav(onError.toString()));
      print('erorr from removeFromFav is ${onError.toString()}');
    }); 
  }

  deleteMessage(messageid,resiverid){
     emit(LodingDeleteMessage());
    FirebaseFirestore.instance.collection("users").doc(uId).collection("chats")
    .doc(resiverid).collection("message").doc(messageid).delete().then((value) {
      emit(ScDeleteMessage());
    }).catchError((onError){
      emit(ErrorDeleteMessage());
      print('erorr from removeFromFav is ${onError.toString()}');
    });
  }
  
  deleteChat(id){
    print(id);
    print(uId);
     emit(LodingDeleteChat());
    FirebaseFirestore.instance.collection("users").doc(uId).collection("chats").doc(id).collection("message").get()
    .then((value) {
      value.docs.forEach((element) {
        element.reference.delete().then((value1) {
          FirebaseFirestore.instance.collection("users").doc(uId).collection("chats").doc(id).delete().then((value) => getChats());
        }).catchError((onError){
          emit(ErrorDeleteChat());
          print('erorr from deleteChat is ${onError.toString()}');
        });
      });
       emit(ScDeleteChat());
    }).catchError((onError){
       emit(ErrorDeleteChat());
      print('erorr from deleteChat is ${onError.toString()}');
    });
  }

  List<ChatModel>chats=[];
  List<String>lastMessages=[];
  List<String>lastMessagesId=[];
  List<bool>usersState=[];
   getChats(){
    emit(LodingGetChats());
     FirebaseFirestore.instance.collection("users").doc(uId).collection("chats").snapshots().listen((event) {
       print("number of chats is ${event.docs.length}");
        chats=[];
        lastMessages=[];
        lastMessagesId=[];
        usersState=[];
        event.docs.forEach((element) async {
          await getLastOneMessage(element.id).then((value) async{
            await getOnePerson(element.id).then((value1) {
              usersState.add(value1.state);
              lastMessages.add(value.text);
              lastMessagesId.add(value.sId);
              chats.add(ChatModel.fromJasn(element.data()));
            });
          });
        print("chat user id =  ${element.id}");
       });
      emit(ScGetChats());
    });
  }
  
  Future<dynamic>getOnePerson(personid)async{
    emit(LodingGetUser());
   UserModel user=UserModel.ec();
   await FirebaseFirestore.instance.collection("users").doc(personid).get().then((value){
     user=UserModel.fromJasn(value.data()!);
      emit(ScGetUser());
   });
   return user;
  }
  
  Future<MessageModel> getLastOneMessage(peersonId)async{
   MessageModel mymessage=MessageModel.ec();
    emit(LodingGetLastMessage());
     await FirebaseFirestore.instance.collection("users").doc(uId).collection("chats").doc(peersonId)
     .collection("message").orderBy("date").get().then((event) {
      print(event.docs.last["text"]);
      emit(ScGetLastMessage()); 
      mymessage= MessageModel.fromJasn(event.docs.last.data());
    });
    return mymessage;
  }
  
  
  File ?file;
  Future getChatfile()async{
    FilePickerResult ?result;
    emit(LodingPickeChatFile());
    result=(await FilePicker.platform.pickFiles());
    if (result != null){
      file=File(result.files.single.path!);
      print(result.files.single.path);
      //openFile(file);
      emit(ScPickeChatFile());
      return file;
    }else{
       print("error feom getChatFile ${onError.toString()} ");
      emit(ErrorPickeChatFile(onError.toString()));
    } 
  }
  openFile(File file){
    OpenFile.open(file.path);
  }
   
  Future uploadMessageFile({required String message,required resiverid,
    required String resivername,
    required String resiverimage,
  })async{
       emit(LodingUpdateChatFile());
      await firebase_storage.FirebaseStorage.instance.ref().child("chatfiles/${Uri.file(file!.path).pathSegments.last}").putFile(file!).then((value) {
        value.ref.getDownloadURL().then((value) {
          sendMessage(message:  message,resiverid:  resiverid,date: DateTime.now().toString(),myfile:  value,
          resiverimage: resiverimage,
          resivername:resivername
          );
          emit(ScUpdateChatFile());
        }).then((value) {
          removeChatImage();
        }).catchError((onError){
           emit(ErrorUpdateChatFile(onError.toString()));
            print('erorr from uploadMessage is ${onError.toString()}');
        });
      }).catchError((onError){
         emit(ErrorUpdateChatFile(onError.toString()));
         print('erorr from uploadMessage is ${onError.toString()}');
      });
    }

  bool ise=false;
  void isEmogyV(value){
    ise=value;
    emit(IsEmogyV());
  }
  bool isk=false;
  void isKeyV(value){
    isk=value;
    emit(IsKeyV());
  }
}
