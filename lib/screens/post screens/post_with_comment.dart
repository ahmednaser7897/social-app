import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_states.dart';
import 'package:social_app/shared/models/post_model.dart';

// ignore: must_be_immutable
class PostWithCommentScreen extends StatelessWidget {
  PostModel post;
  String liksNum;
  String commentNum;
  String postId;
  int indix;
  var tc = TextEditingController();
  var sc = GlobalKey<ScaffoldState>();
   PostWithCommentScreen({Key? key, required this.post,required this.liksNum,required this.commentNum,required this.postId,required this.indix}) : super(key: key) ;
  @override
  Widget build(BuildContext context) {
    return Builder(
    builder: (context){
       SocialCupit.get(context).getComments(postId);
      return BlocConsumer<SocialCupit,SocialState>( 
        listener:(context,state){},
        builder: (context,state){
          SocialCupit cupit=SocialCupit.get(context);
          return Directionality(
            textDirection: (cupit.isEnglish) ?TextDirection.ltr:TextDirection.rtl,
            child: Scaffold(
              key: sc,
              appBar: AppBar(),
              body: //(cupit.comments.length!=0)?     
                  Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                postItem(sc,
                                  commentNum:cupit.commentsNum[indix].toString(),
                                  liksNum: cupit.likesNum[indix].toString(),
                                  post: post,
                                  postId: postId,
                                  context: context,
                                  isShowComments: true,
                                  indix: indix
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context,indix)=>commentItem(
                                      context,
                                      cupit.comments[indix].image,
                                      cupit.comments[indix].name,
                                      cupit.comments[indix].text,
                                      cupit.commentId[indix],
                                       cupit.comments[indix].uId,
                                    ),
                                    separatorBuilder: (context,indix)=>const SizedBox(height: 20,),
                                    itemCount: cupit.comments.length
                                  ),
                                ),
                               ],
                            ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                          children: [
                            Expanded(
                              child: Scrollbar(
                                thickness: 3,
                                child: TextFormField(
                                  style: TextStyle(color: cupit.moodl?Colors.black:Colors.white),
                                  controller: tc,
                                  maxLines: 4,
                                  minLines: 1,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      border: InputBorder.none, hintText:!(cupit.isEnglish) ?"اكتب تعليقا": "write comment", 
                                      hintStyle: TextStyle(color: cupit.moodl?Colors.black:Colors.white),
                                      labelStyle:const TextStyle(color: mainColor),
                                      hintMaxLines: 1),
                                ),
                              ),
                            ),
                            FloatingActionButton(
                            mini: true,
                            onPressed:(){
                              cupit.setComment(
                                i: indix,
                                postId: postId,
                                name: cupit.userModel.name,
                                uId: uId,
                                image: cupit.userModel.image,
                                text: tc.text
                              );
                              tc.text="";
                            },
                            elevation: 0,
                            child: const Icon(Icons.send ,color: Colors.white,size: 25,),
                            backgroundColor: mainColor,
                            ),
                          ],
                          ),
                        ),
                      )       
                    ],
                  )//:Center(child: CircularProgressIndicator(),), 
            ),
          );
        },
      );
    
    },
    );
  }
  Widget commentItem(context,image,name,text,commentId,commentPersonId){
    SocialCupit cupit=SocialCupit.get(context);
    return  InkWell(
      onLongPress: (){
        if(commentPersonId==uId) {
          sc.currentState!.showBottomSheet((context) {
          return Container(
            color: !cupit.moodl?HexColor('333739'):Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        cupit.deleteComment(postId,commentId,indix);
                      },
                      child: Row(                  
                        children: [
                          const Icon(Icons.delete, size: 20,color: mainColor,),
                          const SizedBox(width: 5,),
                          Text( !(cupit.isEnglish) ?"امسح التعليق":"Delete Comment",style: Theme.of(context).textTheme.caption!. copyWith (color: mainColor, fontSize: 15),),
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
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage:  NetworkImage(image),
          ),
          const SizedBox(width: 5,),
          Expanded(
            child:
            Container(
              decoration: BoxDecoration(
                color:!cupit.moodl? Colors.grey[900]:Colors.white,
                border: Border.all(),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,style: TextStyle(height: 1.2,fontSize: 17,color: cupit.moodl?Colors.black:Colors.white)),
                    Text(text,style:Theme.of(context).textTheme.subtitle1!.copyWith(color: cupit.moodl?Colors.black:Colors.white),),
                ],),
              ),
            ),
          ), 
        ],
      ),
    );        
  }
}
          
 