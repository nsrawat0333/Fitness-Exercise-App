import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

enum ExerciseState { unknown, up, down }

class RepCounterData {
  final int reps;
  final String feedback;
  final ExerciseState state;

  RepCounterData({
    required this.reps,
    required this.feedback,
    required this.state,
  });
}

class RepCounterService {
  int _reps = 0;
  ExerciseState _currentState = ExerciseState.unknown;
  int _framesInCurrentState = 0;
  
  final ValueNotifier<RepCounterData> trackingNotifier = 
    ValueNotifier(RepCounterData(reps: 0, feedback: "Position yourself", state: ExerciseState.unknown));

  // Reset tracking session
  void reset() {
    _reps = 0;
    _currentState = ExerciseState.unknown;
    _framesInCurrentState = 0;
    trackingNotifier.value = RepCounterData(reps: 0, feedback: "Ready", state: ExerciseState.unknown);
  }

  void processPose(Pose pose, String exerciseType) {
    final exType = exerciseType.toLowerCase();
    if (exType.contains("push")) {
      _processPushup(pose);
    } else if (exType.contains("pull") || exType.contains("chin")) {
      _processPullup(pose);
    } else {
      trackingNotifier.value = RepCounterData(
        reps: _reps, 
        feedback: "Unsupported exercise", 
        state: _currentState
      );
    }
  }

  void _processPushup(Pose pose) {
    // Get landmarks for both arms
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
    final leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];

    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
    final rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
    final rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
    
    // Check which arms have valid (non-null) landmarks
    bool leftValid = leftShoulder != null && leftElbow != null && leftWrist != null;
    bool rightValid = rightShoulder != null && rightElbow != null && rightWrist != null;
    
    if (!leftValid && !rightValid) {
      trackingNotifier.value = RepCounterData(
        reps: _reps, 
        feedback: "Show your arms to the camera", 
        state: _currentState
      );
      return;
    }

    // Calculate angle for whichever arm(s) are visible
    double? leftAngle;
    double? rightAngle;
    
    if (leftValid) {
      leftAngle = _calculateAngle(leftShoulder!, leftElbow!, leftWrist!);
    }
    if (rightValid) {
      rightAngle = _calculateAngle(rightShoulder!, rightElbow!, rightWrist!);
    }
    
    // Use the arm that's bending more (minimum angle) — this handles
    // the common case where the phone is placed to one side and only
    // one arm is clearly visible.
    double elbowAngle;
    if (leftAngle != null && rightAngle != null) {
      elbowAngle = min(leftAngle, rightAngle);
    } else {
      elbowAngle = leftAngle ?? rightAngle!;
    }
    
    String feedback = "Good form";
    
    // Push-up state machine:
    // UP position: arms extended, elbow angle > 150°
    // DOWN position: arms bent, elbow angle < 90°
    // Using hysteresis to avoid flickering between states
    
    if (elbowAngle > 150) {
      if (_currentState == ExerciseState.down) {
        _framesInCurrentState++;
        // Require 2 consecutive frames in UP to confirm a rep
        if (_framesInCurrentState >= 2) {
          _reps++;
          feedback = "Great rep! 💪";
          _framesInCurrentState = 0;
        }
      } else {
        _framesInCurrentState = 0;
      }
      _currentState = ExerciseState.up;
      if (feedback == "Good form") feedback = "Go down";
      
    } else if (elbowAngle < 90) {
      if (_currentState != ExerciseState.down) {
        _framesInCurrentState = 0;
      }
      _currentState = ExerciseState.down;
      feedback = "Push up! ⬆️";
    } else {
      // In between zone
      if (_currentState == ExerciseState.up) {
        feedback = "Go lower ⬇️";
      } else if (_currentState == ExerciseState.down) {
        feedback = "Push up! ⬆️";
      } else {
        feedback = "Get into position";
      }
    }

    trackingNotifier.value = RepCounterData(
      reps: _reps, 
      feedback: feedback, 
      state: _currentState
    );
  }

  void _processPullup(Pose pose) {
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
    final leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
    final rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
    final leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
    final rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];

    bool leftValid = leftShoulder != null && leftElbow != null && leftWrist != null;
    bool rightValid = rightShoulder != null && rightElbow != null && rightWrist != null;

    if (!leftValid && !rightValid) {
      trackingNotifier.value = RepCounterData(
        reps: _reps, 
        feedback: "Show your arms to the camera", 
        state: _currentState
      );
      return;
    }
    
    // For pull-ups, track elbow angle:
    // Hanging (DOWN): arms extended, angle > 150°
    // Pulled up (UP): arms bent, angle < 90°
    double? leftAngle;
    double? rightAngle;
    
    if (leftValid) {
      leftAngle = _calculateAngle(leftShoulder!, leftElbow!, leftWrist!);
    }
    if (rightValid) {
      rightAngle = _calculateAngle(rightShoulder!, rightElbow!, rightWrist!);
    }
    
    double elbowAngle;
    if (leftAngle != null && rightAngle != null) {
      elbowAngle = min(leftAngle, rightAngle);
    } else {
      elbowAngle = leftAngle ?? rightAngle!;
    }

    String feedback = "Good form";

    if (elbowAngle < 90) {
      if (_currentState == ExerciseState.down) {
        _framesInCurrentState++;
        if (_framesInCurrentState >= 2) {
          _reps++;
          feedback = "Great pull-up! 💪";
          _framesInCurrentState = 0;
        }
      } else {
        _framesInCurrentState = 0;
      }
      _currentState = ExerciseState.up;
      if (feedback == "Good form") feedback = "Hold!";
      
    } else if (elbowAngle > 150) {
      if (_currentState != ExerciseState.down) {
        _framesInCurrentState = 0;
      }
      _currentState = ExerciseState.down;
      feedback = "Pull up! ⬆️";
    } else {
      if (_currentState == ExerciseState.up) {
        feedback = "Go down slowly";
      } else if (_currentState == ExerciseState.down) {
        feedback = "Pull up! ⬆️";
      } else {
        feedback = "Hang from the bar";
      }
    }

    trackingNotifier.value = RepCounterData(
      reps: _reps, 
      feedback: feedback, 
      state: _currentState
    );
  }

  double _calculateAngle(PoseLandmark first, PoseLandmark middle, PoseLandmark last) {
    final result = atan2(last.y - middle.y, last.x - middle.x) -
        atan2(first.y - middle.y, first.x - middle.x);
        
    var angle = (result * 180 / pi).abs();

    if (angle > 180) {
      angle = 360 - angle;
    }

    return angle;
  }
}
