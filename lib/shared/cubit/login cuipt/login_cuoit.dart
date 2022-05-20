// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/models/loge%20in%20models.dart';

import 'logein_states.dart';

class LoginCupit extends Cubit<LoginState>{
  LoginCupit():super(IntiLogein());
  static LoginCupit get(context)=>BlocProvider.of(context);

  bool showPassr=false;
  void changeShowPassRegiste(){
    showPassr=!showPassr;
    emit(ChangeShowPassRegiste());
  }
  bool showPass=false;
  void changeShowPass(){
    showPass=!showPass;
    emit(ChangeShowPass());
  }
  
   registerLogin({email,pass,name,phone})async{
    emit(LodingRegiste());
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass).then((value) {
      createUser(userId: value.user!.uid,email: email,phone: phone,name: name);
      emit(ScRegiste());
      });
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(ErrorRegiste('The password provided is too weak.'));
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        emit(ErrorRegiste('The account already exists for that email.'));
        print('The account already exists for that email.');
      }else{
         print("error feom registerLogin ${onError.toString()} ");
        emit(ErrorRegiste(onError.toString()));
      }
    } 
  }

  UserModel user=UserModel.ec();
  void createUser({email,userId,name,phone}){
    emit(LodingCreateUser());
     user =UserModel(name: name,phone:phone,email: email,uId: userId,
     image: "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
     isEmailVerified: false,
     bio: "welcome",
     cover: "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
     state: true,
     );
     FirebaseFirestore.instance.collection("users").doc(userId)
     .set(user.toMap()).then((value){
       emit(ScCreateUser(userId));
     }).catchError((onError){
       print("error feom createUser ${onError.toString()} ");
      emit(ErrorCreateUser(onError.toString()));
     });
  }

  userLogin({email,pass}){
    emit(LodingLogin());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass).then((value) {
      emit(ScLogin(value.user!.uid));
    }).catchError((onError){
     print("error feom userLogin ${onError.toString()} ");
      emit(ErrorLogin(onError.toString()));
    });
  }

  String verificationId="";
  Future verifyPhone2({@required phone,context})async{
     emit(LodingverifyUser());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phone',
     
      timeout: const Duration(seconds: 120),
     
      //عندما تكون تستخدم الجهاز الذي به الرقم يملئه تلقائيا و يفعل ما تريده في الفانكشن
      verificationCompleted: (PhoneAuthCredential credential) {
        print("verificationCompleted");
        signIn(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
          print("error from verificationFailed ${e.message.toString()} ");
          emit(ErrorverifyUser(e.message??""));
      },
      
      codeSent: (String verificationId, int ?resendToken) {
        print("codeSent $verificationId");
        this.verificationId=verificationId;
        emit(ScSendverifyingId(verificationId));
      },
      
      codeAutoRetrievalTimeout: (String verificationId) {
        print("codeAutoRetrievalTimeout $verificationId");
      },
    
    ).then((value) {
       print("verificationId in then  is $verificationId");
         emit(ScverifyUser());
        
      }).catchError((onError){
        print("error from verifyPhone ${onError.toString()} ");
        emit(ErrorRegiste(onError.toString()));
      });
  }
  
  Future<void> submitOTP(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpCode);
    await signIn(credential);
  }
  Future<void> signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOTPVerified());
    } catch (error) {
      print("error from signIn ${error.toString()} ");
      emit(ErrorOccurred(error.toString()));
    }
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User getLoggedInUser() {
    User firebaseUser = FirebaseAuth.instance.currentUser!;
    return firebaseUser;
  }
}
//./gradlew signingReport
//keytool -list -v -keystore "C:\Users\Ahmed Naser\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android