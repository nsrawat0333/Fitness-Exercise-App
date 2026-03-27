# Flutter ProGuard Rules for FitFi Fitness App

# Keep Flutter engine
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Keep Google Maps
-keep class com.google.android.gms.maps.** { *; }
-dontwarn com.google.android.gms.**

# Keep TFLite / ML Kit
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# Keep Geolocator
-keep class com.baseflow.geolocator.** { *; }

# Keep AudioPlayers
-keep class xyz.luan.audioplayers.** { *; }

# Keep Camera
-keep class io.flutter.plugins.camera.** { *; }

# General Android optimizations
-optimizationpasses 5
-allowaccessmodification
-dontusemixedcaseclassnames
-verbose

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}
