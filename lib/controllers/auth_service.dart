import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony/telephony.dart';
import '/pages/home_page.dart';
import '/pages/login_page.dart';

class AuthController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Telephony telephony = Telephony.instance;
  var phoneController = TextEditingController();
  var otpController = TextEditingController();
  var isOtpSent = false.obs;
  String verificationId = "";

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    User? user = _firebaseAuth.currentUser; // Proper type handling
    if (user != null) {
      Get.offAll(() => HomePage());
    } else {
      Get.offAll(() => LoginPage());
    }
  }

  // Send OTP to user's phone number
  void sendOtp() async {
    String phone = "+91${phoneController.text}";
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
        Get.offAll(() => HomePage());
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar("Error", "Failed to send OTP: ${e.message}",
            backgroundColor: Colors.red, colorText: Colors.white);
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        isOtpSent.value = true;
        listenToIncomingSMS();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
    );
  }

  // Verify OTP and login
  void verifyOtp() async {
    String otp = otpController.text;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      User? user =
          userCredential.user; // Ensure the user object is properly handled

      if (user != null) {
        Get.offAll(() => HomePage());
      } else {
        Get.snackbar("Error", "User authentication failed",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to verify OTP: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Listen to incoming SMS for automatic OTP retrieval
  void listenToIncomingSMS() {
    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          if (message.body!.contains("phone-auth-")) {
            otpController.text = message.body!.substring(0, 6);
            verifyOtp();
          }
        },
        listenInBackground: false);
  }

  void logout() async {
    await _firebaseAuth.signOut();
    Get.offAll(() => LoginPage());
  }
}
