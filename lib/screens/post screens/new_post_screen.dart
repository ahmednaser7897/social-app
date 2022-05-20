import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:intl/intl.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_states.dart';

// ignore: must_be_immutable
class NewPostScreen extends StatelessWidget {
  bool isPost;
  NewPostScreen({Key? key, required this.isPost}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCupit, SocialState>(
        listener: (context, state) {},
        builder: (context, state) {
          var tc = TextEditingController();
          SocialCupit cupit = SocialCupit.get(context);
          return  Directionality(
            textDirection: (cupit.isEnglish) ?TextDirection.ltr:TextDirection.rtl,
            child: Scaffold(
                appBar: appBar(
                    context: context,
                    actions: [
                      TextButton(
                        child: Text(
                          isPost?
                          !(cupit.isEnglish) ?"اضف منشور":"Post":!(cupit.isEnglish) ?"اضافه قصه":"Add story",
                        ),
                        onPressed: () {
                          if(isPost){
                            if (cupit.postImage == null) {
                              cupit.craetePost(
                                text: tc.text).then((value) {
                                  cupit.getPosts();
                                  Navigator.pop(context);
                                });
                            } else {
                              cupit.uploadPost(
                                  text: tc.text,
                              ).then((value) {
                                    cupit.getPosts();
                                    Navigator.pop(context);
                              });
                            }
                          }else{
                            if (cupit.storyImage == null) {
                              cupit.craeteStory(text: tc.text).then((value) {
                                
                                    Navigator.pop(context);
                              });
                            } else {
                              cupit.uploadStory(text: tc.text,).then((value) {
                                Navigator.pop(context);
                              });
                          }
                          }
                          
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                    title:isPost?!(cupit.isEnglish) ?"انشاء منشور": "Create post":!(cupit.isEnglish) ?"انشاء قصه":"Create Story"),
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(cupit.userModel.image),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      cupit.userModel.name,
                                      style: const TextStyle(height: 1.2),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(
                                      Icons.check_circle,
                                      color: mainColor,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(!(cupit.isEnglish) ?"عام":
                                  "Public",
                                  style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    !.copyWith(height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                          child: TextFormField(
                            controller: tc,
                            style: TextStyle(color: cupit.moodl?Colors.black:Colors.white),
                            decoration: InputDecoration(
                              hintText:!(cupit.isEnglish) ?"بماذا تفكر  ${cupit.userModel.name}":
                                "What is in your mind , ${cupit.userModel.name}",
                                hintStyle: TextStyle(color: cupit.moodl?Colors.black:Colors.white),
                              border: InputBorder.none,
                            ),
                          )),
                      const SizedBox(height: 20,),
                      if(cupit.postImage!=null||cupit.storyImage!=null)
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:isPost? FileImage(cupit.postImage!):FileImage(cupit.storyImage!),   
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft:  Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ))),
                          IconButton(
                            onPressed: () {
                              if(isPost){
                                cupit.removePostImage();
                              }else{
                                cupit.removeStoryImage();
                              }
                              
                            },
                            icon: const CircleAvatar(
                                backgroundColor: mainColor,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                if(isPost){
                                  cupit.getpostImage();
                                }else{
                                  cupit.getStoryImage();
                                }
                                
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.photo_camera,
                                    size: 20,
                                    color: mainColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(!(cupit.isEnglish) ?"اضف صوره":
                                    "Add Photos",
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        !.copyWith(color: mainColor, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                    ],
                  ),
                ),
            ),
          );
        });
  }
}
