import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milcko/models/user_model.dart';
import 'package:milcko/screens/otp_screen.dart';
import 'package:milcko/widgets/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _uid;
  String get uid => _uid!;

  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;


  AuthProvider() {
    checkSignIn();
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> checkLoggedIn() async {
    final user = _auth.currentUser;
    return user != null;
  }
  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool('is_signed_in') ?? false;
    notifyListeners();
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          print('VERIFICATION FAILED');
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          print('EXECUTED CODE SENT');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OtpScreen(verificationId: verificationId)),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
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

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: userOtp);
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(creds);
      _uid = userCredential.user?.uid;
      _isLoading = false;
      notifyListeners();
      OnSuccess();
    } catch (e) {
      showSnackbar(context, e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkExistingUser(String phoneNumber) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .limit(1)
        .get();


    return snapshot.docs.isNotEmpty;
   }
  // Future<bool> checkExistingUser() async {
  //   try {
  //     if (_uid != null) {
  //       DocumentSnapshot snapshot =
  //       await _firebaseFirestore.collection('users').doc(_uid).get();
  //       if (snapshot.exists) {
  //         print('USER EXISTS');
  //         notifyListeners();
  //         return true;
  //       } else {
  //         print('NEW USER');
  //         notifyListeners();
  //         return false;
  //       }
  //     } else {
  //       print('UID is null');
  //       return false;
  //     }
  //   } catch (e) {
  //     print('Error checking existing user: $e');
  //     return false;
  //   }
  // }

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required Function OnSuccess,
  }) async {
    print('SAVE USER DATA TO FIREBASE');
    _isLoading = true;
    notifyListeners();
    try {
      userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
      userModel.uid = _firebaseAuth.currentUser!.uid;
      _userModel = userModel;

      print(userModel.phoneNumber);
      await _firebaseFirestore.collection('users').doc(userModel.phoneNumber).set(userModel.toMap()).then((value) => {
        OnSuccess(),
        _isLoading = false,
        notifyListeners(),
      });
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
