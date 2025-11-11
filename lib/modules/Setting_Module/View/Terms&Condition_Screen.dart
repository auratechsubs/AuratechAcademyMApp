import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant/constant_colors.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "settings_terms".tr,
          style: GoogleFonts.roboto(
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
            _sectionTitle("1. Acceptance of Terms", isTablet),
            _sectionContent(
              "By accessing or using this E-Learning app, you agree to be bound by these Terms and Conditions. If you do not agree, please do not use our services.",
              isTablet,
            ),
            _sectionTitle("2. User Responsibilities", isTablet),
            _sectionContent(
              "Users are responsible for maintaining the confidentiality of their account and for all activities that occur under their account.",
              isTablet,
            ),
            _sectionTitle("3. Course Access", isTablet),
            _sectionContent(
              "Purchased courses are accessible for the duration specified at the time of purchase. Sharing login credentials is strictly prohibited.",
              isTablet,
            ),
            _sectionTitle("4. Refund Policy", isTablet),
            _sectionContent(
              "We offer refunds only under specific circumstances. Please read our refund policy before making any purchase.",
              isTablet,
            ),
            _sectionTitle("5. Intellectual Property", isTablet),
            _sectionContent(
              "All content, including videos, text, graphics, and logos, is the property of this app and protected by copyright laws.",
              isTablet,
            ),
            _sectionTitle("6. Modifications", isTablet),
            _sectionContent(
              "We reserve the right to modify these terms at any time. Continued use after changes means you accept the new terms.",
              isTablet,
            ),
            _sectionTitle("7. Limitation of Liability", isTablet),
            _sectionContent(
              "We are not liable for any damages arising from the use or inability to use the services.",
              isTablet,
            ),
            _sectionTitle("8. Contact Us", isTablet),
            _sectionContent(
              "For any questions or concerns regarding these terms, please contact us at contact@auratechacademy.com.",
              isTablet,
            ),
            SizedBox(height: isTablet ? 40 : 30),
            Center(
              child: Text(
                "Effective Date: July 18, 2025",
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
      padding:
          EdgeInsets.only(top: isTablet ? 24 : 20, bottom: isTablet ? 10 : 8),
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
