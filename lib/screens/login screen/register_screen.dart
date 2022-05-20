// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/login%20screen/social_login_screen.dart';
import 'package:social_app/screens/login%20screen/verScreen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/login cuipt/logein_states.dart';
import 'package:social_app/shared/cubit/login cuipt/login_cuoit.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/shared_preferences/shared_preferences.dart';


class  RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController email =  TextEditingController();
    TextEditingController pass =  TextEditingController();
    TextEditingController name =  TextEditingController();
    TextEditingController phone =  TextEditingController();
    var keyf = GlobalKey<FormState>();
    return BlocProvider<LoginCupit>(
      create: (context) => LoginCupit(),
      child: BlocConsumer<LoginCupit, LoginState>(
        listener: (context, state) { 
          if(state is ErrorRegiste) {
            showToast(state.error, States.ERORR);
          }
          if(state is ErrorCreateUser) {
            showToast(state.error, States.ERORR);
          }
          if(state is ErrorOccurred) {
            showToast(state.error, States.ERORR);
          }
          if(state is ErrorverifyUser) {
            showToast(state.error, States.ERORR);
          }
          if(state is ScCreateUser) {
            CachHelper.setData(key: "uid", value: state.uId).then((value) {
              uId=state.uId;
              navigatorTo(context, VerifyScreen(phone: phone.text,)); 
            });
          }
        }, 
        builder: (context, stste) {
          LoginCupit cupit=LoginCupit.get(context);
           SocialCupit cupit1 = SocialCupit.get(context);
          return Directionality(
            textDirection: (cupit1.isEnglish) ?TextDirection.ltr:TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Form(
                    key: keyf,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(!(cupit1.isEnglish) ?"انشاء حساب":"Register".toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                !.copyWith(color:  cupit1.moodl?Colors.black:Colors.white)),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(!(cupit1.isEnglish) ?"انشاء حساب للدخول في مجتمعنا":"Register to our Social app",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                !.copyWith(color: Colors.grey)),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          style: TextStyle(color: cupit1.moodl?Colors.black:Colors.white),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:!(cupit1.isEnglish) ?"الاسم": "Name",
                            labelStyle: const TextStyle(color:mainColor,fontSize: 20) ,
                            prefixIcon: const Icon(Icons.person,color: mainColor,),
                          ),
                          controller: name,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) return !(cupit1.isEnglish) ?"يجب وجود اسم": "Name must not be empty";
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          style: TextStyle(color: cupit1.moodl?Colors.black:Colors.white),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: !(cupit1.isEnglish) ?"البريد":"Email",
                              labelStyle: const TextStyle(color:mainColor,fontSize: 20) ,
                            prefixIcon: const Icon(Icons.email,color: mainColor,),
                          ),
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) return !(cupit1.isEnglish) ?"يجب وجود بريد":"email must not be empty";
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          style: TextStyle(color: cupit1.moodl?Colors.black:Colors.white),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: !(cupit1.isEnglish) ?"كلمه السر":"PassWord",
                              labelStyle: const TextStyle(color:mainColor,fontSize: 20) ,
                            prefixIcon: const Icon(Icons.lock,color:mainColor),
                            suffixIcon: IconButton(
                              icon: cupit.showPassr
                                  ? const Icon(Icons.visibility,color: mainColor,)
                                  : const Icon(Icons.visibility_off,color: Colors.grey,),
                              onPressed: () {
                                cupit.changeShowPassRegiste();
                              },
                            ),
                          ),
                          controller: pass,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: cupit.showPassr ? true : false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return !(cupit1.isEnglish) ?"يجب وجود كلمه سر":"password must not be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          style: TextStyle(color: cupit1.moodl?Colors.black:Colors.white),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: !(cupit1.isEnglish) ?"الهاتف":"phone",
                            labelStyle: const TextStyle(color:mainColor,fontSize: 20) ,
                            prefixIcon: const Icon(Icons.phone,color: mainColor,),
                          ),
                          controller: phone,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) return !(cupit1.isEnglish) ?"يجب وجود هاتف":"phone must not be empty";
                            if (value.length<11) return !(cupit1.isEnglish) ?"رقم غير صحيح":"not valid number";
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        
                        (stste is LodingRegiste ||stste is LodingCreateUser||stste is LodingverifyUser)?const Center(child: CircularProgressIndicator()):Container(
                          width: double.infinity,
                          color: Colors.blue,
                          child: MaterialButton(
                              child: Text(
                                !(cupit1.isEnglish) ?"انشاء حساب":"Registe",
                                style:
                                    const TextStyle(fontSize: 25, color: Colors.white),
                              ),
                              onPressed: () {
                                if(keyf.currentState!.validate()){
                                  cupit.verifyPhone2(phone: phone.text).then((value){
                                    cupit.registerLogin(email: email.text, pass: pass.text,phone:phone.text,name:name.text).then((value){
                                      print("going to verv screen");
                                    });
                                  }); 
                                }
                              }),
                        ),
                        TextButton(
                          child: Text(
                            !(cupit1.isEnglish) ?"لدي حساب بالفعل":"i have email".toUpperCase(),
                            style: const TextStyle(color: mainColor, fontSize: 15),
                          ),
                          onPressed: () {
                            navigatorTo(context, const SocialLogIn());
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
      ),
    );
  }
}