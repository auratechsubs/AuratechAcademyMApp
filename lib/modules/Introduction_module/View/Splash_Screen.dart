import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';
import '../../../utils/global_variable.dart';
import '../../../widget/custombottombar.dart';
import '../../../utils/storageservice.dart';
import 'IntroductionScreen.dart';

class SplashScreen extends StatefulWidget {
  final Upgrader upgrader;
  const SplashScreen({super.key,required this.upgrader});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      _checkLoginAndNavigate();
    });
  }

  Future<void> _checkLoginAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final isLoggedIn = await StorageService.getIsLoggedIn();

    if (isLoggedIn) {
      final userId = await StorageService.getData("User_id");
      final token = await StorageService.getData("Access_Token");

      if (userId != null && token != null) {
        GlobalVariables.isLogin = true;
        Get.offAll(() => UpgradeAlert(
          upgrader: widget.upgrader,
          showPrompt: true,
          showIgnore: true,
          showLater: true,
          barrierDismissible: true,
          dialogStyle: UpgradeDialogStyle.cupertino,

          onIgnore: () {
            debugPrint('User chose to ignore this version.');
            return true;
          },
          onLater: () {
            debugPrint('User chose to be reminded later.');
            return true;
          },
          onUpdate: () {
            debugPrint('User chose to update the app.');
            return true;
          },

          child: const BottomnavBar(),
        ),);
      } else {
        GlobalVariables.isLogin = false;
        Get.offAll(() => const OnboardingScreen());
      }
    } else {
      GlobalVariables.isLogin = false;
      Get.offAll(() => const OnboardingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
            "assets/images/auratech1.jpg",
          // Assets.Splacescreenseconflogo,
          height: size.height * (isTablet ? 0.5 : 0.4),
          width: size.width * (isTablet ? 0.6 : 0.8),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}