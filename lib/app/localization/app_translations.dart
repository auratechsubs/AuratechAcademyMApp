import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'locales/en_US.dart';
import 'locales/hi_IN.dart';
import 'locales/ur_IN.dart';
import 'locales/te_IN.dart';
import 'locales/mr_IN.dart';
import 'locales/gu_IN.dart';
import 'locales/ta_IN.dart';

class AppTranslations extends Translations {
  static const Locale defaultLocale = Locale('en', 'US');
  static const Locale hindiLocale   = Locale('hi', 'IN');
  static const Locale urduLocale    = Locale('ur', 'IN'); // RTL
  static const Locale teluguLocale  = Locale('te', 'IN');
  static const Locale marathiLocale = Locale('mr', 'IN');
  static const Locale gujaratiLocale= Locale('gu', 'IN');
  static const Locale tamilLocale   = Locale('ta', 'IN');

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'hi_IN': hiIN,
    'ur_IN': urIN,
    'te_IN': teIN,
    'mr_IN': mrIN,
    'gu_IN': guIN,
    'ta_IN': taIN,
  };
}
