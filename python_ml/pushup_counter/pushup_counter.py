from .angle_utils import calculate_angle, check_alignment

class PushUpStateMachine:
    def __init__(self, up_threshold=160, down_threshold=90):
        self.up_threshold = up_threshold
        self.down_threshold = down_threshold
        
        self.reps = 0
        self.state = "up"  # Can be "up", "down", "transition"
        self.invalid_posture_frames = 0
        self.is_posture_valid = True
        
    def process_frame(self, keypoints):
        """
        Process the parsed keypoints from PoseDetector to update state machine.
        Args:
            keypoints (dict): Contains 'shoulder', 'elbow', 'wrist', 'hip', 'knee', 'ankle'.
        Returns:
            dict: Current state statistics.
        """
        if not keypoints:
            return self.get_state_dict(None, None, 0)
            
        # Get coordinates
        shoulder = keypoints['shoulder']
        elbow = keypoints['elbow']
        wrist = keypoints['wrist']
        hip = keypoints['hip']
        ankle = keypoints['ankle']
        
        # Calculate primary elbow angle
        elbow_angle = calculate_angle(shoulder, elbow, wrist)
        
        # Check posture alignment
        is_aligned, hip_angle = check_alignment(shoulder, hip, ankle)
        self.is_posture_valid = is_aligned
        
        if not is_aligned:
            self.invalid_posture_frames += 1
            # If posture is bad, we pause rep counting. 
            # The user might do a pushup with bad form, but it won't increment.
        else:
            self.invalid_posture_frames = 0
            
            # State Machine transitions
            if elbow_angle > self.up_threshold:
                if self.state == "down" or self.state == "transition":
                    # Completed a rep if transitioning from down to up
                    if self.state == "down":
                        self.reps += 1
                self.state = "up"
                
            elif elbow_angle < self.down_threshold:
                if self.state == "up" or self.state == "transition":
                    self.state = "down"
                    
            else:
                self.state = "transition"
                
        # Calculate progress (0 to 100%)
        # Normalizes the angle between up and down threshold.
        # If angle is up (e.g. 160), progress = 0.
        # If angle is down (e.g. 90), progress = 100.
        progress = 0
        if elbow_angle <= self.down_threshold:
            progress = 100
        elif elbow_angle >= self.up_threshold:
            progress = 0
        else:
            range_total = self.up_threshold - self.down_threshold
            # (160 - angle) / (160 - 90) * 100
            progress = ((self.up_threshold - elbow_angle) / range_total) * 100
            
        return self.get_state_dict(elbow_angle, hip_angle, progress)
        
    def get_state_dict(self, elbow_angle, hip_angle, progress):
        return {
            "reps": self.reps,
            "state": self.state,
            "elbow_angle": round(elbow_angle, 1) if elbow_angle else 0.0,
            "hip_angle": round(hip_angle, 1) if hip_angle else 0.0,
            "progress": min(100, max(0, round(progress))),
            "is_posture_valid": self.is_posture_valid,
            "warning": "Fix Posture (Keep back straight)" if not self.is_posture_valid else ""
        }
