import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constant/constant_colors.dart';

Future<void> showCustomCupertinoDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String cancelText,
  required String confirmText,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
  TextStyle? titleTextStyle,
  TextStyle? contentTextStyle,
  TextStyle? cancelTextStyle,
  TextStyle? confirmTextStyle,
}) async {
  final size = MediaQuery.of(context).size;
  final isTablet = size.width > 600;

  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        constraints: BoxConstraints(
          maxWidth: isTablet ? 500 : size.width * 0.85,
        ),
        alignment: Alignment.center,
        child: CupertinoAlertDialog(
          title: Padding(
            padding: EdgeInsets.only(bottom: isTablet ? 12 : 8),
            child: Text(
              title,
              style: titleTextStyle ??
                  GoogleFonts.lato(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
          content: Padding(
            padding: EdgeInsets.symmetric(vertical: isTablet ? 8 : 6),
            child: Text(
              content,
              style: contentTextStyle ??
                  GoogleFonts.lato(
                    fontSize: isTablet ? 16 : 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
            ),
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
                onCancel?.call();
              },
              child: Text(
                cancelText,
                style: cancelTextStyle ??
                    GoogleFonts.lato(
                      fontSize: isTablet ? 16 : 14,
                      color: CupertinoColors.activeBlue,
                    ),
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: Text(
                confirmText,
                style: confirmTextStyle ??
                    GoogleFonts.lato(
                      fontSize: isTablet ? 16 : 14,
                      color: CupertinoColors.destructiveRed,
                    ),
              ),
            ),
          ],
        ),
      );
    },
  );
}