import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant/constant_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "settings_privacy".tr,
          style: GoogleFonts.lato(
            fontSize: isTablet ? 22 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: isTablet ? 28 : 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 32 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("1. Introduction", isTablet),
            _sectionContent(
              "Welcome to our E-Learning App. We are committed to protecting your personal information and your right to privacy.",
              isTablet,
            ),
            _sectionTitle("2. Information We Collect", isTablet),
            _sectionContent(
              "We may collect personal details such as name, email address, phone number, and course preferences for a better learning experience.",
              isTablet,
            ),
            _sectionTitle("3. How We Use Your Information", isTablet),
            _sectionContent(
              "We use your data to personalize your learning journey, provide customer support, send notifications, and improve our services.",
              isTablet,
            ),
            _sectionTitle("4. Sharing Your Information", isTablet),
            _sectionContent(
              "We do not sell or share your personal information with third parties, except as required by law or to deliver core functionality of the app.",
              isTablet,
            ),
            _sectionTitle("5. Data Security", isTablet),
            _sectionContent(
              "We use encryption and other security measures to protect your data. However, no method of transmission is 100% secure.",
              isTablet,
            ),
            _sectionTitle("6. Children’s Privacy", isTablet),
            _sectionContent(
              "Our services are not directed to children under 13. We do not knowingly collect personal information from children.",
              isTablet,
            ),
            _sectionTitle("7. Changes to This Policy", isTablet),
            _sectionContent(
              "We may update this policy periodically. Any changes will be posted on this page with a revised effective date.",
              isTablet,
            ),
            _sectionTitle("8. Contact Us", isTablet),
            _sectionContent(
              "If you have any questions or concerns about this policy, please contact us at support@elearnapp.com.",
              isTablet,
            ),
            SizedBox(height: isTablet ? 40 : 30),
            Center(
              child: Text(
                "Last updated: July 18, 2025",
                style: GoogleFonts.lato(
                  fontSize: isTablet ? 16 : 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(top: isTablet ? 24 : 20, bottom: isTablet ? 10 : 8),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: isTablet ? 20 : 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _sectionContent(String text, bool isTablet) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        fontSize: isTablet ? 18 : 16,
        color: AppColors.textSecondary,
        height: 1.5,
      ),
    );
  }
}