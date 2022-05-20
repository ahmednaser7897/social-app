// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_states.dart';

// ignore: must_be_immutable
class FavPosts extends StatelessWidget{
  var sc = GlobalKey<ScaffoldState>();

  FavPosts({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
     return Builder(
       builder: (context){
         SocialCupit.get(context).getFavPosts();
       return BlocConsumer<SocialCupit, SocialState>(
        listener: (context, state) {},
        builder: (context, state) {
          SocialCupit cupit=SocialCupit.get(context);
          return Directionality(
             textDirection: (cupit.isEnglish) ?TextDirection.ltr:TextDirection.rtl,
            child: Scaffold(
              key: sc,
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                  separatorBuilder: (context,indix)=>const SizedBox(height: 5,),
                  itemBuilder:(context,indix)=>postItem(sc,
                    commentNum: "0",
                    liksNum: "0",
                    context: context,
                    post: cupit.favPosts[indix],
                    postId: cupit.favPostsId[indix],
                    isfav: true,
                    onchoosesTap: (){
                      sc.currentState!.showBottomSheet((context) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                               width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      cupit.deletFromFav(cupit.postIds[indix]);
                                    },
                                    child: Row(
                                      
                                      children: [
                                        const Icon(Icons.favorite, size: 20,color: mainColor,),
                                        const SizedBox(width: 5,),
                                        Text( !(cupit.isEnglish) ?"ازاله من المفضله":"Delete from Favoret",style: Theme.of(context).textTheme.caption!. copyWith (color: mainColor, fontSize: 15),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      
                    }
                  ), 
                  itemCount: cupit.favPosts.length
                ),
              ),
            ),
          );
        });
    });
  }
}
