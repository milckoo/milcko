import 'package:flutter/material.dart';
import 'package:milcko/provider/auth_provider.dart';
import 'package:milcko/screens/home_screen.dart';
import 'package:milcko/screens/onboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';
import 'package:milcko/widgets/utils.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key,required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpcode;
  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context,listen: true).isLoading;
    return Scaffold(
      body: isLoading == true? 
      Center(
        child: CircularProgressIndicator(
          color: Colors.orangeAccent,
        ),
      ):
      Center(
        child: Column(
          children: [
            Image.asset('lib/images/otp.png'),
            const Text('OTP Verification',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            const SizedBox(
              height: 40,
            ),
            const Text('Entre the OTP sent to the given Number',style: TextStyle(color: Colors.grey),),
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
                  border: Border.all(color: Colors.orangeAccent)
                ),
                textStyle: const TextStyle(fontSize: 28)
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
            RichText(text: const TextSpan(
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
                    if(otpcode != null){
                      verifyOtp(context,otpcode!);
                    }else{
                      showSnackbar(context, 'Entre 6-Digit Code');
                    }
                  }, 
                  style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    ),),
                  ),
                  child: const Text('Verify', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),),
            ),
          ],
        ),
      ),
    );
  }
  void verifyOtp(BuildContext context, String userOtp){
    final ap = Provider.of<AuthProvider>(context,listen: false);
    print('CALLED VERIFY OTP- OTP SCREEN');
    ap.verifyOtp(
      context: context, 
      verificationId: widget.verificationId, 
      userOtp: userOtp, 
      OnSuccess: (){
        ap.checkExistingUser().then((value) async {
          print('CALLED ON SUCCESS');
          if(value == true){
            // User Already Exists in our app
            Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(builder: (context)=> const HomeScreen()), 
              (route) => false);
          }
          else{
            // New User
            Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(builder: (context)=> const OnBoardScreen()), 
              (route) => false);
          }
        });

      }
    );
  }
}