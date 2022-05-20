// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/screens/login%20screen/social_login_screen.dart';
import 'package:social_app/screens/post%20screens/fav%20post.dart';
import 'package:social_app/screens/social%20screens/profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_states.dart';
import 'package:social_app/shared/shared_preferences/shared_preferences.dart';

import '../homePage.dart';
import 'follow.dart';

// ignore: must_be_immutable
class SettingScreen extends StatelessWidget{
  SettingScreen({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCupit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCupit cupit=SocialCupit.get(context);
        String selected = (cupit.isEnglish) ? 'English' : 'عربي';
        List<DropdownMenuItem<String>> langs = [
        DropdownMenuItem(
            value: 'English',
            child: Text(
              'English',
              style: Theme.of(context).textTheme.bodyText1,
            )),
        DropdownMenuItem(
            value: 'عربي',
            child: Text(
              'عربي',
              style: Theme.of(context).textTheme.bodyText1,
            )),
      ];
        return (cupit.posts.isNotEmpty&&cupit.userModel.uId!="null")?
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                  InkWell(
                  onTap: (){
                    navigatorTo(context, ProfilegScreen(user: cupit.userModel));
                  },
                  child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(cupit.userModel.image),
                            ),
                            const SizedBox(width: 5,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(cupit.userModel.name,style: const TextStyle (height: 1.2),),
                                  const SizedBox(width: 5,),
                                  Text(!(cupit.isEnglish)?"عرض الملف الشخصي" :"show profile",style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 15,color: cupit.moodl?Colors.black:Colors.white)),   
                                ],
                              ),
                            ), 
                          ],
                        ),
                ),
                divider,
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context,indix)=>
                  item(itemIcons[indix],cupit.isEnglish?itemNames[indix][0]:itemNames[indix][1], itemWidgets[indix], context),
                  separatorBuilder: (context,indix)=>const SizedBox(height: 5,),
                    itemCount: itemNames.length
                ),
                const SizedBox(height: 10,),
                Row(children: [
                  Text(!(cupit.isEnglish)?"الوضع الليلي" :"Dark Mood"),
                  const Spacer(),
                  Switch(
                    value: cupit.moodl,
                    onChanged: (value){
                      cupit.changMood(value);
                    },
                  )
                ],),
                Row(
            children: [
               Text(!(cupit.isEnglish)?"اللغه" :
                'language',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(
                width: 20,
              ),
               DropdownButton<String>(
                  dropdownColor: cupit.moodl ? Colors.white : HexColor('333739'),
                  items: langs,
                  onChanged: (value) {
                    if (value == selected) {
                    } else{
                      cupit.changLang(!cupit.isEnglish);
                    }
                      
                  },
                  value: selected,
                  underline: Container( height: 2,color:Colors.purple),
                ),
              ],
            ),
                const SizedBox(height: 10,),
                MaterialButton(onPressed: (){
                CachHelper.removeData(key: "uid").then((value) {
                  changeMyState(false).then((value){
                    cupit.changBottomBarIndix(0).then((value){
                      cupit.emptyUserData();
                      uId="";
                      FirebaseAuth.instance.signOut();
                      navigatorAndEnd(context, const SocialLogIn());
                    });
                   
                  });
                }).catchError((onError){
                  print('erorr from LOGOUT is ${onError.toString()}');
                }); 
                },color: mainColor,minWidth: double.infinity,child: Text(!(cupit.isEnglish)?"تسجيل الخروج" :"loge out",style: const TextStyle(color: Colors.white),),
              )
                ,const SizedBox(height: 10,),
            ],
        ),),):const Center(child: CircularProgressIndicator(),);
      }
    );
  }
  List itemNames=[["FavPosts","المنشورات المفضله"],["Followings","المتابعون"],["Followers","المتابعين لك"],];
  List<Widget> itemWidgets=[FavPosts(), const FollowScreen(type: "fing"), const FollowScreen(type:"fer")];
  List itemIcons=[Icons.favorite,Icons.follow_the_signs_outlined,Icons.follow_the_signs_outlined];
  
  Widget item(icon,String text,Widget widget,context,){
     SocialCupit cupit=SocialCupit.get(context);
    return InkWell(
      onTap: (){
        if(text=="Followings"||text=="المتابعون"){
          cupit.getfollowings().then((value){
             navigatorTo(context, widget);
          });
        }else if(text=="Followers"||text=="المتابعين لك"){
          cupit.getfollowers().then((value){
             navigatorTo(context, widget);
          });
        }else{
          navigatorTo(context, widget);
        }
        
      },
      child: Row(
        children: [
          Icon(icon,size: 30,),
          const SizedBox(width: 10,),
          Text(text,style: Theme.of(context).textTheme.headline6!.copyWith(height: 1.8,color: cupit.moodl?Colors.black:Colors.white)), 
        ],
      ),
    );
  }
}