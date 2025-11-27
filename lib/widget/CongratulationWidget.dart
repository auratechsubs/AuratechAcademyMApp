import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constant/constant_colors.dart';
import 'custombottombar.dart';

class CongratulationsScreen extends StatefulWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final bool showLoader;
  final int delaySeconds;
  final VoidCallback? onComplete;

  const CongratulationsScreen({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.showLoader = true,
    this.delaySeconds = 3,
    this.onComplete,
  });

  @override
  State<CongratulationsScreen> createState() => _CongratulationsScreenState();
}

class _CongratulationsScreenState extends State<CongratulationsScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: widget.delaySeconds), () {
      if (mounted) {
        widget.onComplete?.call();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomnavBar()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Container(
          margin: EdgeInsets.all(isTablet ? 40 : 28),
          padding: EdgeInsets.all(isTablet ? 40 : 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isTablet ? 28 : 24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          constraints: BoxConstraints(
            maxWidth: isTablet ? 600 : size.width * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                widget.imagePath,
                height: isTablet ? 160 : 120,
                fit: BoxFit.contain,
              ),
              SizedBox(height: isTablet ? 28 : 20),
              Text(
                widget.title,
                style: GoogleFonts.lato(
                  fontSize: isTablet ? 28 : 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Text(
                widget.subtitle,
                style: GoogleFonts.lato(
                  fontSize: isTablet ? 18 : 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.showLoader) ...[
                SizedBox(height: isTablet ? 32 : 24),
                CircularProgressIndicator(
                  color: AppColors.success,
                  strokeWidth: isTablet ? 5 : 4,
                ),
              ],
            ],
          ),
        ),
      ),

    );

  }

}