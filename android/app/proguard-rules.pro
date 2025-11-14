## Fix missing Razorpay annotations
#-keep class proguard.annotation.** { *; }
#-dontwarn proguard.annotation.**
#
## Keep Razorpay classes
#-keep class com.razorpay.** { *; }
#-dontwarn com.razorpay.**
#-keepattributes *Annotation*
#-dontwarn com.razorpay.**
#-keep class com.razorpay.** {*;}
#-optimizations !method/inlining/
#-keep class com.google.android.gms.auth.api.phone.** { *; }
#-keepclasseswithmembers class * {
#  public void onPayment*(...);
#}
## Flutter Local Notifications fix
#-keep class com.dexterous.flutterlocalnotifications.** { *; }
## Play Core / SplitInstall
#-keep class com.google.android.play.** { *; }
#-dontwarn com.google.android.play.**
#
## Flutter deferred components (safe)
#-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
#
## Firebase Messaging and GSON type safety
## Preserve type signatures used by GSON
#-keepattributes Signature
#-keepattributes *Annotation*
#
## Keep GSON classes and TypeToken (no syntax errors now)
#-keep class com.google.gson.** { *; }
#
## Keep Flutter Local Notifications classes
#-keep class com.dexterous.flutterlocalnotifications.** { *; }
#
## Keep Firebase Messaging classes
#-keep class com.google.firebase.** { *; }
#
## Lifecycle (for background messaging)
#-keep class androidx.lifecycle.** { *; }
#
## Keep Flutter and plugin entrypoints
#-keep class io.flutter.plugins.** { *; }
#-keep class io.flutter.app.** { *; }
#-keep class io.flutter.embedding.engine.** { *; }


#####################
# Razorpay
#####################
-keep class proguard.annotation.** { *; }
-dontwarn proguard.annotation.**

-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
-keepattributes *Annotation*

-keep class com.google.android.gms.auth.api.phone.** { *; }
-keepclasseswithmembers class * {
  public void onPayment*(...);
}

#####################
# Flutter Local Notifications
#####################
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

#####################
# Play Core / SplitInstall (deferred components)
#####################
-keep class com.google.android.play.** { *; }
-dontwarn com.google.android.play.**

-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

#####################
# Firebase + Gson (TypeToken fix)
#####################
# Preserve generic signatures (VERY IMPORTANT for TypeToken)
-keepattributes Signature
-keepattributes *Annotation*

# Keep all Gson classes
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Keep Firebase Messaging & related
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Lifecycle (for background handler)
-keep class androidx.lifecycle.** { *; }

#####################
# TypeToken specific fix
#####################


#####################
# Flutter plugin entrypoints
#####################
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.engine.** { *; }
