import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/screens/post%20screens/post_with_comment.dart';
import 'package:social_app/screens/story%20screens/story%20screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_states.dart';
import 'package:social_app/shared/models/story%20model.dart';

import '../homePage.dart';
import '../post screens/new_post_screen.dart';

class FeedScreen extends StatelessWidget{
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCupit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCupit cupit=SocialCupit.get(context);
        return (cupit.posts.isNotEmpty&&cupit.userModel.uId!="")?
        RefreshIndicator(
          onRefresh: ()async{
            cupit.getPosts();
          },
          child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          InkWell(
                            onTap: (){navigatorTo(context, NewPostScreen(isPost: false,));},
                            child: SizedBox(
                              width: 70,
                              child: Column(
                                children: [
                                  const CircleAvatar(radius: 25,child: Icon(Icons.add),),
                                  Text(!(cupit.isEnglish) ?"اضف قصه":"add story",style: const TextStyle(fontSize: 15),overflow: TextOverflow.ellipsis,maxLines:1,),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context,indix){
                              return
                              storyItemData(
                                myStory: cupit.userStorys[indix],context: context, 
                                indix: indix 
                              );
                            },
                            separatorBuilder: (context,indix)=>const SizedBox(width: 10,), 
                            itemCount:cupit.userStorys.length
                          ),
                        ],
                      ),
                    ),
                  ),
                ),            
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context,indix)=>
                    postItem( sc,
                      context: context,
                      post: cupit.posts[indix],
                      liksNum: cupit.likesNum[indix],
                      commentNum:cupit.commentsNum[indix],
                      postId: cupit.postIds[indix],
                      indix: indix,
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
                                        cupit.addPostToFav(cupit.postIds[indix]);
                                      },
                                      child: Row(
                                        
                                        children: [
                                          const Icon(Icons.favorite, size: 20,color: mainColor,),
                                          const SizedBox(width: 5,),
                                          Text(!(cupit.isEnglish) ?"اضف للمفضله": "Add to Favoret",style: Theme.of(context).textTheme.caption!. copyWith (color: mainColor, fontSize: 15),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                      },
                      onCommentTap: (){
                        navigatorTo(context, PostWithCommentScreen(
                          post: cupit.posts[indix],
                          commentNum: cupit.commentsNum[indix].toString(),
                          liksNum: cupit.likesNum[indix].toString(),
                          postId: cupit.postIds[indix],
                          indix: indix,
                        ));
                      }
                      ),
                     separatorBuilder: (context,indix)=>const SizedBox(height: 5,), 
                    itemCount: cupit.posts.length)
                ],
            ),
          ),
        )
        :const Center(child:  CircularProgressIndicator(),);
      }
    );
  }

  Widget storyItemData({context,required UserStorys myStory,indix}){
    return InkWell(
      onTap:(){
        if(myStory.storys.isNotEmpty) {
          SocialCupit.get(context).getStoryItems(myStory, stc)
        .then((value) {
           navigatorTo(context, StoryScreen(myStory:myStory,indix: indix,));
        });
        }
      },
      child: SizedBox(
        width: 65,
        child: Column(
          children: [     
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                CircleAvatar(radius:25,backgroundImage: NetworkImage(myStory.user.image),),
                CircleAvatar(radius:10,child: Text(myStory.storys.length.toString(),style: const TextStyle(height: 1.5),),),
              ],
            ),
            Text(myStory.user.name,style: const TextStyle(fontSize: 15,height: 1),overflow: TextOverflow.ellipsis,maxLines:2,),
          ],
        ),
      ),
    );
  }  
}

