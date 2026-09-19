import cv2
import numpy as np
from ultralytics import YOLO

class PoseDetector:
    def __init__(self, model_path='yolov8n-pose.pt', conf_threshold=0.5):
        """
        Initializes the YOLOv8 Pose model.
        Args:
            model_path (str): Path to the YOLOv8 pose model weights.
            conf_threshold (float): Minimum confidence threshold for keypoint detection.
        """
        self.model = YOLO(model_path)
        self.conf_threshold = conf_threshold
        
        # COCO Keypoint mapping
        self.keypoint_mapping = {
            'nose': 0, 'left_eye': 1, 'right_eye': 2, 'left_ear': 3, 'right_ear': 4,
            'left_shoulder': 5, 'right_shoulder': 6, 'left_elbow': 7, 'right_elbow': 8,
            'left_wrist': 9, 'right_wrist': 10, 'left_hip': 11, 'right_hip': 12,
            'left_knee': 13, 'right_knee': 14, 'left_ankle': 15, 'right_ankle': 16
        }

    def predict(self, frame):
        """
        Runs YOLOv8 pose estimation on the given frame.
        Args:
            frame (np.ndarray): The input image/frame.
        Returns:
            results: Ultralytics result object or None.
        """
        results = self.model(frame, verbose=False)
        return results

    def extract_keypoints(self, results):
        """
        Extracts keypoints and normalizes them based on view (left/right).
        Args:
            results: Ultralytics result object.
        Returns:
            dict: Parsed keypoints for the most visible side, or None if no person detected.
                  Format: {'shoulder': [x, y, conf], 'elbow': [x, y, conf], ...}
            dict: Raw keypoints (all 17).
            list: Bounding box [x1, y1, x2, y2].
        """
        if not results or len(results[0].boxes) == 0:
            return None, None, None

        # Get the first person (assume one person per frame for pushups)
        # In a generic scenario, pick the one with highest confidence or largest box
        boxes = results[0].boxes.xyxy.cpu().numpy()
        keypoints_raw = results[0].keypoints.data.cpu().numpy()
        
        if len(keypoints_raw) == 0 or len(keypoints_raw[0]) == 0:
             return None, None, None

        # Take the first detected person
        person_kpts = keypoints_raw[0]
        bbox = boxes[0]

        parsed_kpts = {}
        for name, idx in self.keypoint_mapping.items():
            parsed_kpts[name] = person_kpts[idx]  # [x, y, conf]

        # Determine best view (Left vs Right)
        # For pushups, we need Shoulder, Elbow, Wrist, Hip, Knee, Ankle
        left_conf = sum([parsed_kpts['left_shoulder'][2], parsed_kpts['left_elbow'][2], parsed_kpts['left_wrist'][2], parsed_kpts['left_hip'][2]])
        right_conf = sum([parsed_kpts['right_shoulder'][2], parsed_kpts['right_elbow'][2], parsed_kpts['right_wrist'][2], parsed_kpts['right_hip'][2]])

        # We normalize to a generic 'side' based on which side is more visible
        side_prefix = 'left_' if left_conf > right_conf else 'right_'

        best_side_kpts = {
            'shoulder': parsed_kpts[f'{side_prefix}shoulder'],
            'elbow': parsed_kpts[f'{side_prefix}elbow'],
            'wrist': parsed_kpts[f'{side_prefix}wrist'],
            'hip': parsed_kpts[f'{side_prefix}hip'],
            'knee': parsed_kpts[f'{side_prefix}knee'],
            'ankle': parsed_kpts[f'{side_prefix}ankle']
        }
        
        # Add nose for multi-view orientation detection if needed
        best_side_kpts['nose'] = parsed_kpts['nose']
        
        active_side = 'LEFT' if left_conf > right_conf else 'RIGHT'
        best_side_kpts['active_side'] = active_side

        return best_side_kpts, parsed_kpts, bbox
