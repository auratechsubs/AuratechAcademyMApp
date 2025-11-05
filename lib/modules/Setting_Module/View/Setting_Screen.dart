import 'package:auratech_academy/modules/Authentication_module/View/LoginScreen.dart';
import 'package:auratech_academy/modules/Setting_Module/View/Profile_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant/constant_colors.dart';
import '../../../utils/storageservice.dart';
import '../../../utils/util_klass.dart';
import '../../../widget/cupertino_dialogue_box.dart';
import '../../Authentication_module/Controller/Google_Signup_Controller.dart';
import 'Feedback_screen.dart';
import 'HelpAndSupport_Screen.dart';
import 'Privacy_Policy_Screen.dart';
import 'Terms&Condition_Screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GoogleSigninController googleLoginController = Get.find();

  final List<_SettingItem> settings = [
    _SettingItem("Account", Icons.person),
    _SettingItem("Privacy", Icons.lock),
    _SettingItem("Help & Support", Icons.help_outline),
    _SettingItem("Feedback", Icons.feedback),
    _SettingItem("Terms & Conditions", Icons.description),
    _SettingItem("Logout", Icons.logout, isDestructive: true),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(

        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Settings",
        ),

      ),
      body: ListView.separated(
        padding: EdgeInsets.all(isTablet ? 32 : 20),
        itemCount: settings.length,
        separatorBuilder: (context, index) => Divider(
          color: AppColors.textSecondary,
          height: isTablet ? 20 : 16,
        ),
        itemBuilder: (context, index) {
          final item = settings[index];
          return InkWell(
            onTap: () => _navigateToSettingScreen(context, index),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 16 : 12,
                  vertical: isTablet ? 8 : 4,
                ),
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: isTablet ? 24 : 20,
                  child: Icon(
                    item.icon,
                    color: Colors.white,
                    size: isTablet ? 24 : 20,
                  ),
                ),
                title: Text(
                  item.title,
                  style: GoogleFonts.roboto(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                    color:
                        item.isDestructive ? Colors.red : AppColors.textPrimary,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: isTablet ? 20 : 16,
                  color: AppColors.primary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToSettingScreen(BuildContext context, int index) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    switch (index) {
      case 0: // Account
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
      case 1: // Privacy
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
        );
        break;
      case 2: // Help & Support
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) =>   HelpAndSupportScreen()),
        );
        break;
      case 3: // Feedback
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FeedbackScreen()),
        );
        break;
      case 4: // Terms & Conditions
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TermsAndConditionsScreen()),
        );
        break;
      case 5: // Logout
        showCustomCupertinoDialog(
          context: context,
          title: 'Logout Confirmation',
          content: 'Are you sure you want to logout?',
          cancelText: 'Cancel',
          confirmText: 'Logout',
          onConfirm: () async {
            await removeAccessToken();
          },
        );
        break;
    }
  }

  Future<void> removeAccessToken() async {
    try {
      await googleLoginController.signOut();
      await StorageService.removeData("Access_Token");
      await StorageService.removeData("User_id");
      UtilKlass.showToastMsg(
          "User Logout Successfully", context);
      Get.offAll(() => LoginScreen());
    } catch (e) {
      debugPrint("Failed to remove access token: $e");
      UtilKlass.showToastMsg(
          "Failed To Logout", context);
    }
  }
}

class _SettingItem {
  final String title;
  final IconData icon;
  final bool isDestructive;
  _SettingItem(this.title, this.icon, {this.isDestructive = false});
}
