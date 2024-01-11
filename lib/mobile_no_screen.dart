import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';





TextEditingController _mobileController = TextEditingController();
class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {

  bool _isValidMobile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
            onTap: () {

            },
            child:  Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).dividerColor,
              size: 20,
            )
        ),

        backgroundColor: Theme.of(context).primaryColor,
      ),
      body:
      Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  "Enter your mobile no." ,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      color: Theme.of(context).dividerColor,
                      // fontFamily: 'Poppins',
                      fontSize: 25,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                      height: 1),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "We need to verify your number" ,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      color: Theme.of(context).dividerColor.withOpacity(.6),
                      // fontFamily: 'Poppins',
                      fontSize: 16,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                      height: 1),
                ),
              ),
              SizedBox(height: 50,),
              Container(
                padding: const EdgeInsets.only(top: 10.0, bottom: 7),
                child: Text(
                  "Mobile number:" ,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      color: Theme.of(context).dividerColor,
                      // fontFamily: 'Poppins',
                      fontSize: 14,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                      height: 1),
                ),
              ),
              TextField(
                cursorColor: Theme.of(context).dividerColor,
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  errorStyle: TextStyle(fontSize: 16.0),
                  counterText: '',
                  filled: true,
                  fillColor: Theme.of(context).primaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 0.50,
                        color:
                        Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  hintText: 'Enter 10-digit mobile number',
                  hintStyle: TextStyle(
                      color: Theme.of(context).dividerColor),
                  // contentPadding: EdgeInsets.only(top: 35, left :15),


                ),
                style: GoogleFonts.poppins(
                    color: Theme.of(context).dividerColor,

                    fontSize: 14,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                    height: 1),
                onChanged: (value) {
                  setState(() {
                    _isValidMobile = value.length == 10;
                  });
                },
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Checkbox(
                    value: _isValidMobile,
                    onChanged: (value) {
                      setState(() {
                        _isValidMobile = value!;
                      });
                    },
                  ),
                  Text('Remember Me'),
                ],
              ),
              SizedBox(height: 70.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 280,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _isValidMobile ? _requestOtp : null,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text('Get OTP',style: GoogleFonts.poppins(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            // fontFamily: 'Poppins',
                            fontSize: 17,
                            letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.w500,
                            height: 1),),
                      ),
                      style: ButtonStyle(
                          overlayColor:
                          MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.white.withOpacity(0.8);
                              }
                              return Colors.transparent;
                            },
                          ),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                            ),
                          ),
                          backgroundColor:_isValidMobile? MaterialStateProperty.all<Color>(Color.fromRGBO(0, 25, 50, 1))
                                  : MaterialStateProperty.all<Color>(Colors.grey,
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }

  void _requestOtp() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: '+91${_mobileController.text}', // Replace with your country code
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          print('Failed to send OTP: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Handle the verificationId and resendToken as needed
          print('OTP Sent!');
          _navigateToOtpScreen(verificationId, _mobileController.text);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print('Failed to request OTP: $e');
    }
  }

  void _navigateToOtpScreen(String verificationId, String phoneNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpScreen(
          verificationId: verificationId,
          phoneNumber: phoneNumber,
        ),
      ),
    );
  }
}
class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpScreen({Key? key, required this.verificationId, required this.phoneNumber})
      : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController _otpController = TextEditingController();
  late Duration _timerDuration;
  late Timer _timer;
  bool _isResendButtonEnabled = false;
  bool _isOtpValid = false;
  bool _hasEnteredOtp = false;
  String _otpValidationMessage = '';
  String result = "";
  FocusNode? myFocusNode;
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    _timerDuration = Duration(minutes: 2, seconds: 50);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerDuration.inSeconds > 0) {
          _timerDuration -= Duration(seconds: 1);
        } else {
          _isResendButtonEnabled = true;
          _timer.cancel();
        }
      });
    });
  }

  void _resendCode() async{
    _isResendButtonEnabled = false;
    _timerDuration = Duration(minutes: 2, seconds: 50);
    _startTimer();
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: '+91${_mobileController.text}', // Replace with your country code
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          print('Failed to send OTP: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {

          print('OTP Sent!');
          // _navigateToOtpScreen(verificationId, _mobileController.text);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print('Failed to request OTP: $e');
    }
    print('Resending OTP...');
  }
  void _validateOtp(String otp) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: _otpController.text,
    );

    try {
      await auth.signInWithCredential(credential);
      setState(() {
        _isOtpValid = true;
        _otpValidationMessage = '';
      });
      print('OTP Verified');
    } catch (e) {
      setState(() {
        _isOtpValid = false;
        _otpValidationMessage = 'Invalid OTP. Please try again.';
      });
      print('Failed to verify OTP: $e');
    }
  }






  @override
  Widget build(BuildContext context) {
    Color otpTextFieldColor =_hasEnteredOtp
        ? _isOtpValid
        ? Colors.green
        : Colors.red
        : Colors.transparent;
    const borderColor = Colors.blueGrey;
    const focusedBorderColor = Colors.blue;
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 45,
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        color: Theme.of(context).indicatorColor,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderColor),
      ),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
            onTap: () {

            },
            child:  Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).dividerColor,
              size: 20,
            )
        ),

        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
            
            children: [
              Container(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  "Verify your phone" ,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      color: Theme.of(context).dividerColor,
                      // fontFamily: 'Poppins',
                      fontSize: 25,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                      height: 1),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "Enter the verification code sent to" ,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      color: Theme.of(context).dividerColor.withOpacity(.6),
                      // fontFamily: 'Poppins',
                      fontSize: 16,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                      height: 1),
                ),
              ),

              Text('${_maskPhoneNumber(widget.phoneNumber)}',style: GoogleFonts.poppins(
                  color: Theme.of(context).dividerColor.withOpacity(.8),
                  // fontFamily: 'Poppins',
                  fontSize: 14,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                  height: 1),),
              SizedBox(height: 40.0),
              Container(
                  // padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: _isOtpValid ? Colors.green : _otpController.text.length == 6 ? Colors.red : Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),

                  padding: const EdgeInsets.only(
                      left: 5.0, right: 5, top: 20, bottom: 20),
                  child: Column(
                    children: [
                      Pinput(
                          length: 6,
                          onSubmitted: (String pin) {
                            setState(() {
                              result = pin;
                            });
                          },
                          focusNode: myFocusNode,
                          controller: _otpController,
                          androidSmsAutofillMethod:
                          AndroidSmsAutofillMethod.smsUserConsentApi,
                          listenForMultipleSmsOnAndroid: true,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration:
                            defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(5),
                              border:
                              Border.all(color: focusedBorderColor),
                            ),
                          ),
                          onChanged: (otp) {
                            _validateOtp(otp);
                          },

                          errorText: _isOtpValid ? null : 'Invalid OTP',
                          submittedPinTheme: defaultPinTheme.copyWith(
                            decoration:
                            defaultPinTheme.decoration!.copyWith(
                              color:_isOtpValid? Colors.white:Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border:
                              Border.all(color: focusedBorderColor),
                            ),
                          ),
                          errorPinTheme: defaultPinTheme.copyBorderWith(
                            border: Border.all(color: Colors.redAccent),
                          )),
                      _isOtpValid
                      ?Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done, color: Colors.white,),
                            Container(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Text(
                                " Verify" ,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    // fontFamily: 'Poppins',
                                    fontSize: 18,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w600,
                                    height: 1),
                              ),
                            ),
                          ],
                        ),
                      )
                       :_otpController.text.length == 6
                          ?Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Icon(Icons.close, color: Colors.white,),
                            Container(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Text(
                                " Invalid OTP" ,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    // fontFamily: 'Poppins',
                                    fontSize: 18,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w600,
                                    height: 1),
                              ),
                            ),
                        ],
                      ),
                          ):SizedBox.shrink(),

                    ],
                  )),

              SizedBox(height: 20.0),
              // ElevatedButton(
              //   onPressed: _validateOtp(otp),
              //   child: Text('Verify OTP'),
              // ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Verification Code expires in '),
                  CountdownTimer(
                    duration: _timerDuration,
                    onEnd: () {
                      setState(() {
                        _isResendButtonEnabled = true;
                      });
                    },
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),


                ],
              ),
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 280,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _isResendButtonEnabled ? _resendCode : null,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text('Resend OTP',style: GoogleFonts.poppins(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            // fontFamily: 'Poppins',
                            fontSize: 17,
                            letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.w500,
                            height: 1),),
                      ),
                      style: ButtonStyle(
                          overlayColor:
                          MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.white.withOpacity(0.8);
                              }
                              return Colors.transparent;
                            },
                          ),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                            ),
                          ),
                          backgroundColor:_isResendButtonEnabled? MaterialStateProperty.all<Color>(Color.fromRGBO(0, 25, 50, 1))
                              : MaterialStateProperty.all<Color>(Colors.grey,
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _maskPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceRange(2, 8, '******');
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class CountdownTimer extends StatelessWidget {
  final Duration duration;
  final Function() onEnd;
  final TextStyle textStyle;

  CountdownTimer({
    required this.duration,
    required this.onEnd,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;

    return Text(
      '$minutes:${seconds.toString().padLeft(2, '0')}',
      style: textStyle,
    );
  }
}
// class OtpScreen extends StatefulWidget {
//   final String verificationId;
//   final String phoneNumber;
//
//   const OtpScreen({Key? key, required this.verificationId, required this.phoneNumber})
//       : super(key: key);
//
//   @override
//   _OtpScreenState createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends State<OtpScreen> {
//   TextEditingController _otpController = TextEditingController();
//   late Duration _timerDuration;
//   late bool _timerActive;
//   late Timer _timer;
//   int _resendCount = 0;
//   bool _isResendButtonEnabled = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _timerDuration = Duration(minutes: 2, seconds: 50);
//     _timerActive = true;
//     _startTimer();
//   }
//
//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_timerDuration.inSeconds > 0) {
//           _timerDuration -= Duration(seconds: 1);
//         } else {
//           _timerActive = false;
//           _isResendButtonEnabled = true;
//           _timer.cancel();
//         }
//       });
//     });
//   }
//
//   void _resendCode() {
//     _resendCount++;
//     _isResendButtonEnabled = false;
//     _timerDuration = Duration(minutes: 2, seconds: 50);
//     _startTimer();
//     // Implement code to resend OTP here
//     print('Resending OTP...');
//   }
//
//   void _validateOtp() async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//
//     AuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: widget.verificationId,
//       smsCode: _otpController.text,
//     );
//
//     try {
//       await auth.signInWithCredential(credential);
//       print('OTP Verified');
//     } catch (e) {
//       print('Failed to verify OTP: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Enter OTP'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Enter OTP sent to ${_maskPhoneNumber(widget.phoneNumber)}'),
//             SizedBox(height: 20.0),
//             TextField(
//               controller: _otpController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'OTP',
//               ),
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: _validateOtp,
//               child: Text('Verify OTP'),
//             ),
//             SizedBox(height: 20.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Resend Code in '),
//                 _timerActive
//                     ? CountdownTimer(
//                   duration: _timerDuration,
//                   onEnd: () {
//                     setState(() {
//                       _timerActive = false;
//                       _isResendButtonEnabled = true;
//                     });
//                   },
//                   textStyle: TextStyle(fontWeight: FontWeight.bold),
//                 )
//                     : TextButton(
//                   onPressed: _resendCount < 5 && !_isResendButtonEnabled
//                       ? _resendCode
//                       : null,
//                   child: Text('Resend Code'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _maskPhoneNumber(String phoneNumber) {
//     return phoneNumber.replaceRange(2, 8, '******');
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
// }
//
// class CountdownTimer extends StatelessWidget {
//   final Duration duration;
//   final Function() onEnd;
//   final TextStyle textStyle;
//
//   CountdownTimer({
//     required this.duration,
//     required this.onEnd,
//     required this.textStyle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     int minutes = duration.inMinutes;
//     int seconds = duration.inSeconds % 60;
//
//     return Text(
//       '$minutes:${seconds.toString().padLeft(2, '0')}',
//       style: textStyle,
//     );
//   }
// }


