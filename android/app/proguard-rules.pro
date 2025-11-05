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