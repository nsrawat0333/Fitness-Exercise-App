import cv2

# COCO pairs for drawing skeleton
POSE_PAIRS = [
    (0, 1), (0, 2), (1, 3), (2, 4),  # Head
    (5, 6), (5, 7), (7, 9),  # Arms
    (6, 8), (8, 10),
    (5, 11), (6, 12), (11, 12),  # Torso
    (11, 13), (13, 15),  # Left Leg
    (12, 14), (14, 16)   # Right Leg
]

def draw_skeleton(frame, keypoints_raw, conf_thresh=0.5):
    """
    Draw skeleton connections based on standard COCO pose pairs.
    """
    if keypoints_raw is None:
        return frame
        
    for i in range(len(keypoints_raw)):
        x, y, conf = keypoints_raw[i]
        if conf > conf_thresh:
            cv2.circle(frame, (int(x), int(y)), 5, (0, 255, 0), cv2.FILLED)
            
    for pair in POSE_PAIRS:
        partA = pair[0]
        partB = pair[1]
        
        if keypoints_raw[partA][2] > conf_thresh and keypoints_raw[partB][2] > conf_thresh:
            cv2.line(frame, 
                     (int(keypoints_raw[partA][0]), int(keypoints_raw[partA][1])),
                     (int(keypoints_raw[partB][0]), int(keypoints_raw[partB][1])),
                     (255, 0, 0), 2)
                     
    return frame

def draw_overlays(frame, keypoints_raw, state_dict):
    """
    Draw all UI overlays: skeleton, rep count, stage, angle, progress bar.
    """
    frame = draw_skeleton(frame, keypoints_raw)
    
    if not state_dict:
        return frame
        
    # Setup fonts
    font = cv2.FONT_HERSHEY_SIMPLEX
    
    # Progress Bar background and fill
    bar_x, bar_y = 50, 100
    bar_w, bar_h = 30, 300
    
    progress = state_dict.get('progress', 0)
    fill_h = int((progress / 100.0) * bar_h)
    
    cv2.rectangle(frame, (bar_x, bar_y), (bar_x + bar_w, bar_y + bar_h), (200, 200, 200), 3) # Outline
    if fill_h > 0:
        cv2.rectangle(frame, (bar_x, bar_y + bar_h - fill_h), (bar_x + bar_w, bar_y + bar_h), (0, 255, 0), cv2.FILLED) # Fill
    
    # Render texts
    cv2.putText(frame, f"REPS: {state_dict['reps']}", (100, 50), font, 1.5, (0, 255, 255), 3)
    cv2.putText(frame, f"STATE: {state_dict['state'].upper()}", (100, 100), font, 1.0, (255, 200, 0), 2)
    cv2.putText(frame, f"ANGLE: {state_dict['elbow_angle']} deg", (100, 150), font, 1.0, (255, 200, 0), 2)
    
    # Posture warning
    if state_dict['warning']:
        text_size = cv2.getTextSize(state_dict['warning'], font, 1.0, 2)[0]
        cv2.putText(frame, state_dict['warning'], (100, 200), font, 1.0, (0, 0, 255), 3) # Thicker warning text
        
    return frame
