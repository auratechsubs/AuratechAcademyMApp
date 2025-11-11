import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/controllers/localization_controller.dart';
import '../../../constant/constant_colors.dart';
import '../Controller/FaqController.dart';

class HelpAndSupportScreen extends StatelessWidget {
  HelpAndSupportScreen({super.key});
  final FaqController faqController = Get.find();

  @override
  Widget build(BuildContext context) {
    final loc = Get.find<LocalizationController>(); // ← controller

    return Obx(() {
      final size = MediaQuery.of(context).size;
      final isTablet = size.width > 600;
      final _ = loc.locale;
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            "settings_help".tr,
            style: GoogleFonts.lato(
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primary,
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
              _sectionTitle('contact_us'.tr, isTablet),
              SizedBox(height: isTablet ? 20 : 15),
              _contactCard(
                context,
                icon: Icons.email,
                title: 'email_support'.tr,
                subtitle: "contact@auratechacademy.com",
                onTap: () async {
                  final String subject =
                  Uri.encodeComponent("Support Request - eLearning App");
                  final String body = Uri.encodeComponent("Hi Team,\n\n"
                      "I am contacting you regarding your e-learning app that provides online courses and training.\n\n"
                      "Please assist me with...");
                  final String cc =
                  Uri.encodeComponent("support@auratechacademy.com");
                  final String bcc =
                  Uri.encodeComponent("admin@auratechacademy.com");

                  final Uri emailLaunchUri = Uri.parse(
                      "mailto:contact@auratechacademy.com?subject=$subject&body=$body&cc=$cc&bcc=$bcc");

                  try {
                    if (!await launchUrl(emailLaunchUri,
                        mode: LaunchMode.externalApplication)) {
                      await launchUrl(
                        Uri.parse(
                            "https://mail.google.com/mail/?view=cm&to=contact@auratechacademy.com"
                                "&cc=Sonaauratech@gmail.com"
                                "&bcc=Sona@auratechindia.com"
                                "&subject=$subject"
                                "&body=$body"),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  } catch (e) {
                    Get.snackbar(
                      "Error",
                      "Could not open email app.",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 2),
                    );
                  }
                },
                isTablet: isTablet,
              ),
              _contactCard(
                context,
                icon: Icons.phone,
                title: 'call_support'.tr,
                subtitle: "+91 9460548809",
                onTap: () async {
                  final Uri phoneUri = Uri(
                    scheme: 'tel',
                    path: '+919460548809',
                  );

                  if (await canLaunchUrl(phoneUri)) {
                    await launchUrl(phoneUri);
                  } else {
                    Get.snackbar(
                      "Error",
                      "Could not open phone dialer.",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 2),
                    );
                  }
                },
                isTablet: isTablet,
              ),
              SizedBox(height: isTablet ? 40 : 30),
              _sectionTitle('faq_title'.tr, isTablet),
              Obx(() {
                if (faqController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (faqController.errorMessage.isNotEmpty) {
                  return Center(child: Text(faqController.errorMessage.value));
                }

                if (faqController.faqList.isEmpty) {
                  return const Center(child: Text("No FAQs available."));
                }

                return ListView.builder(
                  physics:
                  NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
                  itemCount: faqController.faqList.length,
                  itemBuilder: (context, index) {
                    final faq = faqController.faqList[index];
                    print("Rendering FAQ: ${faq.courseFaqQue}");
                    return _faqItem(
                      question: faq.courseFaqQue ?? "No question",
                      answer: faq.courseFaqAns ?? "No answer",
                      isTablet: isTablet,
                    );
                  },
                );
              })
            ],
          ),
        ),
      );
    });

  }

  Widget _sectionTitle(String title, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 12 : 10),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: isTablet ? 22 : 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _contactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isTablet,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 10 : 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: isTablet ? 24 : 20,
            child: Icon(
              icon,
              color: Colors.white,
              size: isTablet ? 24 : 20,
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.roboto(
              fontSize: isTablet ? 16 : 14,
              color: AppColors.textSecondary,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: isTablet ? 20 : 16,
            color: AppColors.primary,
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _faqItem({
    required String question,
    required String answer,
    required bool isTablet,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 24 : 5),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        collapsedIconColor: AppColors.primary,
        iconColor: AppColors.primary,
        title: Text(
          question,
          style: GoogleFonts.roboto(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 12 : 10,
              vertical: isTablet ? 8 : 6,
            ),
            child: Text(
              answer,
              style: GoogleFonts.roboto(
                fontSize: isTablet ? 16 : 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
