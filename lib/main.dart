// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/homePage.dart';
import 'package:social_app/screens/login%20screen/on_boarding_screen.dart';
import 'package:social_app/screens/login%20screen/social_login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/chat%20cuipt/chat_cuipt.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/cubit/observer.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_states.dart';
import 'shared/shared_preferences/shared_preferences.dart';



 main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CachHelper.inti();

  Widget widget;
  uId=CachHelper.getData(key:"uid");
  bool ?onBoarding;
  onBoarding = CachHelper.getData(key: 'boarding');
  if(onBoarding!=null){
    if(uId!=null){
      widget=const MyHomePage();
    }else{
      widget=const SocialLogIn();
    }
  }else{
    widget=const OnBoardingScreen();
  }
  print(uId);
  BlocOverrides.runZoned(
    () { runApp(MyApp(widget: widget,));},
    blocObserver: MyBlocObserver()
  );
 
}

class MyApp extends StatelessWidget {
  final Widget widget;

  const MyApp({Key? key, required this.widget}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SocialCupit()..getPosts()..getUserData()..getAllUser()..getAllStorys()),
        BlocProvider(create: (context) => ChatCupit())
      ],
      child: BlocConsumer<SocialCupit, SocialState>(
        listener: (context, state) {},
        builder: (context, state) {
          SocialCupit cupit=SocialCupit.get(context);
          return MaterialApp(
            theme: lihghtTheme,
            darkTheme: darkTheme,
            themeMode:cupit.moodl? ThemeMode.light :ThemeMode.dark ,
            debugShowCheckedModeBanner: false,
            home: SafeArea(child: widget),
          );
        },
      )
    );
  }
}
