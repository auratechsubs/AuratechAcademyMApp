import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant/constant_colors.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  int _selectedRating = 0;

  void _submitFeedback() {
    final feedbackText = _feedbackController.text.trim();

    if (feedbackText.isEmpty || _selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please provide rating and feedback',
            style: GoogleFonts.roboto(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // TODO: Submit feedback to backend

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Thank you for your feedback!',
          style: GoogleFonts.roboto(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    _feedbackController.clear();
    setState(() => _selectedRating = 0);
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "settings_feedback".tr,
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
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 32 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'rate_experience'.tr,
                style: GoogleFonts.roboto(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  final rating = index + 1;
                  return IconButton(
                    onPressed: () {
                      setState(() => _selectedRating = rating);
                    },
                    icon: Icon(
                      _selectedRating >= rating ? Icons.star : Icons.star_border,
                      color: _selectedRating >= rating ? Colors.orange : Colors.grey,
                      size: isTablet ? 36 : 30,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: isTablet ? 8 : 4),
                  );
                }),
              ),
              SizedBox(height: isTablet ? 24 : 20),
              Text(
                'your_feedback'.tr,
                style: GoogleFonts.roboto(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              TextField(
                controller: _feedbackController,
                maxLines: isTablet ? 6 : 5,
                style: GoogleFonts.lato(
                  fontSize: isTablet ? 16 : 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'feedback_hint'.tr,
                  hintStyle: GoogleFonts.roboto(
                    color: Colors.grey[400],
                    fontSize: isTablet ? 16 : 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(isTablet ? 20 : 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 32 : 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 18 : 14,
                      horizontal: isTablet ? 24 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _submitFeedback,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "submit_quiz".tr,
                        style: GoogleFonts.roboto(
                          fontSize: isTablet ? 18 : 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),SizedBox(width: 10,),Icon(Icons.arrow_forward,color: Colors.white,size: isTablet ? 18 : 16,)
                    ],
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