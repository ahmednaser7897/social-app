import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/chat%20screen/chatDataScreen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_states.dart';
import 'package:social_app/shared/models/loge%20in%20models.dart';
import 'package:social_app/shared/models/messages%20models.dart';


// ignore: must_be_immutable
class FollowScreen extends StatelessWidget{
  final String type;

  const FollowScreen({Key? key, required this.type}) : super(key: key);
  
  
  @override
   Widget build(BuildContext context) {
    
    
    return BlocConsumer<SocialCupit, SocialState>(
        listener: (context, state) {},
        builder: (context, state) {
          SocialCupit cupit = SocialCupit.get(context);
          return Directionality(
             textDirection: (cupit.isEnglish) ?TextDirection.ltr:TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(title:Text((type=="fing")?
              !(cupit.isEnglish) ?"المتابعون":"followings"
              :!(cupit.isEnglish) ?"المتابعون لك":"followers") ,),
              body: (cupit.followers.isNotEmpty||cupit.followings.isNotEmpty)?
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context,indix)=>item(context,
                    (type=="fing")?cupit.followings[indix]:cupit.followers[indix]),
                    separatorBuilder:(context,indix)=>const SizedBox(height: 10,),
                      itemCount:(type=="fing")? cupit.followings.length:cupit.followers.length
                  ),
              ):const Center(child:  CircularProgressIndicator(),)
              ),
          );
          });
  }
  Widget item(context,UserModel user){
    SocialCupit cupit = SocialCupit.get(context);
    return InkWell(
      onTap: (){},
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(user.image),
          ),
          const SizedBox(width: 5,),
          Expanded(child: Text(user.name,style: const TextStyle (height: 1.2),overflow: TextOverflow.clip,maxLines: 1,)),
          
          IconButton(icon:const Icon(Icons.message),
            onPressed: (){
              navigatorTo(context, ChatDataScreen(ChatModel.fromJasn( {
                'uid': user.uId,
                'name': user.name,
                'image':user.image
              })));
            },
          ),
          if(type!="fer")
          IconButton(icon:const Icon(Icons.delete),
            onPressed: (){
              cupit.unFollowPerson(user.uId);
              
            },
          )
        ],
      ),
    );
  }
}