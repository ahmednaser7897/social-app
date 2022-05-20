import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/chat%20cuipt/chat_cuipt.dart';
import 'package:social_app/shared/cubit/chat%20cuipt/chat_stats.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/models/messages%20models.dart';

import '../homePage.dart';
import 'chatDataScreen.dart';


class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCupit, ChatState>(
      listener: (context, state) {},
      builder: (context, state) {
        ChatCupit cupit = ChatCupit.get(context);
        SocialCupit cupit1 = SocialCupit.get(context);
        return (state is LodingGetChats||state is LodingGetLastMessage|| state is LodingGetUser)?
        const Center(child:  CircularProgressIndicator(),):
        (cupit.chats.isNotEmpty)?
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder:(context,indix){
              return item(cupit.chats[indix],context,indix,cupit.usersState[indix],cupit.lastMessages[indix],cupit.lastMessagesId[indix]);
            },
            separatorBuilder:(context,indix)=>const SizedBox(height: 5,),
            itemCount: cupit.chats.length
          ),
        ):emptyPage(Icons.chat,!(cupit1.isEnglish) ?"فارغ":"emoty"); 
      });
  }
  Widget item(ChatModel chat,context, indix,state,String lastMassege,String lastMessageId){ 
     ChatCupit cupit = ChatCupit.get(context);
     SocialCupit cupit1 = SocialCupit.get(context);
     
    return InkWell(
      onLongPress: (){
         sc.currentState!.showBottomSheet((context) {
            return Container(
              color: cupit1.moodl?Colors.white:HexColor('333739'),
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                  height: 60, 
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                        onPressed: () {
                          cupit.deleteChat(chat.uid);
                           Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.delete, size: 20,color: mainColor,),
                            const SizedBox(width: 5,),
                            Text(!(cupit1.isEnglish) ?"ازاله المحادثه": "Delete chat contant",style: Theme.of(context).textTheme.caption!. copyWith (color: mainColor, fontSize: 15),),
                          ],
                        ),
                      ),

                    ],),
                  ),
              ),
            );
        }
        );
      },
      onTap: (){
        navigatorTo(context, ChatDataScreen(chat));
      },
      child: 
         Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(chat.image),
                        ),
                         CircleAvatar(radius: 5, backgroundColor:state? Colors.green :Colors.red,),
                      ],
                    ),
                    const SizedBox(width: 5,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [    
                          Text(chat.name,style: const TextStyle (height: 1.2),),
                          Row(
                            children: [
                              Text((lastMessageId==uId)?!(cupit1.isEnglish) ?"انت":"you : ":"${chat.name.toString()} : ",style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 15,color: !cupit1.moodl?Colors.white:const Color.fromRGBO(0, 0, 0, 1))),
                              Expanded(
                                child: Text(lastMassege,
                                maxLines: 1
                                ,overflow: TextOverflow.ellipsis ,style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 15,color: !cupit1.moodl?Colors.white:Colors.black)),
                              ),
                            ],
                          ),   
                        ],
                      ),
                    )
                  ],
                ),
        ),
    );
  }
  
}

