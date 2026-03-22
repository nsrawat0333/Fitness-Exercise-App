/// Utility helpers for the FitFi app.
class AppUtils {
  AppUtils._();

  /// Format number with commas (e.g. 5240 → "5,240").
  static String formatNumber(int number) {
    final str = number.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  /// Pad a number with leading zero (e.g. 8 → "08").
  static String padTwo(int number) => number.toString().padLeft(2, '0');
}
