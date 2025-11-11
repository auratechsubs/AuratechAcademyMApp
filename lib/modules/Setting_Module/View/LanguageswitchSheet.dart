import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/localization_controller.dart';
import '../../../app/localization/app_translations.dart';

class LanguageSheet extends StatelessWidget {
  const LanguageSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = Get.find<LocalizationController>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('English'),
            onTap: () {
              loc.changeLocale(const Locale('en', 'US'));
              Navigator.pop(context);
            } ,
          ),
          ListTile(
            title: const Text('हिन्दी'),
            onTap: (){
              loc.changeLocale(AppTranslations.hindiLocale);
              Navigator.pop(context);
    }  ,
          ),
          ListTile(
              title: const Text('اردو'),
              onTap: (){
                loc.changeLocale(AppTranslations.urduLocale);
                Navigator.pop(context);
    }


                   ),
          ListTile(
              title: const Text('తెలుగు'),
              onTap: () {
                loc.changeLocale(AppTranslations.teluguLocale);
                Navigator.pop(context);
    } ),
          ListTile(
              title: const Text('मराठी'),
              onTap: (){
                loc.changeLocale(AppTranslations.marathiLocale);
                Navigator.pop(context);
    }  ),
          ListTile(
              title: const Text('ગુજરાતી'),
              onTap: (){
                loc.changeLocale(AppTranslations.gujaratiLocale);
                Navigator.pop(context);
    }  ),
          ListTile(
              title: const Text('தமிழ்'),
              onTap: (){
                loc.changeLocale(AppTranslations.tamilLocale);
                Navigator.pop(context);
    } ),

        ],
      ),
    );
  }
}
