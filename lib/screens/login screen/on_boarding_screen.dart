import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_app/screens/login%20screen/register_screen.dart';
import 'package:social_app/screens/login%20screen/social_login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import 'package:social_app/shared/shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}
int pageNumber=3;
class OnBoardingScreenState extends State<OnBoardingScreen> {
  var bc = PageController();
  bool isLast = false;
  
  
 void submet(Widget submetTo){
    CachHelper.setData(key: 'boarding', value: true).then((value) {
      if(value){
         navigatorAndEnd(context, submetTo);
      }
    });
  }
 
  @override
  Widget build(BuildContext context) {
    SocialCupit cupit=SocialCupit.get(context);
    List<DropdownMenuItem<String>> langs = [
      DropdownMenuItem(
          value: 'English',
          child: Text(
            'English',
            style: Theme.of(context).textTheme.bodyText1,
          )),
      DropdownMenuItem(
          value: 'عربي',
          child: Text(
            'عربي',
            style: Theme.of(context).textTheme.bodyText1,
          )),
    ];
     String selected = (cupit.isEnglish) ? 'English' : 'عربي';
    return Directionality(
      textDirection: (cupit.isEnglish) ?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  if (isLast) {
                    submet(const SocialLogIn());
                  } else {
                    bc.nextPage(
                        duration: const Duration(microseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn);
                  }
                },
                child: Text(!(cupit.isEnglish) ?"تخطي":"skip"))
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    onPageChanged: (value) {
                      if (value == pageNumber-1) {
                        setState(() {
                          isLast = true;
                        });
                      } else {
                        setState(() {
                          isLast = false;
                        });
                      }
                    },
                    controller: bc,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      zeroPage(context),
                      scPage(langs,selected,context),
                      thPage(context),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    SmoothPageIndicator(
                      controller: bc,
                      count: pageNumber,
                      effect: const SwapEffect(
                        dotColor: Colors.grey,
                        activeDotColor: Colors.purple,
                        dotWidth: 10,
                        dotHeight: 10,
                        spacing: 5,
                      ),
                    ),
                    const Spacer(),
                    if(!isLast)
                    FloatingActionButton(
                      onPressed: () {
                        if (isLast) {
                          submet(const SocialLogIn());
                        } else {
                          bc.nextPage(
                              duration: const Duration(microseconds: 1000),
                              curve: Curves.fastLinearToSlowEaseIn);
                        }
                      },
                      backgroundColor: Colors.purple,
                      child: const Icon(Icons.arrow_forward),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget zeroPage(context){
    SocialCupit cupit=SocialCupit.get(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset('assets/photos/illustration-3.png', width: double.infinity,height: 200, ),
          const SizedBox(height: 25,),
           const Text("Welcome to our community We hope that you will find what you need here like Communicate with friends and make new friends , Express how you feel and share with your friends everything that is new.",
                style:  TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "all rights are save to Ahmed Naser",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color:cupit.moodl? Colors.black38:Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
        ]
      ),
    );
  }
  
  Widget scPage(langs,selected,context){
     SocialCupit cupit=SocialCupit.get(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset('assets/photos/illustration-2.png', width: double.infinity,height: 200, ),
          const SizedBox(height: 25,),
           Text(!(cupit.isEnglish) ?"هيا نضع الاعدادات الاساسيه":"Let's Make our Settings",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
          Row(
            children: [
               Text(!(cupit.isEnglish) ?"اللغه":
                'language',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(
                width: 20,
              ),
              DropdownButton<String>(
                dropdownColor: cupit.moodl ? Colors.white : HexColor('333739'),
                items: langs,
                onChanged: (value) {
                  if (value == selected) {
                  } else{
                    cupit.changLang(!cupit.isEnglish);
                  }
                    
                },
                value: selected,
                underline: Container( height: 2,color:Colors.purple),
              ),
            ],
          ),
          const SizedBox(height: 25,),
          Row(children: [
            Text(!(cupit.isEnglish) ?"الوضع الليلي":"Dark Mood",style:const TextStyle(fontSize: 22,fontWeight: FontWeight.bold,),),
            const Spacer(),
            Switch(
              value:cupit.moodl,
              onChanged: (value){
                cupit.changMood(value);
              },
            )
          ],),
        ],
      ),
    );
  }
  
  Widget thPage(context){
    SocialCupit cupit=SocialCupit.get(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset('assets/photos/illustration-1.png', width: double.infinity,height: 160, ),
          const SizedBox(height: 18,),
          Text(!(cupit.isEnglish) ?"هيا نبداء":"Let's get started",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(!cupit.isEnglish?"لا يوجد وقت أفضل من الآن للبدء.":
                "Never a better time than now to start.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color:cupit.moodl? Colors.black38:Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 38,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                     submet(const RegisterScreen());
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.purple),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(!(cupit.isEnglish) ?"انشاء حساب":
                      'Create Account',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                     submet(const SocialLogIn());
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.purple),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(!(cupit.isEnglish) ?"تسجيل الدخول":
                      'Login',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

}
