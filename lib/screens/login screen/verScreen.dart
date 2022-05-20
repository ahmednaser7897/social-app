// ignore_for_file: avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/login%20cuipt/logein_states.dart';
import 'package:social_app/shared/cubit/login%20cuipt/login_cuoit.dart';
import 'package:social_app/shared/cubit/social%20cupit/social_cuoit.dart';
import '../homePage.dart';

// ignore: must_be_immutable
class VerifyScreen extends StatelessWidget {
  final String phone;
  String otb="";
  VerifyScreen({ Key ?key, required this.phone}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
    return BlocProvider<LoginCupit>(
      create: (context) => LoginCupit(),
      child: BlocConsumer<LoginCupit, LoginState>(
        listener: (context, state) {
          if(state is ErrorOccurred) {
            showToast(state.error, States.ERORR);
          }
          if(state is ErrorverifyUser) {
            showToast(state.error, States.ERORR);
          }
          if(state is PhoneOTPVerified) {
            navigatorAndEnd(context, const MyHomePage());
          }
          if(state is ScSendverifyingId) {
            print(state.verifyingId);
          }
        },
        builder: (context, stste) {
          LoginCupit cupit=LoginCupit.get(context);
          SocialCupit cupit1 = SocialCupit.get(context);
          return Directionality(
            textDirection: (cupit1.isEnglish) ?TextDirection.ltr:TextDirection.rtl,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Column(
                      children: [
                        Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/photos/illustration-3.png',
                        ),
                      ),
                      const SizedBox( height: 24,),
                      Text(
                        !(cupit1.isEnglish) ?"تاكيد رقم الهاتف":
                        'Verification +2$phone',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(!(cupit1.isEnglish) ?"ادخل رقم التاكيد":"Enter your OTP code number",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:!cupit1.moodl?Colors.white: Colors.black38,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28,),
                        Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cupit1.moodl?const Color(0xfff7f6fb):Colors.black38,
                          borderRadius: BorderRadius.circular(12),
                        ),
                          child:Column(
                            children: [
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: PinPut(
                                  fieldsCount: 6,
                                  textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
                                  eachFieldWidth: 40.0,
                                  eachFieldHeight: 55.0,
                                  focusNode: _pinPutFocusNode,
                                  controller: _pinPutController,
                                  submittedFieldDecoration: pinPutDecoration,
                                  selectedFieldDecoration: pinPutDecoration,
                                  followingFieldDecoration: pinPutDecoration,
                                  pinAnimationType: PinAnimationType.fade,
                                  onSubmit: (otpCode) async {
                                    try {
                                      cupit.submitOTP(otpCode);
                                      print("verificationId is ${cupit.verificationId}");
                                    } catch (e) {
                                      FocusScope.of(context).unfocus();
                                      showToast(!(cupit1.isEnglish) ?"رقم خاطي":"invalid OTP", States.ERORR);
                                    }
                                  },
                                ),
                              ),
                               const SizedBox( height: 18, ),
                                Text(!(cupit1.isEnglish) ?"الم تستلم رقم تاكيد؟":
                                  "Didn't you receive any code?",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color:cupit1.moodl? Colors.black38:Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                TextButton(
                                  onPressed: (){
                                    cupit.verifyPhone2(phone: phone);
                                  },
                                  child: Text(!(cupit1.isEnglish) ?"اعاده ارسال رقم تاكيد":
                                    "Resend New Code",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                      ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        })
    );
  }
}