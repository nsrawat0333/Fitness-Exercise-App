import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

enum ExerciseState { unknown, up, down }

enum _ExercisePattern {
  push,
  pull,
  squat,
  lunge,
  core,
  legRaise,
  jumpingJack,
  kneeDrive,
  burpee,
  plank,
  sidePlank,
  wallSit,
  vSit,
  cardio,
  generic,
}

class RepCounterData {
  final int reps;
  final String feedback;
  final ExerciseState state;
  final bool isPoseDetected;
  final bool isPoseCorrect;

  const RepCounterData({
    required this.reps,
    required this.feedback,
    required this.state,
    required this.isPoseDetected,
    required this.isPoseCorrect,
  });
}

class RepCounterService {
  int _reps = 0;
  ExerciseState _currentState = ExerciseState.unknown;
  double? _lastHipY;
  double? _lastShoulderY;
  double _motionScore = 0;
  
  final ValueNotifier<RepCounterData> trackingNotifier = 
    ValueNotifier(const RepCounterData(
      reps: 0,
      feedback: 'Detecting pose...',
      state: ExerciseState.unknown,
      isPoseDetected: false,
      isPoseCorrect: false,
    ));

  // Reset tracking session
  void reset() {
    _reps = 0;
    _currentState = ExerciseState.unknown;
    _lastHipY = null;
    _lastShoulderY = null;
    _motionScore = 0;
    trackingNotifier.value = const RepCounterData(
      reps: 0,
      feedback: 'Detecting pose...',
      state: ExerciseState.unknown,
      isPoseDetected: false,
      isPoseCorrect: false,
    );
  }

  void onNoPoseDetected() {
    trackingNotifier.value = RepCounterData(
      reps: _reps,
      feedback: 'Align your full body in frame',
      state: _currentState,
      isPoseDetected: false,
      isPoseCorrect: false,
    );
  }

  void processPose(
    Pose pose,
    String exerciseName, {
    bool isTimeBased = false,
  }) {
    _trackMotion(pose);

    final pattern = _resolvePattern(exerciseName);
    if (isTimeBased) {
      _processTimeBased(pose, pattern);
      return;
    }

    switch (pattern) {
      case _ExercisePattern.push:
        _processPushup(pose);
      case _ExercisePattern.pull:
        _processPullup(pose);
      case _ExercisePattern.squat:
      case _ExercisePattern.lunge:
        _processSquatLike(pose, pattern == _ExercisePattern.lunge);
      case _ExercisePattern.core:
      case _ExercisePattern.legRaise:
        _processCoreRep(pose);
      case _ExercisePattern.jumpingJack:
        _processJumpingJackRep(pose);
      case _ExercisePattern.kneeDrive:
        _processKneeDriveRep(pose);
      case _ExercisePattern.burpee:
        _processBurpeeRep(pose);
      case _ExercisePattern.plank:
      case _ExercisePattern.sidePlank:
      case _ExercisePattern.wallSit:
      case _ExercisePattern.vSit:
      case _ExercisePattern.cardio:
      case _ExercisePattern.generic:
        _processGenericRep(pose);
    }
  }

  void _processTimeBased(Pose pose, _ExercisePattern pattern) {
    bool isCorrect = false;
    String feedback = 'Adjust your position';

    switch (pattern) {
      case _ExercisePattern.plank:
        isCorrect = _isPlankPoseCorrect(pose);
        feedback = isCorrect ? 'Perfect plank, hold' : 'Keep body straight in plank';
      case _ExercisePattern.sidePlank:
        isCorrect = _isSidePlankPoseCorrect(pose);
        feedback = isCorrect ? 'Great side plank hold' : 'Lift hips and align side plank';
      case _ExercisePattern.wallSit:
        isCorrect = _isWallSitPoseCorrect(pose);
        feedback = isCorrect ? 'Great wall sit hold' : 'Bend knees to near 90 degrees';
      case _ExercisePattern.vSit:
      case _ExercisePattern.legRaise:
        isCorrect = _isVSitPoseCorrect(pose);
        feedback = isCorrect ? 'Strong core hold' : 'Raise legs and engage core';
      case _ExercisePattern.cardio:
      case _ExercisePattern.kneeDrive:
      case _ExercisePattern.jumpingJack:
      case _ExercisePattern.burpee:
        isCorrect = _motionScore > 1.8 && _hasCoreLandmarks(pose);
        feedback = isCorrect ? 'Good pace, keep moving' : 'Move faster with full range';
      case _ExercisePattern.push:
      case _ExercisePattern.pull:
      case _ExercisePattern.squat:
      case _ExercisePattern.lunge:
      case _ExercisePattern.core:
      case _ExercisePattern.generic:
        isCorrect = _hasCoreLandmarks(pose);
        feedback = isCorrect ? 'Good form, hold steady' : 'Keep full body visible';
    }

    trackingNotifier.value = RepCounterData(
      reps: _reps,
      feedback: feedback,
      state: _currentState,
      isPoseDetected: true,
      isPoseCorrect: isCorrect,
    );
  }

  void _processPushup(Pose pose) {
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
      _publish(
        feedback: 'Show your arms to the camera',
        isPoseCorrect: false,
      );
      return;
    }

    double? leftAngle;
    double? rightAngle;
    
    if (leftValid) {
      leftAngle = _calculateAngle(leftShoulder, leftElbow, leftWrist);
    }
    if (rightValid) {
      rightAngle = _calculateAngle(rightShoulder, rightElbow, rightWrist);
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
    
    String feedback = 'Good form';
    final previousState = _currentState;
    
    if (elbowAngle > 150) {
      if (_currentState == ExerciseState.down) {
        _reps++;
        feedback = 'Great rep';
      }
      _currentState = ExerciseState.up;
      if (feedback == 'Good form') feedback = 'Go down';
      
    } else if (elbowAngle < 90) {
      _currentState = ExerciseState.down;
      feedback = 'Push up';
    } else {
      if (_currentState == ExerciseState.up) {
        feedback = 'Go lower';
      } else if (_currentState == ExerciseState.down) {
        feedback = 'Push up';
      } else {
        feedback = 'Get into position';
      }
    }

    _publish(
      feedback: feedback,
      isPoseCorrect: elbowAngle > 70 && elbowAngle < 175,
      state: _currentState,
      forceRepPulse: previousState == ExerciseState.down && _currentState == ExerciseState.up,
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
      _publish(
        feedback: 'Show your arms to the camera',
        isPoseCorrect: false,
      );
      return;
    }
    
    double? leftAngle;
    double? rightAngle;
    
    if (leftValid) {
      leftAngle = _calculateAngle(leftShoulder, leftElbow, leftWrist);
    }
    if (rightValid) {
      rightAngle = _calculateAngle(rightShoulder, rightElbow, rightWrist);
    }
    
    double elbowAngle;
    if (leftAngle != null && rightAngle != null) {
      elbowAngle = min(leftAngle, rightAngle);
    } else {
      elbowAngle = leftAngle ?? rightAngle!;
    }

    String feedback = 'Good form';
    final previousState = _currentState;

    if (elbowAngle < 90) {
      if (_currentState == ExerciseState.down) {
        _reps++;
        feedback = 'Great rep';
      }
      _currentState = ExerciseState.up;
      if (feedback == 'Good form') feedback = 'Hold high';
      
    } else if (elbowAngle > 150) {
      _currentState = ExerciseState.down;
      feedback = 'Pull up';
    } else {
      if (_currentState == ExerciseState.up) {
        feedback = 'Go down slowly';
      } else if (_currentState == ExerciseState.down) {
        feedback = 'Pull up';
      } else {
        feedback = 'Get into position';
      }
    }

    _publish(
      feedback: feedback,
      isPoseCorrect: elbowAngle > 60 && elbowAngle < 175,
      state: _currentState,
      forceRepPulse: previousState == ExerciseState.down && _currentState == ExerciseState.up,
    );
  }

  void _processSquatLike(Pose pose, bool isLunge) {
    final kneeAngles = _visibleKneeAngles(pose);
    if (kneeAngles.isEmpty) {
      _publish(
        feedback: 'Keep legs visible to track reps',
        isPoseCorrect: false,
      );
      return;
    }

    final kneeAngle = kneeAngles.reduce(min);
    final previousState = _currentState;
    String feedback = isLunge ? 'Drop into lunge' : 'Go lower';

    if (kneeAngle > 158) {
      if (_currentState == ExerciseState.down) {
        _reps++;
        feedback = 'Great rep';
      } else {
        feedback = isLunge ? 'Step into next lunge' : 'Go lower';
      }
      _currentState = ExerciseState.up;
    } else if (kneeAngle < 100) {
      _currentState = ExerciseState.down;
      feedback = isLunge ? 'Drive back up' : 'Drive up';
    } else {
      feedback = isLunge ? 'Lower with control' : 'Controlled squat';
    }

    _publish(
      feedback: feedback,
      isPoseCorrect: kneeAngle > 55 && kneeAngle < 175,
      state: _currentState,
      forceRepPulse: previousState == ExerciseState.down && _currentState == ExerciseState.up,
    );
  }

  void _processCoreRep(Pose pose) {
    final hipAngles = _visibleHipAngles(pose);
    if (hipAngles.isEmpty) {
      _publish(
        feedback: 'Align side view for core tracking',
        isPoseCorrect: false,
      );
      return;
    }

    final hipAngle = hipAngles.reduce(min);
    final previousState = _currentState;
    String feedback = 'Engage core';

    if (hipAngle > 155) {
      if (_currentState == ExerciseState.down) {
        _reps++;
        feedback = 'Great rep';
      } else {
        feedback = 'Crunch in';
      }
      _currentState = ExerciseState.up;
    } else if (hipAngle < 115) {
      _currentState = ExerciseState.down;
      feedback = 'Extend with control';
    } else {
      feedback = 'Keep core tight';
    }

    _publish(
      feedback: feedback,
      isPoseCorrect: hipAngle > 45 && hipAngle < 175,
      state: _currentState,
      forceRepPulse: previousState == ExerciseState.down && _currentState == ExerciseState.up,
    );
  }

  void _processJumpingJackRep(Pose pose) {
    final ls = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rs = pose.landmarks[PoseLandmarkType.rightShoulder];
    final lw = pose.landmarks[PoseLandmarkType.leftWrist];
    final rw = pose.landmarks[PoseLandmarkType.rightWrist];
    final la = pose.landmarks[PoseLandmarkType.leftAnkle];
    final ra = pose.landmarks[PoseLandmarkType.rightAnkle];

    if ([ls, rs, lw, rw, la, ra].contains(null)) {
      _publish(
        feedback: 'Keep full body in frame',
        isPoseCorrect: false,
      );
      return;
    }

    final shoulderWidth = _distance(ls!, rs!);
    final ankleWidth = _distance(la!, ra!);
    final shoulderY = (ls.y + rs.y) / 2;

    final isOpen = ankleWidth > shoulderWidth * 1.6 && lw!.y < shoulderY && rw!.y < shoulderY;
    final isClosed = ankleWidth < shoulderWidth * 1.25 && lw!.y > shoulderY && rw!.y > shoulderY;

    final previousState = _currentState;
    String feedback = 'Open and close fully';

    if (isOpen) {
      _currentState = ExerciseState.up;
      feedback = 'Close stance';
    } else if (isClosed) {
      if (_currentState == ExerciseState.up) {
        _reps++;
        feedback = 'Great rep';
      } else {
        feedback = 'Open up';
      }
      _currentState = ExerciseState.down;
    }

    _publish(
      feedback: feedback,
      isPoseCorrect: isOpen || isClosed,
      state: _currentState,
      forceRepPulse: previousState == ExerciseState.up && _currentState == ExerciseState.down,
    );
  }

  void _processKneeDriveRep(Pose pose) {
    final lh = pose.landmarks[PoseLandmarkType.leftHip];
    final rh = pose.landmarks[PoseLandmarkType.rightHip];
    final lk = pose.landmarks[PoseLandmarkType.leftKnee];
    final rk = pose.landmarks[PoseLandmarkType.rightKnee];

    if ([lh, rh, lk, rk].contains(null)) {
      _publish(
        feedback: 'Keep hips and knees visible',
        isPoseCorrect: false,
      );
      return;
    }

    final leftRaised = lk!.y < lh!.y;
    final rightRaised = rk!.y < rh!.y;
    final isRaised = leftRaised || rightRaised;
    final previousState = _currentState;

    if (isRaised && _currentState != ExerciseState.up) {
      _reps++;
      _currentState = ExerciseState.up;
      _publish(
        feedback: 'Great rep',
        isPoseCorrect: true,
        state: _currentState,
        forceRepPulse: previousState != ExerciseState.up,
      );
      return;
    }

    if (!isRaised) {
      _currentState = ExerciseState.down;
    }

    _publish(
      feedback: isRaised ? 'Keep rhythm' : 'Drive knees higher',
      isPoseCorrect: isRaised || _motionScore > 1.3,
      state: _currentState,
    );
  }

  void _processBurpeeRep(Pose pose) {
    final knees = _visibleKneeAngles(pose);
    if (knees.isEmpty) {
      _publish(
        feedback: 'Keep full body visible',
        isPoseCorrect: false,
      );
      return;
    }

    final kneeAngle = knees.reduce(min);
    final previousState = _currentState;
    String feedback = 'Drop down';

    if (kneeAngle > 160 && _motionScore > 1.0) {
      if (_currentState == ExerciseState.down) {
        _reps++;
        feedback = 'Great rep';
      }
      _currentState = ExerciseState.up;
    } else if (kneeAngle < 100) {
      _currentState = ExerciseState.down;
      feedback = 'Explode up';
    } else {
      feedback = 'Keep moving';
    }

    _publish(
      feedback: feedback,
      isPoseCorrect: kneeAngle > 55 && kneeAngle < 175,
      state: _currentState,
      forceRepPulse: previousState == ExerciseState.down && _currentState == ExerciseState.up,
    );
  }

  void _processGenericRep(Pose pose) {
    final hasPose = _hasCoreLandmarks(pose);
    if (!hasPose) {
      _publish(
        feedback: 'Align full body in frame',
        isPoseCorrect: false,
      );
      return;
    }

    final previousState = _currentState;
    if (_motionScore > 2.4 && _currentState == ExerciseState.down) {
      _reps++;
      _currentState = ExerciseState.up;
      _publish(
        feedback: 'Great rep',
        isPoseCorrect: true,
        state: _currentState,
        forceRepPulse: true,
      );
      return;
    }

    if (_motionScore < 1.0) {
      _currentState = ExerciseState.down;
    }

    _publish(
      feedback: _motionScore > 1.0 ? 'Good movement' : 'Move through full range',
      isPoseCorrect: _motionScore > 1.0,
      state: _currentState,
      forceRepPulse: previousState == ExerciseState.down && _currentState == ExerciseState.up,
    );
  }

  void _publish({
    required String feedback,
    required bool isPoseCorrect,
    ExerciseState? state,
    bool forceRepPulse = false,
  }) {
    trackingNotifier.value = RepCounterData(
      reps: _reps,
      feedback: feedback,
      state: state ?? _currentState,
      isPoseDetected: true,
      isPoseCorrect: isPoseCorrect,
    );
  }

  _ExercisePattern _resolvePattern(String exerciseName) {
    final ex = exerciseName
        .toLowerCase()
        .replaceAll('_', ' ')
        .replaceAll('-', ' ');

    if (ex.contains('plank') && ex.contains('side')) return _ExercisePattern.sidePlank;
    if (ex.contains('wall sit')) return _ExercisePattern.wallSit;
    if (ex.contains('plank')) return _ExercisePattern.plank;
    if (ex.contains('v-sit') || ex.contains('v up') || ex.contains('v-up')) return _ExercisePattern.vSit;

    if (ex.contains('push')) return _ExercisePattern.push;
    if (ex.contains('pull') || ex.contains('chin')) return _ExercisePattern.pull;

    if (ex.contains('jumping jack')) return _ExercisePattern.jumpingJack;
    if (ex.contains('high knees') || ex.contains('mountain climber') || ex.contains('skipping')) {
      return _ExercisePattern.kneeDrive;
    }
    if (ex.contains('burpee') || ex.contains('sprawl')) return _ExercisePattern.burpee;

    if (ex.contains('squat') || ex.contains('step up')) return _ExercisePattern.squat;
    if (ex.contains('lunge') || ex.contains('split squat') || ex.contains('side lunge')) {
      return _ExercisePattern.lunge;
    }

    if (ex.contains('crunch') || ex.contains('twist')) return _ExercisePattern.core;
    if (ex.contains('leg raise') || ex.contains('knee raise')) return _ExercisePattern.legRaise;

    if (ex.contains('shuffle') || ex.contains('agility') || ex.contains('jump rope') || ex.contains('skater') || ex.contains('bear crawl')) {
      return _ExercisePattern.cardio;
    }

    return _ExercisePattern.generic;
  }

  void _trackMotion(Pose pose) {
    final leftHip = pose.landmarks[PoseLandmarkType.leftHip];
    final rightHip = pose.landmarks[PoseLandmarkType.rightHip];
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];

    if ([leftHip, rightHip, leftShoulder, rightShoulder].contains(null)) {
      _motionScore *= 0.9;
      return;
    }

    final hipY = (leftHip!.y + rightHip!.y) / 2;
    final shoulderY = (leftShoulder!.y + rightShoulder!.y) / 2;
    final torso = max((shoulderY - hipY).abs(), 1.0);

    if (_lastHipY != null && _lastShoulderY != null) {
      final delta = (hipY - _lastHipY!).abs() + (shoulderY - _lastShoulderY!).abs();
      final normalized = (delta / torso) * 100;
      _motionScore = (_motionScore * 0.7) + (normalized * 0.3);
    }

    _lastHipY = hipY;
    _lastShoulderY = shoulderY;
  }

  bool _hasCoreLandmarks(Pose pose) {
    return pose.landmarks[PoseLandmarkType.leftShoulder] != null &&
        pose.landmarks[PoseLandmarkType.rightShoulder] != null &&
        pose.landmarks[PoseLandmarkType.leftHip] != null &&
        pose.landmarks[PoseLandmarkType.rightHip] != null;
  }

  bool _isPlankPoseCorrect(Pose pose) {
    final left = _lineAngles(
      pose,
      PoseLandmarkType.leftShoulder,
      PoseLandmarkType.leftHip,
      PoseLandmarkType.leftAnkle,
    );
    final right = _lineAngles(
      pose,
      PoseLandmarkType.rightShoulder,
      PoseLandmarkType.rightHip,
      PoseLandmarkType.rightAnkle,
    );
    final angles = [...left, ...right];
    if (angles.isEmpty) return false;
    final bodyAngle = angles.reduce((a, b) => a + b) / angles.length;
    return bodyAngle > 150;
  }

  bool _isSidePlankPoseCorrect(Pose pose) {
    final left = _lineAngles(
      pose,
      PoseLandmarkType.leftShoulder,
      PoseLandmarkType.leftHip,
      PoseLandmarkType.leftAnkle,
    );
    final right = _lineAngles(
      pose,
      PoseLandmarkType.rightShoulder,
      PoseLandmarkType.rightHip,
      PoseLandmarkType.rightAnkle,
    );
    final angles = [...left, ...right];
    if (angles.isEmpty) return false;
    return angles.reduce(max) > 150;
  }

  bool _isWallSitPoseCorrect(Pose pose) {
    final knees = _visibleKneeAngles(pose);
    if (knees.isEmpty) return false;
    final avg = knees.reduce((a, b) => a + b) / knees.length;
    return avg >= 70 && avg <= 115;
  }

  bool _isVSitPoseCorrect(Pose pose) {
    final hips = _visibleHipAngles(pose);
    if (hips.isEmpty) return false;
    final avg = hips.reduce((a, b) => a + b) / hips.length;
    return avg >= 45 && avg <= 120;
  }

  List<double> _visibleKneeAngles(Pose pose) {
    final out = <double>[];

    final lh = pose.landmarks[PoseLandmarkType.leftHip];
    final lk = pose.landmarks[PoseLandmarkType.leftKnee];
    final la = pose.landmarks[PoseLandmarkType.leftAnkle];
    if (lh != null && lk != null && la != null) {
      out.add(_calculateAngle(lh, lk, la));
    }

    final rh = pose.landmarks[PoseLandmarkType.rightHip];
    final rk = pose.landmarks[PoseLandmarkType.rightKnee];
    final ra = pose.landmarks[PoseLandmarkType.rightAnkle];
    if (rh != null && rk != null && ra != null) {
      out.add(_calculateAngle(rh, rk, ra));
    }

    return out;
  }

  List<double> _visibleHipAngles(Pose pose) {
    final out = <double>[];

    final ls = pose.landmarks[PoseLandmarkType.leftShoulder];
    final lh = pose.landmarks[PoseLandmarkType.leftHip];
    final lk = pose.landmarks[PoseLandmarkType.leftKnee];
    if (ls != null && lh != null && lk != null) {
      out.add(_calculateAngle(ls, lh, lk));
    }

    final rs = pose.landmarks[PoseLandmarkType.rightShoulder];
    final rh = pose.landmarks[PoseLandmarkType.rightHip];
    final rk = pose.landmarks[PoseLandmarkType.rightKnee];
    if (rs != null && rh != null && rk != null) {
      out.add(_calculateAngle(rs, rh, rk));
    }

    return out;
  }

  List<double> _lineAngles(
    Pose pose,
    PoseLandmarkType a,
    PoseLandmarkType b,
    PoseLandmarkType c,
  ) {
    final p1 = pose.landmarks[a];
    final p2 = pose.landmarks[b];
    final p3 = pose.landmarks[c];
    if (p1 == null || p2 == null || p3 == null) return const [];
    return [_calculateAngle(p1, p2, p3)];
  }

  double _distance(PoseLandmark a, PoseLandmark b) {
    final dx = a.x - b.x;
    final dy = a.y - b.y;
    return sqrt((dx * dx) + (dy * dy));
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
