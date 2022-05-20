import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/social%20screens/profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/chat%20cuipt/chat_cuipt.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_states.dart';
import 'package:social_app/shared/models/loge%20in%20models.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget{
  var searchC=TextEditingController();
  var keyf = GlobalKey<FormState>();
  late ChatCupit cupit1 ;

  SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCupit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        cupit1 = ChatCupit.get(context);
        SocialCupit cupit=SocialCupit.get(context);
          return Directionality(
            textDirection: (cupit.isEnglish) ?TextDirection.ltr:TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Form(
                      key: keyf,
                      child: TextFormField( 
                        onChanged: (value){
                          cupit.searchByName(value);
                        },              
                        controller: searchC, keyboardType: TextInputType.text,
                        validator: (value){
                        if(value!.isEmpty) {
                          return (cupit.isEnglish)?"Fild must not be embty":"اكتب شيا للبحث";
                        } else {
                          return null;
                        }},
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          border:const OutlineInputBorder() ,
                          labelText:!(cupit.isEnglish)?"بحث" : "Search",
                          labelStyle: const TextStyle(color:mainColor,fontWeight: FontWeight.bold,fontSize: 15) ,
                          prefixStyle: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold,),
                          prefixIcon:const Icon(Icons.search,color:mainColor,size: 20,) ,
                          
                        ),
                      ), 
                    ),
                    const SizedBox(height: 10,),
                    (state  is LodingSearch)?
                    const Expanded(child: Center(child:  CircularProgressIndicator())):
                    Expanded(
                      child:
                      ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context,index)=>searshedItem(cupit.searchedUsers[index],context),
                      separatorBuilder: (context,index)=>const SizedBox(height: 10,),
                      itemCount:cupit.searchedUsers.length,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
  Widget searshedItem(UserModel user,context){
    return InkWell(
      onTap: (){
        navigatorTo(context, ProfilegScreen(user: user));
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(user.image),
          ),
          const SizedBox(width: 5,),
          Expanded(child: Text(user.name,style: const TextStyle (height: 1.2),overflow: TextOverflow.clip,maxLines: 1,)),
          
          IconButton(icon:const Icon(Icons.message),
            onPressed: (){
              cupit1.sendMessage(message: "hi ${user.name}", resiverid: user.uId, date: DateTime.now().toString(),resiverimage: user.image,resivername: user.name);
            },
          ),
        ],
      ),
    );  
  }
}