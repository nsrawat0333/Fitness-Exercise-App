import '../models/gym_course_model.dart';

/// Focus area -> image mapping used as fallback when no per-course image exists.
const Map<String, String> gymFocusAreaImages = {
  'chest': 'assets/sections/gym focus area cards/gym_chest.jpg',
  'shoulders': 'assets/sections/gym focus area cards/gym_shoulders.jpg',
  'back': 'assets/sections/gym focus area cards/gym_back.jpg',
  'arms': 'assets/sections/gym focus area cards/gym_arms.jpg',
  'abs': 'assets/sections/gym focus area cards/gym_abs.jpg',
  'legs': 'assets/sections/gym focus area cards/gym_legs.jpg',
  'full_body': 'assets/sections/gym focus area cards/gym_full_body.jpg',
  'fat_burn': 'assets/sections/gym focus area cards/gym_fat_burn.jpg',
  'mobility': 'assets/sections/gym focus area cards/gym_mobility.jpg',
};

/// Extra course card images mapped by exact course name.
const Map<String, String> gymExtraCourseCardImages = {
  'Athletic Body Builder': 'assets/sections/extra course card images/Athletic Body Builder.jpg',
  'Athletic Fighter Body': 'assets/sections/extra course card images/Athletic Fighter Body.jpg',
  'Beginner Fat Loss': 'assets/sections/extra course card images/Beginner Fat Loss.jpg',
  'Belly Fat Destroyer': 'assets/sections/extra course card images/Belly Fat Destroyer.jpg',
  'Big Arms': 'assets/sections/extra course card images/Big Arms.jpg',
  'Cardio Blast': 'assets/sections/extra course card images/Cardio Blast.jpg',
  'Chest Thickness': 'assets/sections/extra course card images/Chest Thickness.jpg',
  'Chest+Arms Bulker': 'assets/sections/extra course card images/Chest+Arms Bulker.jpg',
  'Core of Steel': 'assets/sections/extra course card images/Core of Steel.jpg',
  'Core+Strength Bulk': 'assets/sections/extra course card images/Core+Strength Bulk.jpg',
  'Fat Burn Beast Mode': 'assets/sections/extra course card images/Fat Burn Beast Mode.jpg',
  'Flat Belly': 'assets/sections/extra course card images/Flat Belly.jpg',
  'Full Body Fat Melt': 'assets/sections/extra course card images/Full Body Fat Melt.jpg',
  'Glutes Builder': 'assets/sections/extra course card images/Glutes Builder.jpg',
  'Hero Physique': 'assets/sections/extra course card images/Hero Physique.jpg',
  'Leg Power Builder': 'assets/sections/extra course card images/Leg Power Builder.jpg',
  'Lower Body Shape': 'assets/sections/extra course card images/Lower Body Shape.jpg',
  'Mobility Pro': 'assets/sections/extra course card images/Mobility Pro.jpg',
  'Muscle Builder Pro': 'assets/sections/extra course card images/Muscle Builder Pro.jpg',
  'Muscle Mass Gain': 'assets/sections/extra course card images/Muscle Mass Gain.jpg',
  'Ritik Roshan Aesthetic': 'assets/sections/extra course card images/Ritik Roshan Aesthetic.jpg',
  'Slim & Fit Body': 'assets/sections/extra course card images/Slim & Fit Body.jpg',
  'Slim & Toned Legs': 'assets/sections/extra course card images/Slim & Toned Legs.jpg',
  'Speed & Agility': 'assets/sections/extra course card images/Speed & Agility.jpg',
  'Strength+Endurance Hybrid': 'assets/sections/extra course card images/Strength+Endurance Hybrid.jpg',
  'Toned Arms': 'assets/sections/extra course card images/Toned Arms.jpg',
  'Upper Body Strength': 'assets/sections/extra course card images/Upper Body Strength.jpg',
  'V-Shape Physique': 'assets/sections/extra course card images/V-Shape Physique.jpg',
  'Wide Back': 'assets/sections/extra course card images/Wide Back.jpg',
};

String? resolveGymCourseCardImage(GymCourseInfo course) {
  final namedImage = gymExtraCourseCardImages[course.name];
  if (namedImage != null) {
    return namedImage;
  }

  final focusArea = course.focusArea;
  if (focusArea == null) {
    return null;
  }

  return gymFocusAreaImages[focusArea];
}
