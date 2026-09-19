# Keep Flutter and plugin entry points.
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep classes with native methods used by JNI-backed plugins.
-keepclasseswithmembernames class * {
    native <methods>;
}

# Retain runtime annotations used by generated serializers and reflection.
-keepattributes *Annotation*
-keepattributes Signature
