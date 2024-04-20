import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:milcko/provider/auth_provider.dart';
import 'package:milcko/screens/home_screen.dart';
import 'package:milcko/screens/onboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';
import 'package:milcko/widgets/utils.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpcode;

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.orangeAccent,
        ),
      )
          : buildOtpScreen(context),
    );
  }

  Widget buildOtpScreen(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset('lib/images/otp.png'),
          const Text(
            'OTP Verification',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            'Enter the OTP sent to the given Number',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 40,
          ),
          Pinput(
            length: 6,
            showCursor: true,
            defaultPinTheme: PinTheme(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orangeAccent),
              ),
              textStyle: const TextStyle(fontSize: 28),
            ),
            onCompleted: (value) {
              setState(() {
                otpcode = value;
              });
            },
          ),
          const SizedBox(
            height: 40,
          ),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(text: "Did'nt recieve OTP?   ",style: TextStyle(color: Colors.black)),
                TextSpan(text: "Resend OTP",style: TextStyle(color: Colors.red)),
              ])
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    if(validOtp(otpcode)){
                      verifyOtp(context,otpcode!);
                    }else{
                      showSnackbar(context, 'Entre 6-Digit Code');
                    }
                  }, 
                  style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: validOtp(otpcode) ? MaterialStateProperty.all<Color>(Colors.orangeAccent):MaterialStateProperty.all<Color>(Colors.grey),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              child: const Text('Verify', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    print('CALLED VERIFY OTP- OTP SCREEN');
    showSnackbarlong(context, 'Verifying OTP...');

    ap.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOtp,
      OnSuccess: () {
        print('CALLED ON SUCCESS');
        if (otpcode != null) {
          ap.checkExistingUser(otpcode!).then((isExistingUser) {
            if (isExistingUser) {
              // User Exists
              print('User exists');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(currentLocation: const LatLng(0.0, 0.0))),
                    (route) => false,
              );
            } else {
              // New User
              print('New user');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const OnBoardScreen()),
                    (route) => false,
              );
            }
          }).catchError((error) {
            // Handle error
            print('Error checking existing user: $error');
            showSnackbar(context, 'Error verifying OTP. Please try again.');
          });
        } else {
          showSnackbar(context, 'Enter 6-Digit Code');
        }
      },
    );
  }
  bool validOtp(String? otpcode){
    if(otpcode != null){
      return true;
    }
    return false;
  }
}