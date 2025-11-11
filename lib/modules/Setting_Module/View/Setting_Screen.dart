import 'package:auratech_academy/modules/Authentication_module/View/LoginScreen.dart';
import 'package:auratech_academy/modules/Setting_Module/View/LanguageswitchSheet.dart';
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
import '../../../app/controllers/localization_controller.dart'; // make sure path ok

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GoogleSigninController googleLoginController = Get.find();
  final loc = Get.find<LocalizationController>();

  // ✅ keep keys here (NO .tr)
  final List<_SettingItem> settings = const [
    _SettingItem('settings_account', Icons.person),
    _SettingItem('settings_language', Icons.language),
    _SettingItem('settings_privacy', Icons.lock),
    _SettingItem('settings_help', Icons.help_outline),
    _SettingItem('settings_feedback', Icons.feedback),
    _SettingItem('settings_terms', Icons.description),
    _SettingItem('logout', Icons.logout, isDestructive: true),
  ];

  @override
  Widget build(BuildContext context) {
    // ✅ react to locale changes; rebuilding this widget tree instantly
    return Obx(() {
      final _ = loc.locale; // establishes reactive dependency

      final size = MediaQuery.of(context).size;
      final isTablet = size.width > 600;

      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Setting_title'.tr),
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

            // 👀 subtitle only for language row
            Widget? subtitle;
            if (item.titleKey == 'settings_language') {
              final current = Get.locale ?? const Locale('en', 'US');
              subtitle = Text(
                _localeLabelFromI18n(current), // uses i18n keys below
                style: GoogleFonts.roboto(
                  fontSize: isTablet ? 14 : 12,
                  color: AppColors.textSecondary,
                ),
              );
            }

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
                  // ✅ translate at render time
                  title: Text(
                    item.titleKey.tr,
                    style: GoogleFonts.roboto(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w600,
                      color: item.isDestructive ? Colors.red : AppColors.textPrimary,
                    ),
                  ),
                  subtitle: subtitle,
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  void _navigateToSettingScreen(BuildContext context, int index) async {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
        break;
      case 1:
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => const LanguageSheet(),
        );
        // ensure subtitle refresh
        setState(() {});
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => HelpAndSupportScreen()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackScreen()));
        break;
      case 5:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsAndConditionsScreen()));
        break;
      case 6:
        showCustomCupertinoDialog(
          context: context,
          title: 'logout_confirm_title'.tr,
          content: 'logout_confirm_body'.tr,
          cancelText: 'cancel'.tr,
          confirmText: 'ok'.tr,
          onConfirm: () async { await removeAccessToken(); },
        );
        break;
    }
  }

  Future<void> removeAccessToken() async {
    try {
      await googleLoginController.signOut();
      await StorageService.removeData("Access_Token");
      await StorageService.removeData("User_id");
      UtilKlass.showToastMsg("User Logout Successfully", context);
      Get.offAll(() => LoginScreen());
    } catch (e) {
      debugPrint("Failed to remove access token: $e");
      UtilKlass.showToastMsg("Failed To Logout", context);
    }
  }

   String _localeLabelFromI18n(Locale l) {
    final code = '${l.languageCode}_${l.countryCode ?? ''}';
    const keyMap = {
      'en_US': 'English',
      'hi_IN': 'Hindi',
      'ur_IN': 'Urdu',
      'te_IN': 'Telugu',
      'mr_IN': 'Marathi',
      'gu_IN': 'Gujarati',
      'ta_IN': 'Tamil',
    };
    final k = keyMap[code];
    return (k != null) ? k.tr : code;
  }
}

class _SettingItem {
  final String titleKey;
  final IconData icon;
  final bool isDestructive;
  const _SettingItem(this.titleKey, this.icon, {this.isDestructive = false});
}
