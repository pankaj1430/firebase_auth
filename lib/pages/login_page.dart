import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_service.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.asset("assets/login.png", fit: BoxFit.cover),
              ),
              Text(
                "Welcome Back 👋",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text("Enter your phone number to continue."),
              SizedBox(height: 20),
              Form(
                child: TextFormField(
                  controller: authController.phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixText: "+91 ",
                    labelText: "Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  validator: (value) {
                    if (value!.length != 10) return "Invalid phone number";
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              Obx(
                () => authController.isOtpSent.value
                    ? Column(
                        children: [
                          TextFormField(
                            controller: authController.otpController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Enter OTP",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: authController.verifyOtp,
                              child: Text("Verify OTP"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                foregroundColor: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: authController.sendOtp,
                          child: Text("Send OTP"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
