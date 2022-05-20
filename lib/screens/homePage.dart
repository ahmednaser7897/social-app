// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/screens/post%20screens/new_post_screen.dart';
import 'package:social_app/screens/social%20screens/search.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_states.dart';

import 'chat screen/faver meassage.dart';
 var sc = GlobalKey<ScaffoldState>();
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}
 changeMyState(bool state)async{
    await  FirebaseFirestore.instance.collection("users").doc(uId).update({
      "state":state
    });
}
class HomeState extends State<MyHomePage> with WidgetsBindingObserver{
   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    changeMyState(true);
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      changeMyState(true);
    } else {
      changeMyState(false);
    }
  }
  
  @override
  void dispose() {
    super.dispose();
    changeMyState(false);
  }
  
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<SocialCupit, SocialState>(
        listener: (context, state) {},
        builder: (context, state) {
          SocialCupit cupit=SocialCupit.get(context);
          return 
          Directionality(
            textDirection: (cupit.isEnglish) ?TextDirection.ltr:TextDirection.rtl,
            child: Scaffold(
              key: sc,
              appBar: AppBar(
                title: Text((cupit.isEnglish) ?cupit.titls[cupit.indix][0]:cupit.titls[cupit.indix][1]),
                actions: [
                  if(cupit.titls[cupit.indix][0]=="Chats")
                    Row(
                    children: [
                      PopupMenuButton( 
                        color: !cupit.moodl?HexColor('333739'):Colors.white,           
                        onSelected: (value){
                          if(value=="v") {
                            navigatorTo(context, ShowFaverMessage());
                          }
                        },
                        itemBuilder: (context){
                        return [
                          PopupMenuItem(value: "v",child: Text(!(cupit.isEnglish)?"المفضله" :"Show Favorite",style: TextStyle(color:cupit.moodl?Colors.black:Colors.white, ),),),
                          
                        ];},
                      ),
                    ],
                  ), 
                  if(cupit.titls[cupit.indix][0]=="Home")
                    IconButton(onPressed: () {navigatorTo(context, NewPostScreen(isPost: true,));},
                    icon:Icon(Icons.post_add_outlined,color: !cupit.moodl?Colors.white:Colors.black,)),
                  if(cupit.titls[cupit.indix][0]!="Chats")
                    IconButton(onPressed: () {navigatorTo(context, SearchScreen());},icon: const Icon(Icons.search)),
                  ],

              ),
              body:cupit.screens[cupit.indix],
              //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              /*floatingActionButton:FloatingActionButton(
                backgroundColor:cupit.moodl?Colors.white:Colors.black,
                mini: true,
                elevation: 10,
                onPressed:(){navigatorTo(context, NewPostScreen(isPost: true,));},
                child: Icon(Icons.post_add_outlined,color: !cupit.moodl?Colors.white:Colors.black,),
              ) ,*/
              bottomNavigationBar: BottomAppBar(
                shape: const CircularNotchedRectangle(),
                child: BottomNavigationBar(
                  currentIndex: cupit.indix,
                  onTap: (value)=>cupit.changBottomBarIndix(value,context: context),
                  items: [
                    BottomNavigationBarItem(icon: const Icon(Icons.home_outlined),label:!(cupit.isEnglish)?"الاحداث" : "Feed"),
                    BottomNavigationBarItem(icon: const Icon(Icons.chat_outlined),label:!(cupit.isEnglish)?"المحادثات" : "Chat"),
                    //BottomNavigationBarItem(icon: Icon(Icons.notification_important),label:!(cupit.isEnglish)?"الاشعارات" : "Notifications"),
                    BottomNavigationBarItem(icon: const Icon(Icons.settings_applications),label: 
                    !(cupit.isEnglish)?"الاعدادات" :"Settings"),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }
}