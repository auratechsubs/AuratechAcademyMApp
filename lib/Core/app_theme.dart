import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constant/constant_colors.dart' as k;

class AppTheme {
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: k.AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: k.AppColors.primary,
        onPrimary: Colors.white,
        surface: k.AppColors.surface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: k.AppColors.primaryDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: k.AppColors.surface),
        titleTextStyle: const TextStyle(
          color: k.AppColors.surface,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      textTheme: base.textTheme.copyWith(
        titleLarge: const TextStyle(color: k.AppColors.textPrimary),
        bodyMedium: const TextStyle(color: k.AppColors.textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: k.AppColors.primary,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
