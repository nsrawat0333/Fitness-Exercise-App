import cv2
import json
import argparse
import os
import random
import sys

from pose_detection import PoseDetector
from pushup_counter import PushUpStateMachine
from visualization import draw_overlays

def get_random_video(folder_path):
    if not os.path.isdir(folder_path):
        return None
    videos = [f for f in os.listdir(folder_path) if f.endswith(('.mp4', '.avi', '.mov'))]
    if not videos:
        return None
    return os.path.join(folder_path, random.choice(videos))

def main():
    parser = argparse.ArgumentParser(description="AI Push-Up Counter")
    parser.add_argument('--source', type=str, default='0', help='Video file path or camera index (default: 0)')
    parser.add_argument('--random-dir', type=str, help='Directory to pick a random video from (overrides --source)')
    parser.add_argument('--headless', action='store_true', help='Disable OpenCV window, useful for Flutter integration')
    parser.add_argument('--json-out', action='store_true', help='Print JSON to stdout for every frame')
    args = parser.parse_args()

    source = args.source
    if args.random_dir:
        rnd_vid = get_random_video(args.random_dir)
        if rnd_vid:
            source = rnd_vid
            print(f"[INFO] Selected random video: {source}", file=sys.stderr)
        else:
            print(f"[WARNING] No videos found in {args.random_dir}, falling back to {source}", file=sys.stderr)

    # Convert source to int if it's a camera index
    if source.isdigit():
        source = int(source)

    cap = cv2.VideoCapture(source)
    if not cap.isOpened():
        print(f"[ERROR] Could not open video source {source}", file=sys.stderr)
        sys.exit(1)

    detector = PoseDetector(model_path='yolov8n-pose.pt')
    state_machine = PushUpStateMachine()

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        results = detector.predict(frame)
        active_kpts, all_kpts, bbox = detector.extract_keypoints(results)
        
        state = state_machine.process_frame(active_kpts)

        if args.json_out:
            print(json.dumps(state))
            sys.stdout.flush()

        if not args.headless:
            frame = draw_overlays(frame, all_kpts, state)
            cv2.imshow('Push-Up Counter', frame)
            
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break

    cap.release()
    if not args.headless:
        cv2.destroyAllWindows()

if __name__ == "__main__":
    main()
