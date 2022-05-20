// ignore_for_file: file_names, avoid_print

import 'dart:io';


import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/screens/chat%20screen/pdf%20view.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/chat%20cuipt/chat_cuipt.dart';
import 'package:social_app/shared/cubit/chat%20cuipt/chat_stats.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/models/messages%20models.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// ignore: must_be_immutable
class ChatDataScreen extends StatelessWidget {
  ChatDataScreen(this.user, {Key? key}) : super(key: key);
  ChatModel user;
  final GlobalKey<SfPdfViewerState> pc = GlobalKey();
  var tc = TextEditingController();
  var sc = GlobalKey<ScaffoldState>();
  var focusNode = FocusNode();
  
  
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      ChatCupit.get(context).getMessages(user.uid);
      return BlocConsumer<ChatCupit, ChatState>(
          listener: (context, state) {},
          builder: (context, state) {
            ChatCupit cupit = ChatCupit.get(context);
            SocialCupit cupit1=SocialCupit.get(context);
              KeyboardVisibilityController().onChange.listen((bool isKeyboardVisible) {
                cupit.isKeyV(isKeyboardVisible);
                print("kd is $isKeyboardVisible");
                print("em  is ${cupit.ise}");
              if ( cupit.isk && cupit.ise) cupit.isEmogyV(false);
              
            });
            return Directionality(
              textDirection: (cupit1.isEnglish) ?TextDirection.ltr:TextDirection.rtl,
              child: Scaffold(
                key: sc,
                appBar: AppBar(
                  title: Row(
                    children: [
                      CircleAvatar(radius: 20, backgroundImage: NetworkImage(user.image), ),
                      const SizedBox( width: 10, ),
                      Expanded(child: Text(user.name,style: const TextStyle(height: 1.2), )),
                    ],
                  ),    
                ),
                body: 
                 Column(
                    children: [
                      const SizedBox(height: 5,),
                      if(state is LodingUpdateChatFile)
                      const LinearProgressIndicator(),
                      const SizedBox(height: 5,),
                      (cupit.messages.isNotEmpty)?
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, indix) {
                                if (cupit.messages[indix].sId == uId) {
                                  return message(cupit.messages[indix].text,cupit.messages[indix].image, cupit.messages[indix].file  ,AlignmentDirectional.centerEnd, mainColor.withOpacity(0.3),context,indix,end: const Radius.circular(0),stsrt: const Radius.circular(10),);
                                } else {
                                  return message(cupit.messages[indix].text,cupit.messages[indix].image, cupit.messages[indix].file ,AlignmentDirectional.centerStart, Colors.grey,context,indix,end: const Radius.circular(10),stsrt: const Radius.circular(0),);
                                } 
                              },
                              separatorBuilder: (context, indix) => const SizedBox(
                                    height: 5,
                                  ),
                              itemCount: cupit.messages.length),
                        ),
                      ):Expanded(child: emptyPage(Icons.message,!(cupit1.isEnglish) ?"فارغ": "empty")),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: mainColor, width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [         
                                    IconButton(
                                      onPressed: () {
                                        onClickEmojy(context);
                                        },
                                      icon: Icon(cupit.isk? Icons.emoji_emotions:!cupit.ise? Icons.emoji_emotions:Icons.keyboard),
                                      padding: EdgeInsets.zero,
                                      iconSize: 20,
                                    ),
                                    Expanded(child:textInput(!(cupit1.isEnglish) ?"اكتب رساله":"type massege",context)),
                                    IconButton(
                                    onPressed: () {
                                      cupit.getChatfile().then((value) {
                                        print(value);
                                        if(cupit.file!=null){
                                          cupit.uploadMessageFile(message: tc.text, resiverid:user.uid, resivername: user.name,resiverimage: user.image ).then((value){
                                            cupit.changechatInputText("");
                                            tc.text = "";
                                            Navigator.pop(context);
                                          });
                                        }
                                      });
                                      },
                                       
                                      icon: const Icon(Icons.attachment_rounded),
                                      padding: EdgeInsets.zero,
                                      iconSize: 20,
                                    ),
                                    if(cupit.chatInputText=="")
                                    IconButton(
                                      onPressed: () {
                                        cupit.getChatImage().then((value) {
                                          print(value);
                                          if(cupit.chatImage!=null) {
                                            sc.currentState!.showBottomSheet((context) {
                                            return bottomSheetImage(
                                              chatImage:cupit.chatImage!,context:context,
                                              onTap: () {
                                                if(cupit.chatImage!=null) {
                                                  cupit.uploadMessage(message: tc.text, resiverid:user.uid, date:DateTime.now().toString(),resivername: user.name,resiverimage: user.image ).then((value){
                                                    cupit.changechatInputText("");
                                                    tc.text = "";
                                                    Navigator.pop(context);
                                                  });
                                                }
                                              },
                     
                                              );
                                            });
                                          }
                                          });
                                        },
                                        icon: const Icon(Icons.camera_alt),
                                        padding: EdgeInsets.zero,
                                        iconSize: 20,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            floatingActionButton(
                              context: context,
                              onPressed: () {
                                if(cupit.chatInputText!=""){
                                  cupit.sendMessage(message: tc.text, resiverid:user.uid, date:DateTime.now().toString(),resivername: user.name,resiverimage: user.image);
                                }
                                cupit.changechatInputText("");
                                tc.text="";
                              },
                            )
                          ],
                        ),
                      ),
                      if(cupit.ise)
                      const SizedBox(height: 5,),
                      if(cupit.ise)
                      emojiPicker(context),
                    ],
                  ),
              ),
            );
          });
    });
  }

  Widget message(String text,String image,file,alignment,color,context,indix,{end,stsrt})  {
    ChatCupit cupit = ChatCupit.get(context);
    SocialCupit cupit1 = SocialCupit.get(context);
    return Align(
      alignment: alignment,
      child: InkWell(  
        onLongPress: () {
          //for delet or add message to faver
          sc.currentState!.showBottomSheet((context) {
            return Container(
              color: cupit1.moodl?Colors.white:HexColor('333739'),
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                      TextButton(
                        onPressed: () {
                          cupit.addToFav(indix);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.favorite, size: 20,color: mainColor,),
                            const SizedBox(width: 5,),
                            Text(!(cupit1.isEnglish) ?"اضافه للمفضله": "Add to Favoret",style: Theme.of(context).textTheme.caption!. copyWith (color: mainColor, fontSize: 15),),
                          ],
                        ),
                      ),
                       TextButton(
                        onPressed: () {
                          cupit.deleteMessage(cupit.messagesId[indix], user.uid);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.delete, size: 20,color: mainColor,),
                            const SizedBox(width: 5,),
                            Text(!(cupit1.isEnglish) ?"مسح": "Delete",style: Theme.of(context).textTheme.caption!. copyWith (color: mainColor, fontSize: 15),),
                          ],
                        ),
                      ),

                    ],),
                  ),
              ),
            );
          });
        },
        onTap: ()  {    
          if(image!=""){
            //for show big image
            sc.currentState!.showBottomSheet((context) =>Container(
            color: cupit1.moodl?Colors.white:HexColor('333739'),
            height: double.infinity,
            width: double.infinity,
            alignment: AlignmentDirectional.center,
            child: Image(image: NetworkImage(image),)) ,
            );   
          }
          if(file!=""){
            print("file is here $file");
            navigatorTo(context, Pdf(file));
          }      
        },
        child:
           Container(
             width:200,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: 
              BoxDecoration(
                color:color,
                borderRadius: BorderRadiusDirectional.only(
                    bottomEnd: end,
                    bottomStart:stsrt ,
                    topEnd: const Radius.circular(10),
                    topStart: const Radius.circular(10))
              ),
            child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(image!="")
                  Image(image: NetworkImage(image),
                   loadingBuilder: (context, child,ImageChunkEvent ?loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(height: 150, child: Center(child: CircularProgressIndicator()));
                  },       
                  ),
                  if(file!="")
                  SizedBox(
                    height: 150,
                    child: SfPdfViewer.network(file, key: pc,)
                  ),
                  Text(text),
                ],
              ),
          ),
        ),
    );
  }

  Widget textInput(String text,context) {
    ChatCupit cupit = ChatCupit.get(context);
     SocialCupit cupit1 = SocialCupit.get(context);
    return Scrollbar(
      thickness: 3,
      child: TextFormField(
          style: TextStyle(color: cupit1.moodl?Colors.black:Colors.white),
        onChanged: (value){
          cupit.changechatInputText(value);
        },
        focusNode: focusNode,
        controller: tc,
        maxLines: 4,
        minLines: 1,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintStyle: const TextStyle(color:Colors.grey,fontWeight: FontWeight.bold,fontSize: 15) ,
            border: InputBorder.none, hintText: text, hintMaxLines: 1),
      ),
    );
  }
  //for adding message with photo
  Widget bottomSheetImage({required File chatImage,context,required Function onTap}){
    SocialCupit cupit1 = SocialCupit.get(context);
    return Container(
      color:! cupit1.moodl?HexColor('333739'):Colors.white ,
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Stack( 
          alignment: AlignmentDirectional.center,
          children: [
            Image(image: FileImage(chatImage),fit: BoxFit.contain,),
            Container(
                alignment: AlignmentDirectional.bottomEnd,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                        padding:  const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ! cupit1.moodl?HexColor('333739'):Colors.white ,
                          border: Border.all(color: mainColor, width: 1),
                          borderRadius: BorderRadius.circular(5), 
                        ),
                        child:textInput(!(cupit1.isEnglish) ?"اكتب رساله":"typ massege",context), )),
                    floatingActionButton(
                      context: context,
                      onPressed: onTap
                    ),
                  ],
                ),
            ),
          ],
        ),
      );                                   
  }

  Widget floatingActionButton({required Function onPressed,context,}){
    return FloatingActionButton(
      mini: true,
      onPressed:()=> onPressed,
      elevation: 0,
      child: const Icon(
        Icons.send,
        color: Colors.white,
        size: 25,
      ),
      backgroundColor: mainColor,
    );
  } 
  
  Widget emojiPicker(context){
    return SizedBox(
      width: double.infinity,

      child: EmojiPicker(
        config: const Config(
          columns: 7,
          buttonMode: ButtonMode.MATERIAL,
        ),
        
        
        onEmojiSelected: (Category category, Emoji emoji){
         tc.text=tc.text+emoji.emoji;
        },
        ),
    );
  }
  
  Future<void> onClickEmojy(context) async {
     ChatCupit cupit = ChatCupit.get(context);
      if (cupit.ise) {
      focusNode.requestFocus();
      toggleEmojiKeyboard(context);
    } else if(cupit.isk){
      await SystemChannels.textInput.invokeMethod("TextInput.hide");
      Future.delayed(const Duration(milliseconds: 100)).then((value) =>  toggleEmojiKeyboard(context));    
    }
    
  }
  
  Future toggleEmojiKeyboard(context) async {
    ChatCupit cupit = ChatCupit.get(context);
    if (cupit.isk) {
      FocusScope.of(context).unfocus();
    }
    cupit.isEmogyV(!cupit.ise);
   
  }
 
  Future<bool> onBackPress(context) {
     ChatCupit cupit = ChatCupit.get(context);
    if (cupit.ise) {
      toggleEmojiKeyboard(context);
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

}

