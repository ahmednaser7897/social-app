// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/screens/social%20screens/profile.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/models/post_model.dart';


const mainColor = Colors.purple;
var lihghtTheme = ThemeData(
    primarySwatch: mainColor,
    fontFamily: "janna",
    cardTheme: const CardTheme(color: Colors.white),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      iconTheme:  IconThemeData(color: Colors.black, size: 20),
      systemOverlayStyle:  SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 20,
      titleTextStyle:  TextStyle(
          color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: mainColor,
      type: BottomNavigationBarType.fixed,
      elevation: 30,
      backgroundColor: Colors.white,
    ),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: HexColor('333739')),
    textTheme: const TextTheme(
        bodyText1: TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
        bodyText2: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
    iconTheme: const IconThemeData(color: Colors.black));

var darkTheme = ThemeData(
     cardTheme: CardTheme(color: HexColor('333739')),
    primarySwatch: mainColor,
    fontFamily: "janna",
    iconTheme: const IconThemeData(color: Colors.white),
    scaffoldBackgroundColor: HexColor('333739'),
    appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: HexColor('333739'),
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: HexColor('333739'),
        elevation: 0,
        titleSpacing: 20,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.white, size: 20)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: mainColor,
       backgroundColor: HexColor('333739'),
       
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
     
      elevation: 30,
    ),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.white),
    textTheme: const TextTheme(
        bodyText1:  TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        bodyText2:  TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)));

Widget slider(context) {
  return Padding(
    padding: const EdgeInsetsDirectional.only(end: 20),
    child: Column(
      children: [
        const SizedBox(height: 5),
        Container(
          height: 0.5,
          color: mainColor,
        ),
        const SizedBox(height: 5)
      ],
    ),
  );
}

void navigatorTo(context, widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void navigatorAndEnd(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false,
    );

void showToast(String message, States state) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: stateColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

// ignore: constant_identifier_names
enum States { SUCCESS, ERORR, WARNING }
Color stateColor(States state) {
  Color color;
  switch (state) {
    case States.SUCCESS:
      color = Colors.blue;
      break;
    case States.ERORR:
      color = Colors.red;
      break;
    case States.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
String ?uId='';

AppBar appBar({required String title,required context,required List <Widget>actions})=> AppBar(
  title: Text(title),
  actions: actions,
  titleSpacing: 0,
  leading: IconButton(onPressed: (){
    Navigator.pop(context);
  },
   icon: const Icon(Icons.keyboard_arrow_left)
   ) ,
);

Widget emptyPage(icon,String text)=>Center(
  child:Column( mainAxisAlignment: MainAxisAlignment.center,
    children: [ Icon(icon ,size: 50,) , const SizedBox(height: 20,),
      Text(text,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 30),)
    ],
  ),
);

Widget divider = const Padding(
  padding: EdgeInsets.symmetric(vertical: 10),
  child: Divider(height: 0.8,color: Colors.grey,),
);   

Widget postItem(sc,{required PostModel post,liksNum,commentNum,context,postId,
 Function ?onCommentTap,bool isShowComments=false, Function ?onchoosesTap,isfav=false, indix}){
    SocialCupit cupit= SocialCupit.get(context);
    return Card(
      clipBehavior:Clip.antiAliasWithSaveLayer ,
      elevation: 5,
      margin: const EdgeInsetsDirectional.all(5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          //post header 
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(post.image),
                ),
                const SizedBox(width: 5,),
                Expanded(child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    InkWell(
                      onTap: (){
                        cupit.getOnePerson(post.uId).then((value) {
                           navigatorTo(context, ProfilegScreen(user: value));
                        });
                      },
                      child: Row(children: [
                        Text(post.name,style: TextStyle(height: 1.2,color: cupit.moodl?Colors.black:Colors.white),),
                        const SizedBox(width: 5,),
                        const Icon(Icons.check_circle,color: mainColor,size: 16,),
                      ],),
                    ),
                    const SizedBox(height: 5,),
                    Text(post.date,style:Theme.of(context).textTheme.caption!.copyWith(height: 1.4,color: cupit.moodl?Colors.black:Colors.white),),
                  ],),
                ),
                IconButton(onPressed:(() => onchoosesTap),icon: const Icon(Icons.more_horiz,size: 16,),) 
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 0.8,color: Colors.grey,),
            ),
           //post text
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                post.text,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(height: 1.3,color: cupit.moodl?Colors.black:Colors.white),),
            ),
          //post image
            if(post.postImage!="")
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                onTap: (){
                  sc.currentState.showBottomSheet((context) =>Container(
                    color: cupit.moodl?Colors.white:HexColor('333739'),
                  height: double.infinity,
                  width: double.infinity,
                  alignment: AlignmentDirectional.center,
                  child: Image(image:NetworkImage(post.postImage),fit: BoxFit.cover,
                        loadingBuilder: (context, child,ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return  const SizedBox(height: 150, child: Center(child: CircularProgressIndicator()));
                        },  
                      ),) ,
                  );  
                },
                child: Container(
                  height: 140,width:double.infinity ,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: Hero(
                      tag:postId ,
                      child: Image(image:NetworkImage(post.postImage),fit: BoxFit.cover,
                        loadingBuilder: (context, child,ImageChunkEvent ?loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(height: 150, child: Center(child: CircularProgressIndicator()));
                        },  
                      ),
                      ),
                  ),
              ),
            ),
            //like and comment numbers row
            if(!isfav)
            Row(children: [
              Expanded(child: InkWell(
                onTap: (){},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(children: [
                    const Icon(Icons.favorite_border_outlined,size: 15,),
                    const SizedBox(width: 5,),
                    Text(liksNum.toString(),style: Theme.of(context).textTheme.caption!.copyWith(color: !cupit.moodl?Colors.white:Colors.black),),
                  ],),
                ),
              )),
              
              Expanded(child: InkWell(
                  onTap: (){},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      const Icon(Icons.message_rounded,size: 15,),
                    const SizedBox(width: 5,),
                    Text(commentNum.toString(),style: Theme.of(context).textTheme.caption!.copyWith(color: !cupit.moodl?Colors.white:Colors.black),),
              ],),
                  ),
                )),
            
            ],),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child:  Divider(height: 0.8,color: Colors.grey,),
            ),

            //add like and comment row
            Row(children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(cupit.userModel.image),
              ),
              const SizedBox(width: 10,),
              if(!isShowComments)
              InkWell(
                onTap:(() =>onCommentTap ) ,
                child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(!(cupit.isEnglish) ?"اكتب تعليقا...":"Write comment...",style: Theme.of(context).textTheme.caption!.copyWith(color: !cupit.moodl?Colors.white:Colors.black),),
              )),
              const Spacer(),
              InkWell(
                onTap: (){
                  cupit.isliked(postId).then((value) {
                    print(value);
                    if(value=="l"){
                      cupit.setLikes(postId,indix: indix);
                    }
                      
                    else if(value=="d") {
                      cupit.delLikes(postId,indix: indix);
                    }
                  });   
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(children: [
                    Icon(Icons.favorite_border,size: 15,
                    color:post.isLiked?Colors.red:Colors.grey),
                    const SizedBox(width: 5,),
                    Text(!(cupit.isEnglish) ?"اعجاب":"Like",style: Theme.of(context).textTheme.caption!.copyWith(color: !cupit.moodl?Colors.white:Colors.black),),
                  ],),
                ),
              ),
               
            ],),
            const SizedBox(height: 10,)
          ],
        ),
      ),
    ); 
  }
