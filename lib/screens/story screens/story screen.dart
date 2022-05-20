// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_states.dart';
import 'package:social_app/shared/models/story%20model.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';


StoryController stc = StoryController();
// ignore: must_be_immutable
class StoryScreen  extends StatelessWidget {
  PageController pc=PageController();
  UserStorys myStory;
  int indix;
  StoryScreen({Key? key, required this.myStory, required this.indix}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context){
      return BlocConsumer<SocialCupit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCupit cupit=SocialCupit.get(context);
        return Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
           Material(
              type: MaterialType.transparency,
              child: StoryView(
                storyItems:cupit.storyItems,
                controller: stc,
                inline: true,    
                onComplete: (){
                  if(indix==cupit.userStorys.length-1){
                    //navigatorAndEnd(context, FeedScreen());
                    Navigator.pop(context);
                  } 
                  else {
                    Navigator.pop(context);
                  }
                 // navigatorTo( context, StoryScreen(indix: indix+1,myStory: cupit.userStorys[indix+1],) );
                },
                onVerticalSwipeComplete: (direction) {
                  if (direction == Direction.down) {
                    Navigator.pop(context); 
                    //navigatorAndEnd(context, FeedScreen());
                  }
                }
              ),
            ),
             Material(
                type: MaterialType.transparency,
               child: Container(
                 padding: const EdgeInsetsDirectional.only(top: 50,start: 10),
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(myStory.user.image),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Row(children: [
                          Text(myStory.user.name,style: const TextStyle(height: 1.2,color: Colors.white),),
                          const SizedBox(width: 5,),
                          const Icon(Icons.check_circle,color: mainColor,size: 16,),
                        ],),
                      const SizedBox(height: 5,),
                      Text("",style:Theme.of(context).textTheme.caption!.copyWith(height: 1.4,color: Colors.white),),
                    ],),
                  ),
                  
            ],
          ),
               ),
             ),
            
          ],
        );
        });
    }); 
  }
}
