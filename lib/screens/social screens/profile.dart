// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/screens/chat%20screen/chatDataScreen.dart';
import 'package:social_app/screens/social%20screens/edit_prof.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_states.dart';
import 'package:social_app/shared/models/loge%20in%20models.dart';
import 'package:social_app/shared/models/messages%20models.dart';

import '../post screens/new_post_screen.dart';


// ignore: must_be_immutable
class ProfilegScreen extends StatelessWidget{
  var sc = GlobalKey<ScaffoldState>();
  UserModel user;
  String isFollow="";
  ProfilegScreen({Key? key, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SocialCupit.get(context).getMyPosts(user.uId);
    SocialCupit.get(context).getProfileNumbers(user.uId);
    SocialCupit.get(context).isfollow(user.uId).then((value){
      isFollow=value;
    });
    return BlocConsumer<SocialCupit, SocialState>(
      listener: (context, state) { },
      builder: (context, state) {
        SocialCupit cupit=SocialCupit.get(context);
        return Directionality(
          textDirection: (cupit.isEnglish) ?TextDirection.ltr:TextDirection.rtl,
          child: Scaffold(
            key: sc,
            appBar: AppBar(),
            body: 
            (state is LodingGetFollowings ||state is LodingGetFollowers)?
            const Center(child: CircularProgressIndicator()):
            (cupit.profileNumbers.length==4&&cupit.myPosts.isNotEmpty)?
            Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: 180,
                  child: Stack(
                    alignment:AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        alignment:Alignment.topCenter ,
                        child: Container(
                          height: 150,width:double.infinity ,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: NetworkImage(user.cover),fit: BoxFit.cover,),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ))
                        ),
                      ),
                      CircleAvatar(
                          radius: 61,
                          backgroundColor:Theme.of(context).scaffoldBackgroundColor ,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage:  NetworkImage(user.image),
                            ),
                        ),
                    ],
                  ),
                ),
                Text(user.name,style: Theme.of(context).textTheme.bodyText1,),
                Text(user.bio,style: Theme.of(context).textTheme.caption!.copyWith(color: cupit.moodl?Colors.black:Colors.white),),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){},
                        child: Column(children: [
                          Text(cupit.profileNumbers["followings"].toString(),style: Theme.of(context).textTheme.subtitle2!.copyWith(color: cupit.moodl?Colors.black:Colors.white),),Text(!(cupit.isEnglish) ?"المتابعون":"Followings",style: Theme.of(context).textTheme.subtitle2!.copyWith(color: cupit.moodl?Colors.black:Colors.white),),
                        ],),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){},
                        child: Column(children: [
                          Text(cupit.profileNumbers["followers"].toString(),style: Theme.of(context).textTheme.subtitle2!.copyWith(color: cupit.moodl?Colors.black:Colors.white),),Text(!(cupit.isEnglish) ?"المتالعين لك":"Followers",style: Theme.of(context).textTheme.subtitle2!.copyWith(color: cupit.moodl?Colors.black:Colors.white,),)
                        ],),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){},
                        child: Column(children: [
                          Text(cupit.profileNumbers["image"].toString(),style: Theme.of(context).textTheme.subtitle2!.copyWith(color: cupit.moodl?Colors.black:Colors.white),),Text(!(cupit.isEnglish) ?"الصور":"Photos",style: Theme.of(context).textTheme.subtitle2!.copyWith(color: cupit.moodl?Colors.black:Colors.white),),
                        ],),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){},
                        child: Column(children: [
                          Text(cupit.profileNumbers["favposts"].toString(),style: Theme.of(context).textTheme.subtitle2!.copyWith(color: cupit.moodl?Colors.black:Colors.white),),Text(!(cupit.isEnglish) ?"المنشورات المفضله":"FavPost",style: Theme.of(context).textTheme.subtitle2!.copyWith(color: cupit.moodl?Colors.black:Colors.white),),
                        ],),
                      ),
                    ),
                  ],),
                ),
                const SizedBox(height: 10,),
                if(user.uId==uId)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(onPressed: (){
                        navigatorTo(context, NewPostScreen(isPost: true,));
                      },
                      child: Text(!(cupit.isEnglish) ?"اضافه صوره":"Add Photos"),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    OutlinedButton(onPressed: (){
                      navigatorTo(context, const EditProfScreen());
                    },
                    child: const Icon(Icons.edit,size: 15,),
                    ),
                  ],
                ),
                if(user.uId!=uId)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: (){
                        if(isFollow=="f"){
                           cupit.unFollowPerson(user.uId);
                            SocialCupit.get(context).isfollow(user.uId).then((value){
                            isFollow=value;
                          });
                          
                        }else{
                          cupit.followPerson(user.uId);
                            SocialCupit.get(context).isfollow(user.uId).then((value){
                            isFollow=value;
                            
                          });
                          
                        }  
                        print("followings : ${cupit.profileNumbers["followings"]}");
                         print("followers : ${cupit.profileNumbers["followers"]}");
                      },
                      child: Text((isFollow=="f")?!(cupit.isEnglish) ?"الغاء المتابعه":"UnFollow me":!(cupit.isEnglish) ?"متابعه":"Follow me"),
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: (){
                          navigatorTo(context, ChatDataScreen(ChatModel.fromJasn( {
                            'uid': user.uId,
                            'name': user.name,
                            'image':user.image
                          })));
                        },
                      child: Text(!(cupit.isEnglish) ?"ارسل رساله":"Send Message"),
                      ),
                    ),

                  ],
                ),
                  
                  
                const SizedBox(height: 10,),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context,indix)=>const SizedBox(height: 5,),
                  itemBuilder:(context,indix)=>postItem(sc,
                    commentNum: 0,
                    liksNum: 0,
                    context: context,
                    post: cupit.myPosts[indix],
                    postId: cupit.myPostIds[indix],
                    isfav: true,
                    onchoosesTap: (){
                      sc.currentState!.showBottomSheet((context) {
                          return Container(
                            color: cupit.moodl?Colors.white:HexColor('333739'),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                 width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        cupit.addPostToFav(cupit.myPostIds[indix]);
                                      },
                                      child: Row(
                                        children: [
                                          const Icon( Icons.favorite , size: 20,color: mainColor,),
                                          const SizedBox(width: 5,),
                                          Text( !(cupit.isEnglish) ?"اضافه للمفضله":"Add to Favoret",style: Theme.of(context).textTheme.caption!. copyWith (color: mainColor, fontSize: 15),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                    }
                  ), 
                  itemCount: cupit.myPosts.length
                ),
              ],
              ),
            ),) :const Center(child:  CircularProgressIndicator())
          ),
        );
      }
    );
  }
}