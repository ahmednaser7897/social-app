import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_states.dart';

class EditProfScreen extends StatelessWidget {
  const EditProfScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCupit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCupit cupit = SocialCupit.get(context);
        TextEditingController nc =  TextEditingController();
        nc.text=cupit.userModel.name;
        TextEditingController bc =  TextEditingController();
        bc.text=cupit.userModel.bio;
        TextEditingController pc =  TextEditingController();
        pc.text=cupit.userModel.phone;
        var keyf = GlobalKey<FormState>();
        
        return Directionality(
          textDirection: (cupit.isEnglish) ?TextDirection.ltr:TextDirection.rtl,
          child: Scaffold(
            appBar: appBar(context: context, title:!(cupit.isEnglish) ?"تعديل الملف الشخصي":"Edit Profile", actions: [
              TextButton(onPressed: () {
                cupit.updateUser(name: nc.text, bio: bc.text, phone: pc.text);
              }, child: Text(!(cupit.isEnglish) ?"حفظ":"SAVE")),
              const SizedBox(
                width: 10,
              )
            ]),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Form(
                  key: keyf,
                  child: Column(
                    children: [
                      if(state is LodingGetUserData)
                      const LinearProgressIndicator(),
                      const SizedBox(height: 5,),
                      SizedBox(
                        height: 180,
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image:(cupit.coverImage==null)?
                                                NetworkImage(cupit.userModel.cover)
                                                :FileImage(cupit.coverImage!) as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft:  Radius.circular(5),
                                            topRight:  Radius.circular(5),
                                          ))),
                                  IconButton(
                                    onPressed: () {cupit.getCoverImage();},
                                    icon: const CircleAvatar(
                                        backgroundColor: mainColor,
                                        child:  Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.white,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              alignment: AlignmentDirectional.bottomStart,
                              children: [
                                CircleAvatar(
                                  radius: 61,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage:
                                    (cupit.profileImage==null)?
                                        NetworkImage(cupit.userModel.image)
                                        :FileImage(cupit.profileImage!)as ImageProvider,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {cupit.getProfileImage();},
                                  icon: const CircleAvatar(
                                      backgroundColor: mainColor,
                                      child:  Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      if(cupit.profileImage!=null||cupit.coverImage!=null)
                      Row(children: [
                        if(cupit.profileImage!=null)
                        Expanded(child: Column(
                          children: [
                            MaterialButton(onPressed:(){
                              cupit.uplodeProfileImage(name: nc.text, bio: bc.text, phone: pc.text);
                            },color: mainColor,child: Text(!(cupit.isEnglish) ?"رفع صوره شخصيه":"upload profile"),),
                            const SizedBox(height: 5,),
                             if(state is LodingGetUserData)
                            const LinearProgressIndicator(),
                          ],
                        )),
                        const SizedBox(width: 5,),
                        if(cupit.coverImage!=null)
                        Expanded(child: Column(
                          children: [
                            MaterialButton( minWidth: double.infinity, onPressed:(){
                              cupit.uplodeCoverImage(name: nc.text, bio: bc.text, phone: pc.text);
                            },color: mainColor,child: Text(!(cupit.isEnglish) ?"رفع صوره غلاف":"upload cover"),),
                            const SizedBox(height: 5,),
                             if(state is LodingGetUserData)
                            const LinearProgressIndicator(),
                          ],
                        )),
                      ],),
                      if(cupit.profileImage!=null||cupit.coverImage!=null)
                      const SizedBox(height: 10,),
                      TextFormField(
                         style: TextStyle(color: cupit.moodl?Colors.black:Colors.white),
                        decoration: InputDecoration(
                          prefixStyle: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold,),
                          border: const OutlineInputBorder(),
                          labelText: !(cupit.isEnglish) ?"الاسم":"name",
                          labelStyle: const TextStyle(color:mainColor,fontWeight: FontWeight.bold,fontSize: 20) ,
                          prefixIcon: const Icon(Icons.person,color: mainColor,),
                        ),
                        controller: nc,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) return !(cupit.isEnglish) ?"يحب وجود اسم":"Name must not be empty";
                          return null;
                        },
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        style: TextStyle(color: cupit.moodl?Colors.black:Colors.white),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: !(cupit.isEnglish) ?"الحاله":"Bio",
                          labelStyle: const TextStyle(color:mainColor,fontWeight: FontWeight.bold,fontSize: 20) ,
                          prefixStyle: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold,),
                          prefixIcon: const Icon(Icons.short_text_outlined,color: mainColor,),
                        ),
                        controller: bc,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) return !(cupit.isEnglish) ?"يجب وجود حاله":"Bio must not be empty";
                          return null;
                        },
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                         style: TextStyle(color: cupit.moodl?Colors.black:Colors.white),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: !(cupit.isEnglish) ?"الرقم":"Number",
                         labelStyle: const TextStyle(color:mainColor,fontWeight: FontWeight.bold,fontSize: 20) ,
                         prefixStyle: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold,),
                          prefixIcon: const Icon(Icons.phone,color: mainColor,),
                        ),
                        controller: pc,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return !(cupit.isEnglish) ?"يجب وجود رقم":"Number must not be empty";
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
