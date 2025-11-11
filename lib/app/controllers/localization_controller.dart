// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import '../localization/app_translations.dart';
//
// class LocalizationController extends GetxController {
//   static const _storageKey = 'locale_code'; // 'en_US' / 'hi_IN'
//   final _box = GetStorage();
//
//   final Rx<Locale> _locale = AppTranslations.defaultLocale.obs;
//   Locale get locale => _locale.value;
//
//   @override
//   void onInit() {
//     super.onInit();
//     final code = _box.read<String>(_storageKey);
//     if (code != null) {
//       _locale.value = _codeToLocale(code);
//     } else {
//       // Device locale ko respect karna ho to:
//       final device = Get.deviceLocale ?? AppTranslations.defaultLocale;
//       _locale.value = (keys.containsKey(_localeKey(device)))
//           ? device
//           : AppTranslations.defaultLocale;
//     }
//     Get.updateLocale(_locale.value);
//   }
//
//   void changeLocale(Locale newLocale) {
//     _locale.value = newLocale;
//     _box.write(_storageKey, _localeKey(newLocale));
//     Get.updateLocale(newLocale);
//     update(); // 👈 triggers GetBuilder listeners just in case
//   }
//
//   // Helpers
//   String _localeKey(Locale l) => '${l.languageCode}_${l.countryCode}';
//   Locale _codeToLocale(String code) {
//     final parts = code.split('_');
//     return Locale(parts[0], parts.length > 1 ? parts[1] : '');
//   }
//
//   // Translations map access (optional)
//   Map<String, Map<String, String>> get keys => Get.translations ?? {};
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../localization/app_translations.dart';

class LocalizationController extends GetxController {
  static const _storageKey = 'locale_code'; // e.g. 'en_US'
  final _box = GetStorage();

  final Rx<Locale> _locale = AppTranslations.defaultLocale.obs;
  Locale get locale => _locale.value;

  // cache supported keys once
  final Set<String> _supportedKeys = AppTranslations().keys.keys.toSet();

  @override
  void onInit() {
    super.onInit();

    final saved = _box.read<String>(_storageKey);
    if (saved != null && _supportedKeys.contains(saved)) {
      _locale.value = _codeToLocale(saved);
    } else {
      final device = Get.deviceLocale ?? AppTranslations.defaultLocale;
      final candidate = _localeKey(device);
      _locale.value = _supportedKeys.contains(candidate)
          ? device
          : AppTranslations.defaultLocale;
    }
    Get.updateLocale(_locale.value);
  }

  void changeLocale(Locale newLocale) {
    _locale.value = newLocale;
    _box.write(_storageKey, _localeKey(newLocale));
    Get.updateLocale(newLocale);
    _locale.refresh();       // Rx ping
    update();                // for GetBuilder<>
    Get.forceAppUpdate();    // nuke-cache rebuild for widgets not listening
  }



  // Helpers
  String _localeKey(Locale l) {
    final cc = (l.countryCode?.isNotEmpty ?? false) ? l.countryCode : 'US';
    return '${l.languageCode}_$cc';
  }

  Locale _codeToLocale(String code) {
    final p = code.split('_');
    return Locale(p[0], p.length > 1 ? p[1] : 'US');
  }
}
