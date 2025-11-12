# Fix missing Razorpay annotations
-keep class proguard.annotation.** { *; }
-dontwarn proguard.annotation.**

# Keep Razorpay classes
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keep class com.google.android.gms.auth.api.phone.** { *; }
-keepclasseswithmembers class * {
  public void onPayment*(...);
}
# Flutter Local Notifications fix
-keep class com.dexterous.flutterlocalnotifications.** { *; }
# Play Core / SplitInstall
-keep class com.google.android.play.** { *; }
-dontwarn com.google.android.play.**

# Flutter deferred components (safe)
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

# Firebase Messaging and GSON type safety
# Preserve type signatures used by GSON
-keepattributes Signature
-keepattributes *Annotation*

# Keep GSON classes and TypeToken (no syntax errors now)
-keep class com.google.gson.** { *; }

# Keep Flutter Local Notifications classes
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Keep Firebase Messaging classes
-keep class com.google.firebase.** { *; }

# Lifecycle (for background messaging)
-keep class androidx.lifecycle.** { *; }

# Keep Flutter and plugin entrypoints
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.engine.** { *; }
