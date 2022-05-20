// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/chat%20screen/pdf%20view.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/chat%20cuipt/chat_cuipt.dart';
import 'package:social_app/shared/cubit/chat%20cuipt/chat_stats.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// ignore: must_be_immutable
class ShowFaverMessage extends StatelessWidget{
  var sc = GlobalKey<ScaffoldState>();
  final GlobalKey<SfPdfViewerState> pc = GlobalKey();

  ShowFaverMessage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ChatCupit.get(context).getFavMessages();
     
    return BlocConsumer<ChatCupit,ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
         ChatCupit cupit =ChatCupit.get(context);
         SocialCupit cupit1=SocialCupit.get(context);
          return Directionality(
            textDirection: (cupit1.isEnglish) ?TextDirection.ltr:TextDirection.rtl,
            child: Scaffold(
              key: sc,
              appBar: AppBar(title: Text(!(cupit1.isEnglish) ?"الرسائل المفضله":"Favorite messages"),),
              body: (cupit.favMessages.isNotEmpty)?
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                  itemBuilder: (context, indix) {
                    if (cupit.favMessages[indix].sId == uId) {
                      return message(cupit.favMessages[indix].text,cupit.favMessages[indix].image,
                       cupit.favMessages[indix].file,  AlignmentDirectional.centerEnd, mainColor.withOpacity(0.3),context,indix,end: const Radius.circular(0),stsrt: const Radius.circular(10),);
                    } else {
                      return message(cupit.favMessages[indix].text,cupit.favMessages[indix].image,cupit.favMessages[indix].file,  AlignmentDirectional.centerStart, Colors.grey,context,indix,end: const Radius.circular(10),stsrt: const Radius.circular(0),);
                    } 
                  },
                   separatorBuilder: (context, indix) => const SizedBox(height: 5,),
                  itemCount: cupit.favMessages.length,
                ),
              ):emptyPage(Icons.favorite, !(cupit1.isEnglish) ?"فارغ":"empt"),
              
            ),
          );
        },
    );
  }
  Widget message(String text,String image,file,alignment,color,context,indix,{end,stsrt}) {
   ChatCupit cupit =ChatCupit.get(context);
   SocialCupit cupit1=SocialCupit.get(context);
   print(file);
    return Align(
      alignment: alignment,
      child: InkWell(
        onLongPress: (){
           sc.currentState!.showBottomSheet((context) {
            return Padding(
                padding: const EdgeInsets.all(10.0),
                // ignore: sized_box_for_whitespace
                child: Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                      onPressed: () {
                        cupit.removeFromFav(cupit.favMessagesId[indix]);
                        // Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.delete, size: 20,color: mainColor,),
                          const SizedBox(width: 5,),
                          Text(!(cupit1.isEnglish) ?"ازاله من المفضله": "Delete from faver",style: Theme.of(context).textTheme.caption!. copyWith (color: mainColor, fontSize: 15),),
                        ],
                      ),
                    ),

                  ],),
                ),
            );
             }).closed.then((value) => Navigator.pop(context));
        },
        onTap: (){    
          if(image!=""){
            sc.currentState!.showBottomSheet((context) =>Container(
            height: double.infinity,
            width: double.infinity,
            alignment: AlignmentDirectional.center,
            child: Image(image: NetworkImage(image),)) ,
            );  
          } 
          if(file!=""){
            print("file is here $file");
            navigatorTo(context, Pdf(file));
          }        
        },
        child:Container(
             width:200,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: 
              BoxDecoration(
                color:color,
                borderRadius: BorderRadiusDirectional.only(
                    bottomEnd: end,
                    bottomStart:stsrt ,
                    topEnd: const Radius.circular(10),
                    topStart: const Radius.circular(10))
              ),
            child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(image!="")
                  Image(image: NetworkImage(image),
                   loadingBuilder: (context, child,
                      ImageChunkEvent ?loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(height: 150, child: Center(child: CircularProgressIndicator()));
                  },       
                  ),
                   if(file!="")
                  SizedBox(
                    height: 100,
                    child: SfPdfViewer.network(file, key: pc,)
                  ),
                  Text(text),
                ],
              ),
          ),
        ),
    );
  }

}