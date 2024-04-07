import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milcko/models/user_model.dart';
import 'package:milcko/screens/map_screen.dart';
import 'package:milcko/screens/otp_screen.dart';
import 'package:milcko/widgets/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier{
  // for sign in
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn; 

// for otp verification
  bool _isLoading = false;
  bool get isLoading => _isLoading;

// user details
  String? _uid;
  String get uid => _uid!;

  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  AuthProvider(){
    checkSignIn();
  }
  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();

    _isSignedIn = s.getBool("is_signed_in") ?? false;
    notifyListeners();
  }
  
  void signInWithPhone(BuildContext context,String phoneNumber) async{
    print('ENTRED SIGN IN  WITH PHONE METHOD');
    MapScreenState location = MapScreenState();
    try {
      print('ENTRED TRY BLOCK');
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async{
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);// only when the OTP is completed
        }, 
        verificationFailed: (error){
          print('VERIFICATION FAILED');
          throw Exception(error.message);// in case of any error
        }, 
        codeSent: (verificationId, forceResendingToken) {
          print('EXECUTED CODE SENT');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OtpScreen(verificationId: verificationId,)),
          );
        }, 
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch(e){
      showSnackbar(context, e.message.toString());
    }
  }
}