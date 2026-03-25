import 'package:geolocator/geolocator.dart';

class RunStatsEngine {
  /// Calculates distance between two points in kilometers.
  static double calculateDistanceKM(
      double startLat, double startLng, double endLat, double endLng) {
    double distanceInMeters =
        Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
    return distanceInMeters / 1000.0;
  }

  /// Calculates pace in minutes per kilometer (MM:SS).
  /// E.g., 5.5 means 5 minutes and 30 seconds per km.
  static double calculatePace(double distanceKm, int timeInSeconds) {
    if (distanceKm == 0) return 0.0;
    double timeInMinutes = timeInSeconds / 60.0;
    return timeInMinutes / distanceKm;
  }

  /// Formats pace into a readable MM:SS string.
  static String formatPace(double paceDecimal) {
    if (paceDecimal == 0.0) return "0:00";
    int minutes = paceDecimal.floor();
    int seconds = ((paceDecimal - minutes) * 60).round();
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  /// Calculates Average Speed in km/h
  static double calculateSpeedKph(double distanceKm, int timeInSeconds) {
    if (timeInSeconds == 0) return 0.0;
    double timeInHours = timeInSeconds / 3600.0;
    return distanceKm / timeInHours;
  }

  /// Estimates Calories burned using MET (Metabolic Equivalent of Task).
  /// MET for jogging is roughly 7.0 for generic pace, up to 11 for fast running.
  static int calculateCalories(double speedKph, double weightKg, int timeInSeconds) {
    if (timeInSeconds == 0) return 0;
    
    // Dynamic MET based on speed
    double met = 7.0; // Default slow jog
    if (speedKph > 8.0 && speedKph <= 10.0) met = 9.0;
    if (speedKph > 10.0) met = 11.0;

    double timeInHours = timeInSeconds / 3600.0;
    
    // Formula: Calories = MET * Weight(kg) * Time(hours)
    double calories = met * weightKg * timeInHours;
    return calories.round();
  }

  /// Calculates a Stamina Score (out of 100) based on custom logic.
  /// Higher distance and consistent pace yields higher scores.
  static int calculateStaminaScore(double distanceKm, double averagePace, double userWeightKg) {
    if (distanceKm == 0) return 0;

    // Base score from distance (40% weight) - Maxes out at 10km for a beginner app
    double distanceScore = (distanceKm / 10.0) * 40.0;
    if (distanceScore > 40) distanceScore = 40;

    // Pace score (40% weight) - Target pace is 6:00/km
    double targetPace = 6.0;
    double paceDifference = (targetPace - averagePace).abs();
    // Lose points for being too far off the target pace 
    double paceScore = 40.0 - (paceDifference * 5.0);
    if (paceScore < 0) paceScore = 0;
    if (paceScore > 40) paceScore = 40;

    // Effort modifier (20% weight, simplified as just base points to fill the 100)
    double effortScore = 20.0; 

    int totalScore = (distanceScore + paceScore + effortScore).round();
    return totalScore.clamp(0, 100);
  }
}
