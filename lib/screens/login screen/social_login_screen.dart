import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/login%20screen/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/login cuipt/logein_states.dart';
import 'package:social_app/shared/cubit/login cuipt/login_cuoit.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/shared_preferences/shared_preferences.dart';

import '../homePage.dart';


class SocialLogIn extends StatelessWidget {
  const SocialLogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController email =  TextEditingController();
    TextEditingController pass =  TextEditingController();
    email.text="ahmednaser7897@gmail.com";
    pass.text="123456";
    var keyf = GlobalKey<FormState>();
    return BlocProvider<LoginCupit>(
      create: (context) => LoginCupit(),
      child: BlocConsumer<LoginCupit, LoginState>(
        listener: (context, state) {
          if(state is ErrorLogin) {
            showToast(state.error, States.ERORR);
          }
          if(state is ScLogin){
            CachHelper.setData(key: "uid", value: state.uId).then((value) {
              uId=state.uId;
              navigatorAndEnd(context, const MyHomePage()); 
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
                        Text(!(cupit1.isEnglish) ?"تسجيل الدخول":"loge in".toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                !.copyWith(color:  cupit1.moodl?Colors.black:Colors.white)),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(!(cupit1.isEnglish) ?"سجل للدخول في مجتمعنا":"loge in to our Social app",
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
                            labelText: !(cupit1.isEnglish) ?"البريد":"Email",
                            prefixIcon: const Icon(Icons.email,color: mainColor,),
                             labelStyle: const TextStyle(color:mainColor,fontSize: 20) ,
                          ),
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) return !(cupit1.isEnglish) ?"يجب و جود بريد":"email must not be empty";
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
                            prefixIcon: const Icon(Icons.lock,color: mainColor,),
                             labelStyle: const TextStyle(color:mainColor,fontSize: 20) ,
                            suffixIcon: IconButton(
                              icon: !cupit.showPass
                                  ? const Icon(Icons.visibility,color: mainColor,)
                                  : const Icon(Icons.visibility_off,color: Colors.grey,),
                              onPressed: () {
                                cupit.changeShowPass();
                              },
                            ),
                          ),
                          controller: pass,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: cupit.showPass ? true : false,
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
                        (stste is LodingLogin)?const Center(child:  CircularProgressIndicator()):Container(
                          width: double.infinity,
                          color: Colors.blue,
                          child: MaterialButton(
                              child: Text(
                                !(cupit1.isEnglish) ?"تسجيل الدخول":"loge in",
                                style:
                                    const TextStyle(fontSize: 25, color: Colors.white),
                              ),
                              onPressed: () {
                                 if(keyf.currentState!.validate()){
                                  cupit.userLogin(email: email.text, pass: pass.text);
                                }
                              }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(!(cupit1.isEnglish) ?"هل لديك حساب بالفعل ؟":"Do not have an email?",style: const TextStyle(decoration:TextDecoration.underline , fontSize: 15),),
                            const SizedBox(
                              width: 5,
                            ),
                            TextButton(
                              child: Text(
                                !(cupit1.isEnglish) ?"انشاء حساب":"Register".toUpperCase(),
                                style: const TextStyle(color: mainColor, fontSize: 15),
                              ),
                              onPressed: () {
                                navigatorTo(context, const RegisterScreen());
                              },
                            ),
                          ],
                        )
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
