import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/constant_colors.dart';

import '../Controller/Google_Signup_Controller.dart';
import '../Controller/Login_Controller.dart';
 import 'SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController loginController = Get.find();

  final GoogleSigninController googleLoginController = Get.find();

  InputDecoration _inputDecoration({
    required IconData icon,
    String? label,
    Widget? suffixIcon, // 👈 Now accepts any widget (like an IconButton)
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.primary),
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.primary),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon, // 👈 Directly used here
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryDark),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }


  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06, vertical: screenHeight * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.04),

                // Logo
                Center(
                  child: Image.asset(
                    "assets/images/auratech2.jpg",
                    // Assets.Splacescreenseconflogo,
                    height: screenHeight * 0.15,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),

                Text(
                  "Join 1M+ learners growing their future with Auratech Academy Let`s Login",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),

                // Email
                TextField(
                  controller: loginController.emailController,
                  decoration: _inputDecoration(
                    icon: Icons.email_outlined,
                    label: 'Email',
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),

                // Password
                TextField(
                  controller: loginController.passwordController,
                  obscureText: isPasswordVisible,
                  obscuringCharacter: "*",

                  decoration: _inputDecoration(
                    icon: Icons.password_outlined,
                    label: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.primary,
                      ), onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                       },
                  ),

                ),
                ),
                SizedBox(height: screenHeight * 0.025),

                // Divider
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("Or"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                SizedBox(height: screenHeight * 0.025),



                ElevatedButton(
                  onPressed: () async {
                    await loginController.loginUser(
                      loginController.emailController.text.trim(),
                      loginController.passwordController.text.trim(),
                      false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign in with Your Account",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10,),
                      Icon(Icons.arrow_forward,color: AppColors.background,size: 16,)
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                // Google Sign-In
                buildSocialButton(
                  iconPath: 'assets/icons/google.png',
                  label: "Continue with Google",
                  onPressed: () async {
                    await googleLoginController.googleLogin().then((val) {
                      if (val != null) {
                        loginController.loginUser(
                          googleLoginController.userEmail.toString(),
                          googleLoginController.idToken.toString(),
                          true,
                        );
                      }
                    });
                  },
                ),

                // SizedBox(height: screenHeight * 0.02),
                //
                // buildSocialButton(
                //   iconPath: 'assets/icons/facebook.png',
                //   label: "Continue with Facebook",
                //   onPressed: () {},
                // ),
                //


                // Primary Login Button
                // ElevatedButton(
                //   onPressed: () async {
                //     await loginController.loginUser(
                //       loginController.emailController.text.trim(),
                //       loginController.passwordController.text.trim(),
                //       false,
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: AppColors.primaryDark,
                //     minimumSize: Size(double.infinity, 50),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //   ),
                //   child: const Text(
                //     "Sign in with Your Account",
                //     style: TextStyle(fontWeight: FontWeight.bold),
                //   ),
                // ),

                SizedBox(height: screenHeight * 0.02),

                // SignUp / Phone Login
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SignUpScreen()),
                          );
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: "Don’t have an account? ",
                            children: [
                              TextSpan(
                                text: "SIGN UP",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // TextButton(
                      //   onPressed: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => MobileLoginScreen()),
                      //   ),
                      //   child: const Text("Login With Phone Number"),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSocialButton({
    required String iconPath,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Image.asset(
        iconPath,
        height: 24,
        width: 24,
      ),
      label: Text(
        label,
        style: const TextStyle(
          color: AppColors.background,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: AppColors.primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
