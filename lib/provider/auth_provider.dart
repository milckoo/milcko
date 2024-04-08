import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milcko/models/user_model.dart';
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
    try {
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
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function OnSuccess,
  }) async {

    _isLoading = true;
    notifyListeners();

    print('CALLED VERIFY OTP- AUTH SCREEN');
    try{
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
        verificationId: verificationId,smsCode: userOtp);
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user;
      if(user != null){
        // carry logic
        _uid = user.uid;
        _isLoading = false;
        notifyListeners();
        OnSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch(e){

      showSnackbar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  // DATA BASE OPERATION
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot = await _firebaseFirestore.collection("users").doc(_uid).get();
    if(snapshot.exists){
      print('USER EXISTS');
      notifyListeners();
      return true;
    }
    else{
      print('NEW USER');
      notifyListeners();
      return false;
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required Function OnSuccess,
  }) async {
    print('SAVE USER DATA TO FIREBASE');
    _isLoading = true;
    notifyListeners();
    try{
      userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
      //userModel.location = _firebaseAuth.currentUser!.location!;
      userModel.uid = _firebaseAuth.currentUser!.uid;
      _userModel = userModel;

      print(userModel.phoneNumber);
      //uploading to data base
      await _firebaseFirestore
      .collection("users")
      .doc(userModel.phoneNumber)
      .set(userModel.toMap())
      .then((value) => {
        OnSuccess(),
        _isLoading = false,
        notifyListeners(),
      });
    } on FirebaseAuthException catch(e){
      showSnackbar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }
}