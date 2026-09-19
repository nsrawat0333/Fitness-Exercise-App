import math

def calculate_angle(p1, p2, p3):
    """
    Calculate the angle between three points. p2 is the vertex.
    Each point is [x, y, conf (optional)].
    """
    x1, y1 = p1[0], p1[1]
    x2, y2 = p2[0], p2[1]
    x3, y3 = p3[0], p3[1]
    
    # Calculate angle
    angle = math.degrees(math.atan2(y3 - y2, x3 - x2) - math.atan2(y1 - y2, x1 - x2))
    
    if angle < 0:
        angle += 360
        
    # Ensure angle is always between 0 and 180 degrees
    if angle > 180:
        angle = 360 - angle
        
    return angle

def check_alignment(shoulder, hip, ankle, threshold=150):
    """
    Check if the body is in a straight line.
    Calculates the angle at the hip (shoulder -> hip -> ankle).
    Returns True if angle >= threshold (posture is mostly straight), False otherwise.
    """
    hip_angle = calculate_angle(shoulder, hip, ankle)
    return hip_angle >= threshold, hip_angle
