import pptx
from pptx.util import Inches, Pt
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN, MSO_ANCHOR
from pptx.enum.shapes import MSO_SHAPE
import os

BASE = 'c:/Users/nsraw/StudioProjects/dhfif/synopsisAndPresentation'
TEMPLATE_PATH = os.path.join(BASE, 'PPT Format.pptx')
OUTPUT_PATH = os.path.join(BASE, 'FitFi_Presentation_Official.pptx')

def set_font(p, text, size_pt, bold=False, color_rgb=None, font_name='Calibri'):
    p.text = text
    p.font.size = Pt(size_pt)
    p.font.name = font_name
    p.font.bold = bold
    if color_rgb:
        p.font.color.rgb = color_rgb

def add_bullet_point(tf, bold_prefix, normal_text, size_pt=14, space_after=8):
    p = tf.add_paragraph()
    p.font.name = 'Calibri'
    p.font.size = Pt(size_pt)
    p.space_after = Pt(space_after)
    p.level = 0
    run1 = p.add_run()
    run1.text = bold_prefix + ": " if bold_prefix else ""
    run1.font.bold = True
    run1.font.size = Pt(size_pt)
    run1.font.color.rgb = RGBColor(0x00, 0x33, 0x66)
    
    run2 = p.add_run()
    run2.text = normal_text
    run2.font.bold = False
    run2.font.size = Pt(size_pt)
    run2.font.color.rgb = RGBColor(0x33, 0x33, 0x33)

def create_presentation():
    # Load the official university template to preserve DBUU branding and master slides
    prs = pptx.Presentation(TEMPLATE_PATH)
    
    # We will clear existing slides and rebuild them on the template layouts so they match the exact format
    # Layout 0: Title Slide
    # Layout 1: Title and Content
    # Layout 2: Two Content
    # Layout 3: Title Only
    # Layout 4: Blank
    
    # Slide dimensions: 13.33 x 7.5 inches (16:9 widescreen)
    
    # Remove initial template slides to build a clean, comprehensive 18-slide deck on template layouts
    while len(prs.slides) > 0:
        rId = prs.slides._sldIdLst[0].rId
        prs.part.drop_rel(rId)
        del prs.slides._sldIdLst[0]
        
    NAVY = RGBColor(0x00, 0x20, 0x60)
    DARK_BLUE = RGBColor(0x1F, 0x49, 0x7D)
    GRAY_TEXT = RGBColor(0x59, 0x59, 0x59)
    LIGHT_BG = RGBColor(0xF2, 0xF4, 0xF8)
    WHITE = RGBColor(0xFF, 0xFF, 0xFF)
    GREEN_ACCENT = RGBColor(0x00, 0x80, 0x00)
    
    # =========================================================================
    # SLIDE 1: TITLE SLIDE (Layout 0)
    # =========================================================================
    s1 = prs.slides.add_slide(prs.slide_layouts[0])
    
    # University title container
    tb_title = s1.shapes.add_textbox(Inches(1.0), Inches(1.2), Inches(11.33), Inches(1.8))
    tf1 = tb_title.text_frame; tf1.word_wrap = True
    p1 = tf1.paragraphs[0]; p1.alignment = PP_ALIGN.CENTER
    set_font(p1, "FitFi: AI-Powered Smart Fitness Coach", 36, True, NAVY)
    p1_sub = tf1.add_paragraph(); p1_sub.alignment = PP_ALIGN.CENTER
    set_font(p1_sub, "A Comprehensive Mobile Fitness and Wellness Application", 18, False, DARK_BLUE)
    p1_rev = tf1.add_paragraph(); p1_rev.alignment = PP_ALIGN.CENTER
    p1_rev.space_before = Pt(8)
    set_font(p1_rev, "MAJOR PROJECT - I  |  SYNOPSIS PRESENTATION (REVIEW - I)", 15, True, RGBColor(0xC0, 0x00, 0x00))

    # Student Details Box
    tb_stu = s1.shapes.add_textbox(Inches(1.2), Inches(3.4), Inches(5.2), Inches(2.2))
    tf_stu = tb_stu.text_frame; tf_stu.word_wrap = True
    p_stu_h = tf_stu.paragraphs[0]
    set_font(p_stu_h, "Submitted By:", 15, True, NAVY)
    for s_name in ["Student Name 1 (Roll No.: ………………)", "Student Name 2 (Roll No.: ………………)", "Student Name 3 (Roll No.: ………………)"]:
        p = tf_stu.add_paragraph()
        p.space_before = Pt(4)
        set_font(p, s_name, 13, False, GRAY_TEXT)

    # Supervisor Details Box
    tb_sup = s1.shapes.add_textbox(Inches(7.0), Inches(3.4), Inches(5.2), Inches(2.2))
    tf_sup = tb_sup.text_frame; tf_sup.word_wrap = True
    p_sup_h = tf_sup.paragraphs[0]
    set_font(p_sup_h, "Supervised By:", 15, True, NAVY)
    for sup_line in [
        "Supervisor Name",
        "Professor (CSE), SoEC (Supervisor)",
        "Co-Supervisor Name (If Any)",
        "Professor (CSE), SoEC (Co-Supervisor)",
        "Dev Bhoomi Uttarakhand University"
    ]:
        p = tf_sup.add_paragraph()
        p.space_before = Pt(2)
        is_name = "Name" in sup_line
        set_font(p, sup_line, 13 if is_name else 12, is_name, NAVY if is_name else GRAY_TEXT)

    # Footer
    tb_foot = s1.shapes.add_textbox(Inches(1.0), Inches(6.4), Inches(11.33), Inches(0.5))
    p_foot = tb_foot.text_frame.paragraphs[0]; p_foot.alignment = PP_ALIGN.CENTER
    set_font(p_foot, "Department of Computer Science & Engineering | School of Engineering & Computing | DBUU", 12, False, GRAY_TEXT)

    # =========================================================================
    # SLIDE 2: TABLE OF CONTENT (Layout 1)
    # =========================================================================
    s2 = prs.slides.add_slide(prs.slide_layouts[1])
    s2.shapes.title.text = "Table of Content"
    tf2 = s2.placeholders[1].text_frame; tf2.word_wrap = True
    tf2.text = "" # Clear default text
    
    toc_topics = [
        ("Background and Motivation of Research", "Context and necessity of an integrated fitness platform"),
        ("Literature Review & Existing Systems", "Comparative analysis with Google Fit, MyFitnessPal, Nike Training Club"),
        ("Research and Development Gaps", "Key limitations in current solutions resolved by FitFi"),
        ("Project Objectives", "Concrete, measurable technical milestones accomplished"),
        ("Proposed Methodology & System Architecture", "Layered software design (Presentation, Service, Data, Storage)"),
        ("Core System Modules & Capabilities", "AI pose detection, camera PPG heart rate, pedometer, gym, UFC, gamification"),
        ("Technologies & Implementation Stack", "Flutter, Dart, Google ML Kit, camera, sensors_plus, SharedPreferences"),
        ("Application Demonstration & Live Video Recording", "Live execution walkthroughs and video playback demonstration"),
        ("Research Plan with Time Frame", "Disciplined 4-month academic implementation schedule"),
        ("Outcome and Conclusion", "Deliverables, technological novelty, and future ML expansion"),
    ]
    for idx, (head, sub) in enumerate(toc_topics, 1):
        add_bullet_point(tf2, f"{idx}. {head}", sub, 13, 4)

    # =========================================================================
    # SLIDE 3: BACKGROUND AND MOTIVATION (Layout 1)
    # =========================================================================
    s3 = prs.slides.add_slide(prs.slide_layouts[1])
    s3.shapes.title.text = "Background and Motivation of Research"
    tf3 = s3.placeholders[1].text_frame; tf3.word_wrap = True
    tf3.text = ""

    add_bullet_point(tf3, "Proliferation of Mobile Healthcare", 
                     "Smartphones have evolved into ubiquitous health companions equipped with high-resolution cameras, triaxial accelerometers, and high-performance mobile GPUs.", 14, 10)
    add_bullet_point(tf3, "The Fitness App Fragmentation Crisis", 
                     "Users are forced to install 3 to 4 independent applications: one for step counting, a second for water logging, a third for workout routines, and a fourth for heart rate. This causes data isolation and tracking fatigue.", 14, 10)
    add_bullet_point(tf3, "Emergence of Edge Artificial Intelligence", 
                     "Advancements in on-device deep learning (e.g., Google ML Kit) allow spatial body landmark inference directly on mobile chips at 30+ FPS without transmitting video frames to the cloud.", 14, 10)
    add_bullet_point(tf3, "Core Project Motivation", 
                     "To design 'FitFi' as a unified, private, offline-first mobile fitness coach that synthesizes real-time computer vision pose estimation, camera PPG vitals, pedometer sensing, and gamification into a single high-performance Flutter application.", 14, 10)

    # =========================================================================
    # SLIDE 4: LITERATURE REVIEW (Layout 1)
    # =========================================================================
    s4 = prs.slides.add_slide(prs.slide_layouts[1])
    s4.shapes.title.text = "Literature Review"
    tf4 = s4.placeholders[1].text_frame; tf4.word_wrap = True
    tf4.text = ""

    add_bullet_point(tf4, "Google Fit (Passive Activity Tracking)", 
                     "Excels at passive pedometer monitoring and Google ecosystem synchronization; completely lacks real-time exercise form feedback, strength training state machines, and optical heart rate measurement.", 13, 8)
    add_bullet_point(tf4, "MyFitnessPal (Nutritional Logging)", 
                     "Features an extensive global food database and macro tracking; offers zero computer vision feedback, no biometric heart rate scanning, and relies entirely on manual user inputs.", 13, 8)
    add_bullet_point(tf4, "Nike Training Club (Instructional Content)", 
                     "Provides studio-quality workout demonstration video libraries; lacks computational intelligence to evaluate whether user execution form is correct or to count repetitions automatically.", 13, 8)
    add_bullet_point(tf4, "Freeletics (Algorithmic Plan Generation)", 
                     "Generates dynamic bodyweight training programs; AI is restricted to routine scheduling and does not perform live camera pose verification during physical execution.", 13, 8)
    add_bullet_point(tf4, "Clinical Photoplethysmography Studies (Allen, 2007)", 
                     "Establishes that smartphone optical sensors can resolve pulse waveforms from capillary light absorption fluctuations, confirming camera PPG feasibility on consumer handsets.", 13, 8)

    # =========================================================================
    # SLIDE 5: RESEARCH GAPS (Layout 1)
    # =========================================================================
    s5 = prs.slides.add_slide(prs.slide_layouts[1])
    s5.shapes.title.text = "Research Gaps"
    tf5 = s5.placeholders[1].text_frame; tf5.word_wrap = True
    tf5.text = ""

    add_bullet_point(tf5, "Gap 1: Absence of Real-Time Biomechanical Form Correction", 
                     "Mainstream workout apps display non-interactive instructional videos, failing to alert users to injurious posture deviations (e.g., sagging hip in planks, incomplete elbow flexion in push-ups).", 13.5, 8)
    add_bullet_point(tf5, "Gap 2: Hardware Access Barrier for Biometrics", 
                     "Cardiovascular heart rate tracking is gated behind expensive smartwatches or chest bands, ignoring the native PPG capability of built-in smartphone camera flash sensors.", 13.5, 8)
    add_bullet_point(tf5, "Gap 3: Isolated Application Architecture", 
                     "No consumer platform effectively integrates daily step counting, hydration reminders, vital signs monitoring, AI repetition counting, and combat conditioning into one unified tool.", 13.5, 8)
    add_bullet_point(tf5, "Gap 4: Superficial Engagement Mechanics", 
                     "Standard day-streak counters fail to prevent user dropout within the critical first month; comprehensive RPG-style progression is absent from fitness software.", 13.5, 8)
    add_bullet_point(tf5, "Gap 5: Cloud Latency and Biometric Privacy Risks", 
                     "Cloud-dependent platforms introduce network latency and expose sensitive health metrics, underscoring the urgent need for 100% offline, on-device architectures.", 13.5, 8)

    # =========================================================================
    # SLIDE 6: PROJECT OBJECTIVE (Layout 1)
    # =========================================================================
    s6 = prs.slides.add_slide(prs.slide_layouts[1])
    s6.shapes.title.text = "Project Objective"
    tf6 = s6.placeholders[1].text_frame; tf6.word_wrap = True
    tf6.text = ""

    add_bullet_point(tf6, "1. Unified Mobile Health Engineering", 
                     "To construct an all-in-one Flutter application consolidating pedometer tracking, water intake reminders, camera PPG heart rate, AI exercise analysis, gym courses, combat training, and diet.", 13.5, 8)
    add_bullet_point(tf6, "2. On-Device AI Pose Landmark Detection", 
                     "To integrate Google ML Kit Pose Detection for real-time tracking of 33 body coordinates at interactive camera frame rates without server dependencies.", 13.5, 8)
    add_bullet_point(tf6, "3. Biomechanical Angle and Repetition State Machine", 
                     "To develop a trigonometric RepCounterService (atan2) evaluating joint angles to automate repetition counting and posture validation across 11 major exercises.", 13.5, 8)
    add_bullet_point(tf6, "4. Smartphone Camera PPG Pulse Extraction", 
                     "To implement optical heart rate monitoring using the rear camera torch, sampling luminance over a 50x50 region of interest to derive real-time BPM and cardiovascular stress estimates.", 13.5, 8)
    add_bullet_point(tf6, "5. Motion-Sensing Accelerometer Pedometer", 
                     "To deploy triaxial acceleration vector thresholding (>12.0 m/s2) with a 300ms debounce filter for accurate distance and caloric expenditure calculations.", 13.5, 8)
    add_bullet_point(tf6, "6. Immersive Gamification and Offline Operation", 
                     "To build a 10-level, 11-rank Solo Leveling XP progression engine and ensure all features operate with 100% offline reliability.", 13.5, 8)

    # =========================================================================
    # SLIDE 7: PROPOSED METHODOLOGY & ARCHITECTURE (Layout 1)
    # =========================================================================
    s7 = prs.slides.add_slide(prs.slide_layouts[1])
    s7.shapes.title.text = "Proposed Methodology"
    tf7 = s7.placeholders[1].text_frame; tf7.word_wrap = True
    tf7.text = ""

    add_bullet_point(tf7, "Layer 1: Presentation Tier (Flutter UI)", 
                     "Reactive screens with custom hardware-accelerated CustomPainters: _RealPosePainter (neon skeletal overlay), _EcgPainter (live cardiac waveform), _WavePainter (liquid hydration fill), and _TrendChartPainter (Bezier step trends).", 13.5, 8)
    add_bullet_point(tf7, "Layer 2: Service Tier (Domain Logic)", 
                     "Modular singleton services: PoseDetectionService (ML Kit), RepCounterService (biomechanical angles), HeartRateService (PPG frame extraction), StepCounterService (accelerometer), WaterStorageService, XPService, and NotificationService.", 13.5, 8)
    add_bullet_point(tf7, "Layer 3: Data Tier (Static Assets)", 
                     "Houses 256 mapped exercises with animated Lottie vector JSONs and GIFs, structured multi-week gym syllabi, UFC combat courses, and nutritional dietary matrices.", 13.5, 8)
    add_bullet_point(tf7, "Layer 4: Storage Tier (Offline Persistence)", 
                     "Employs SharedPreferences for zero-cloud local persistence of workout histories, daily step logs, hydration timestamps, and user XP ranks.", 13.5, 8)
    add_bullet_point(tf7, "Layer 5: Hardware & Performance Optimization", 
                     "DeviceProfiler detects handset hardware tiers (low, mid, high) to dynamically throttle image caching and animation complexity, ensuring sustained 60 FPS performance.", 13.5, 8)

    # =========================================================================
    # SLIDE 8: MODULE 1: AI EXERCISE DETECTION (Layout 1)
    # =========================================================================
    s8 = prs.slides.add_slide(prs.slide_layouts[1])
    s8.shapes.title.text = "Module 1: Real-Time AI Exercise Detection"
    tf8 = s8.placeholders[1].text_frame; tf8.word_wrap = True
    tf8.text = ""

    add_bullet_point(tf8, "Google ML Kit Spatial Landmark Ingestion", 
                     "Streams camera frames (NV21 on Android) into Google ML Kit PoseDetector in streaming mode, resolving 33 three-dimensional anatomical body landmarks in real time.", 13.5, 8)
    add_bullet_point(tf8, "Trigonometric Joint Angle Computation", 
                     "RepCounterService calculates instantaneous joint angles via atan2 math across joint triads (e.g., shoulder-elbow-wrist, hip-knee-ankle, shoulder-hip-ankle).", 13.5, 8)
    add_bullet_point(tf8, "State Machine Thresholding Logic", 
                     "Push-ups: Down state (<90° elbow angle) to Up state (>150° extension) increments rep count. Squats: Down (<100° knee flexion) to Up (>158° extension).", 13.5, 8)
    add_bullet_point(tf8, "Isometric Hold Form Validation", 
                     "Planks: Shoulder-hip-ankle linearity must exceed 150° to maintain active timer. Wall Sits: Knee angle must remain strictly within 70°–115° flexion range.", 13.5, 8)
    add_bullet_point(tf8, "Visual and Contextual Real-Time Feedback", 
                     "Live CustomPainter paints green skeleton for proper execution and red skeleton for posture errors, alongside on-screen corrective guidance ('Go lower', 'Push up', 'Keep body straight').", 13.5, 8)

    # =========================================================================
    # SLIDE 9: MODULE 2: HEART RATE & STEP COUNTER (Layout 1)
    # =========================================================================
    s9 = prs.slides.add_slide(prs.slide_layouts[1])
    s9.shapes.title.text = "Module 2: Optical PPG Heart Rate & Step Counter"
    tf9 = s9.placeholders[1].text_frame; tf9.word_wrap = True
    tf9.text = ""

    add_bullet_point(tf9, "Optical PPG Heart Rate Principle", 
                     "Activates the rear camera flashlight (torch mode); when the user covers the lens, capillary blood volume pulses modulate red channel intensity across a 50x50 center pixel region.", 13.5, 8)
    add_bullet_point(tf9, "Signal Processing & Peak Detection", 
                     "HeartRateService computes a dynamic moving average threshold; upward zero-crossings identify systolic beats, calculating real-time BPM, signal quality, and cardiovascular stress.", 13.5, 8)
    add_bullet_point(tf9, "3-Stage Heart Rate User Experience", 
                     "Features an Instruction state with positioning prompts, a Scanning state with animated radar sweep and audio equalizer bars, and a Result state with recovery scores and 7-day trend graphs.", 13.5, 8)
    add_bullet_point(tf9, "Triaxial Accelerometer Pedometer", 
                     "StepCounterService streams 3D acceleration data (x, y, z), evaluates dynamic vector magnitude sqrt(x^2 + y^2 + z^2), and records steps above a 12.0 m/s2 threshold with a 300ms debounce filter.", 13.5, 8)
    add_bullet_point(tf9, "Comprehensive Pedometer Metrics", 
                     "Computes estimated distance (km) and calories burned, paired with an animated circular progress arc (10,000 steps goal), weekly/monthly toggles, and cubic Bezier trend visualizations.", 13.5, 8)

    # =========================================================================
    # SLIDE 10: MODULE 3: GYM & UFC COMBAT (Layout 1)
    # =========================================================================
    s10 = prs.slides.add_slide(prs.slide_layouts[1])
    s10.shapes.title.text = "Module 3: Gym Workout System & UFC Combat"
    tf10 = s10.placeholders[1].text_frame; tf10.word_wrap = True
    tf10.text = ""

    add_bullet_point(tf10, "Personalized Onboarding Wizard", 
                     "8-stage introductory diagnostic collecting gender, height/weight (live BMI calculation), interactive body focus silhouette (chest, arms, abs, legs, back), goals, and push-up baseline.", 13.5, 8)
    add_bullet_point(tf10, "Extensive 256-Exercise Library", 
                     "Comprehensive indexed database categorized by muscle group and body type (Fat, Fit, Lean), equipped with animated Lottie vector JSONs and high-definition GIFs.", 13.5, 8)
    add_bullet_point(tf10, "5-Phase Guided Workout Player", 
                     "Guides users through timed intervals: Breathing (20s) → Exercise Preview (20s) → Active Perform (30s) → Recovery Rest (20s) → Next Exercise Preview (20s).", 13.5, 8)
    add_bullet_point(tf10, "Algorithmic Progressive Overload", 
                     "HomeWorkoutService dynamically plans 1 to 12-week schedules, systematically increasing repetition targets by up to +30% and tapering rest periods by up to -10s over successive weeks.", 13.5, 8)
    add_bullet_point(tf10, "UFC Combat Training Module", 
                     "Dedicated combat fitness curriculums: Dagestani Style (Khabib inspired: wrestling, grappling endurance, core pressure) and Irish Style (McGregor inspired: striking, precision, explosive power).", 13.5, 8)

    # =========================================================================
    # SLIDE 11: MODULE 4: HYDRATION & GAMIFICATION (Layout 1)
    # =========================================================================
    s11 = prs.slides.add_slide(prs.slide_layouts[1])
    s11.shapes.title.text = "Module 4: Hydration & Gamified XP System"
    tf11 = s11.placeholders[1].text_frame; tf11.word_wrap = True
    tf11.text = ""

    add_bullet_point(tf11, "Hydration Logging & Sinusoidal Animation", 
                     "Interactive water logging with calibrated vessel sizes (Cup: 150ml, Glass: 250ml, Bottle: 500ml), rendered via an animated CustomPainter wave reflecting current intake against daily targets.", 13.5, 8)
    add_bullet_point(tf11, "Automated Notification System", 
                     "Integrates flutter_local_notifications and timezone to schedule daily periodic reminders every 2 hours between 8:00 AM and 8:00 PM, fully compliant with Android 13+ exact alarms.", 13.5, 8)
    add_bullet_point(tf11, "Solo Leveling-Inspired XP Architecture", 
                     "Implements 10 leveling thresholds (100 XP to 100,000 XP) and 11 distinct ranks (Unranked, F Rank through SSS Rank and X Rank) across dual Gym and Challenge progression tracks.", 13.5, 8)
    add_bullet_point(tf11, "Ranked Challenge Tiers & Standalone Modes", 
                     "Features 6 progressive difficulty tiers: Junior Trainee (Lvl 10) to UFC Fighter (Lvl 100), complemented by 15 individual quick challenges validated through the AI camera.", 13.5, 8)
    add_bullet_point(tf11, "Growth Dashboard & Multi-Language Support", 
                     "Aggregates total daily steps, hydration volume, average BPM, and AI reps into an analytics hub; supports runtime language toggling between English and Hindi.", 13.5, 8)

    # =========================================================================
    # SLIDE 12: TECHNOLOGIES & TOOLS (Layout 1)
    # =========================================================================
    s12 = prs.slides.add_slide(prs.slide_layouts[1])
    s12.shapes.title.text = "Technologies and Tools Used"
    tf12 = s12.placeholders[1].text_frame; tf12.word_wrap = True
    tf12.text = ""

    tech_pairs = [
        ("Language & Core Framework", "Dart SDK (v3.11.3+) & Flutter SDK (Cross-platform mobile engine)"),
        ("Computer Vision & AI", "google_mlkit_pose_detection (^0.14.1) — On-device 33-point body landmark inference"),
        ("Optical Camera Subsystem", "camera (^0.12.0+1) — Live streaming for pose detection and PPG torch extraction"),
        ("Motion Sensor Streaming", "sensors_plus (^7.0.0) — Triaxial accelerometer streaming for step detection"),
        ("Local Offline Persistence", "shared_preferences (^2.5.4) — Key-value local storage (zero cloud dependency)"),
        ("Scheduling & Alarms", "flutter_local_notifications (^21.0.0) & timezone (^0.11.0) — Exact zoned reminders"),
        ("Vector Animation Engine", "lottie (^3.3.2) — Hardware-accelerated vector exercise animations"),
        ("Visual Indicators & UI", "percent_indicator (^4.2.3) & table_calendar (^3.1.2) — Custom rings and calendar"),
        ("Hardware Requirements", "Android 5.0+ (API 21+), Camera with Flash, Accelerometer, 2GB+ RAM, 200MB storage"),
    ]
    for cat, desc in tech_pairs:
        add_bullet_point(tf12, cat, desc, 13, 6)

    # =========================================================================
    # SLIDE 13: APP DEMO VIDEO 1 (Layout 3 - Title Only)
    # =========================================================================
    s13 = prs.slides.add_slide(prs.slide_layouts[3])
    s13.shapes.title.text = "Live Demonstration: Navigation, Steps & Vitals"
    
    vid1_rel = "fitfi app/WhatsApp Video 2026-09-13 at 2.36.10 PM.mp4"
    vid1_abs = os.path.abspath(os.path.join(BASE, vid1_rel))
    poster1_abs = os.path.abspath(os.path.join(BASE, 'poster1.png'))
    
    # Left side: Embedded Video / Poster
    try:
        s13.shapes.add_movie(
            vid1_abs,
            Inches(0.8), Inches(1.8), Inches(5.8), Inches(4.3),
            poster_frame_image=poster1_abs,
            mime_type='video/mp4'
        )
    except Exception as e:
        print(f"Slide 13 movie embed note: {e}")
        r13 = s13.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(1.8), Inches(5.8), Inches(4.3))
        r13.fill.solid(); r13.fill.fore_color.rgb = LIGHT_BG
    
    # Click to Play Action Button under video
    btn1 = s13.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(6.25), Inches(5.8), Inches(0.6))
    btn1.fill.solid(); btn1.fill.fore_color.rgb = DARK_BLUE
    btn1.line.color.rgb = NAVY
    p_btn1 = btn1.text_frame.paragraphs[0]; p_btn1.alignment = PP_ALIGN.CENTER
    run_btn1 = p_btn1.add_run()
    run_btn1.text = "▶ Click to Open / Play WhatsApp Demo Video"
    run_btn1.font.bold = True
    run_btn1.font.size = Pt(13)
    run_btn1.font.color.rgb = WHITE
    run_btn1.hyperlink.address = vid1_rel

    # Right side: Description Text Box
    tb_desc1 = s13.shapes.add_textbox(Inches(7.0), Inches(1.8), Inches(5.6), Inches(4.8))
    tf_desc1 = tb_desc1.text_frame; tf_desc1.word_wrap = True
    p_h1 = tf_desc1.paragraphs[0]
    set_font(p_h1, "Demonstrated Capabilities in Video 1:", 16, True, NAVY)
    
    add_bullet_point(tf_desc1, "Fluid Bottom Navigation", "Demonstrates responsive switching across Home, Challenge, UFC, Gym, and Growth tabs.", 13, 8)
    add_bullet_point(tf_desc1, "Real-Time Accelerometer Step Counter", "Shows live sensor updates, circular arc animation, and weekly trend analysis.", 13, 8)
    add_bullet_point(tf_desc1, "Hydration Wave Interface", "Visualizes dynamic water logging with cup/glass/bottle selections and wave animations.", 13, 8)
    add_bullet_point(tf_desc1, "Optical PPG Heart Rate Flow", "Demonstrates finger placement instructions, animated radar scanning, and final BPM readout.", 13, 8)
    add_bullet_point(tf_desc1, "100% Offline Responsiveness", "Seamless operation with zero network lag or external API calls.", 13, 8)

    # =========================================================================
    # SLIDE 14: APP DEMO VIDEO 2 (Layout 3 - Title Only)
    # =========================================================================
    s14 = prs.slides.add_slide(prs.slide_layouts[3])
    s14.shapes.title.text = "Live Demonstration: AI Pose Detection & Workouts"
    
    vid2_rel = "fitfi app/ffr.mp4"
    vid2_abs = os.path.abspath(os.path.join(BASE, vid2_rel))
    poster2_abs = os.path.abspath(os.path.join(BASE, 'poster2.png'))
    
    # Left side: Embedded Video / Poster
    try:
        s14.shapes.add_movie(
            vid2_abs,
            Inches(0.8), Inches(1.8), Inches(5.8), Inches(4.3),
            poster_frame_image=poster2_abs,
            mime_type='video/mp4'
        )
    except Exception as e:
        print(f"Slide 14 movie embed note: {e}")
        r14 = s14.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(1.8), Inches(5.8), Inches(4.3))
        r14.fill.solid(); r14.fill.fore_color.rgb = LIGHT_BG
        
    # Click to Play Action Button under video
    btn2 = s14.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(6.25), Inches(5.8), Inches(0.6))
    btn2.fill.solid(); btn2.fill.fore_color.rgb = DARK_BLUE
    btn2.line.color.rgb = NAVY
    p_btn2 = btn2.text_frame.paragraphs[0]; p_btn2.alignment = PP_ALIGN.CENTER
    run_btn2 = p_btn2.add_run()
    run_btn2.text = "▶ Click to Open / Play Full Feature Video (ffr.mp4)"
    run_btn2.font.bold = True
    run_btn2.font.size = Pt(13)
    run_btn2.font.color.rgb = WHITE
    run_btn2.hyperlink.address = vid2_rel

    # Right side: Description Text Box
    tb_desc2 = s14.shapes.add_textbox(Inches(7.0), Inches(1.8), Inches(5.6), Inches(4.8))
    tf_desc2 = tb_desc2.text_frame; tf_desc2.word_wrap = True
    p_h2 = tf_desc2.paragraphs[0]
    set_font(p_h2, "Demonstrated Capabilities in Video 2:", 16, True, NAVY)
    
    add_bullet_point(tf_desc2, "Real-Time AI Landmark Tracking", "Live camera inference rendering 33 green skeletal joints tracking user movements.", 13, 8)
    add_bullet_point(tf_desc2, "Automated Repetition State Machine", "Accurate rep incrementing during active push-up and squat cycles.", 13, 8)
    add_bullet_point(tf_desc2, "Corrective Form Feedback", "Instantaneous color shifts to red and display of corrective cues upon postural deviation.", 13, 8)
    add_bullet_point(tf_desc2, "5-Phase Guided Workout Runner", "Timed interval transitions across Breathing, Preview, Perform, Rest, and Next exercises.", 13, 8)
    add_bullet_point(tf_desc2, "XP Progression & Milestone Dialogs", "Post-workout XP rewards and rank tier upgrades displayed in session summary.", 13, 8)

    # =========================================================================
    # SLIDE 15: RESEARCH PLAN WITH TIME FRAME (Layout 1)
    # =========================================================================
    s15 = prs.slides.add_slide(prs.slide_layouts[1])
    s15.shapes.title.text = "Research Plan with Time Frame"
    tf15 = s15.placeholders[1].text_frame; tf15.word_wrap = True
    tf15.text = ""

    plan_items = [
        ("Month 1: Problem Formulation & Architecture", 
         "Conducted extensive literature survey, identified development gaps, designed Figma UI mockups, and structured the modular Flutter directory architecture (Completed)."),
        ("Month 2: Sensor & Core Module Engineering", 
         "Implemented triaxial accelerometer pedometer, optical camera PPG heart rate algorithm, water tracker with notification alarms, and baseline storage services (Completed)."),
        ("Month 3: AI Computer Vision & Workout Workflows", 
         "Integrated Google ML Kit Pose Detection, built trigonometric RepCounterService state machines, authored 256-exercise database, and created UFC/Gym programs (Completed)."),
        ("Month 4: Gamification, Profiling & Documentation", 
         "Built Solo Leveling XP engine, implemented device profiling performance management, conducted multi-device testing, authored synopsis, and prepared presentation (In Progress)."),
    ]
    for month_title, desc in plan_items:
        add_bullet_point(tf15, month_title, desc, 13.5, 10)

    # =========================================================================
    # SLIDE 16: EXPECTED OUTCOMES & INNOVATION (Layout 1)
    # =========================================================================
    s16 = prs.slides.add_slide(prs.slide_layouts[1])
    s16.shapes.title.text = "Expected Outcomes and Innovation"
    tf16 = s16.placeholders[1].text_frame; tf16.word_wrap = True
    tf16.text = ""

    add_bullet_point(tf16, "Comprehensive Unified Health Suite", 
                     "Eliminates mobile application fragmentation by consolidating 10+ wellness modules into a single synchronized Flutter client.", 13.5, 8)
    add_bullet_point(tf16, "Edge-Computed Biomechanical Feedback", 
                     "Real-time angle computation on mobile chips bridges the gap between passive video tutorials and personalized personal training.", 13.5, 8)
    add_bullet_point(tf16, "Hardware Democratization via Camera PPG", 
                     "Delivers physiological pulse detection using built-in smartphone cameras, eliminating the financial barrier of wearable sensors.", 13.5, 8)
    add_bullet_point(tf16, "Gamified Retention Engineering", 
                     "Adapts multi-tier XP and rank mechanics directly into physical conditioning, dramatically boosting user engagement and routine consistency.", 13.5, 8)
    add_bullet_point(tf16, "Strict Offline Privacy by Design", 
                     "Zero reliance on remote servers ensures that video streams and health metrics remain strictly confidential on the user's handset.", 13.5, 8)

    # =========================================================================
    # SLIDE 17: OUTCOME AND CONCLUSION (Layout 1)
    # =========================================================================
    s17 = prs.slides.add_slide(prs.slide_layouts[1])
    s17.shapes.title.text = "Outcome and Conclusion"
    tf17 = s17.placeholders[1].text_frame; tf17.word_wrap = True
    tf17.text = ""

    add_bullet_point(tf17, "Project Deliverables Accomplished", 
                     "Successfully engineered and deployed FitFi as a fully functional, cross-platform mobile fitness platform with 0 structurally breaking errors.", 13.5, 8)
    add_bullet_point(tf17, "Technical Milestones Achieved", 
                     "Real-time on-device Google ML Kit pose detection, automated repetition state machine, optical camera PPG heart rate, accelerometer pedometer, and 256 guided exercises.", 13.5, 8)
    add_bullet_point(tf17, "Robust Software Architecture", 
                     "Clean separation across presentation, service, data, and storage tiers guarantees scalability and maintainability.", 13.5, 8)
    add_bullet_point(tf17, "Future ML Expansion Prepared", 
                     "Offline Python training pipelines (MobileNetV2 body classifier, diet optimizer, progressive overload regression) are prepared for future TensorFlow Lite mobile deployment.", 13.5, 8)
    add_bullet_point(tf17, "Conclusion", 
                     "FitFi proves the technical and practical feasibility of delivering intelligent, interactive, and privacy-preserving fitness coaching on standard consumer smartphones.", 13.5, 8)

    # =========================================================================
    # SLIDE 18: REFERENCES (Layout 1)
    # =========================================================================
    s18 = prs.slides.add_slide(prs.slide_layouts[1])
    s18.shapes.title.text = "References"
    tf18 = s18.placeholders[1].text_frame; tf18.word_wrap = True
    tf18.text = ""

    refs_list = [
        "[1] Google, 'ML Kit Pose Detection API Overview,' Google Developers, 2023. [Online]. https://developers.google.com/ml-kit/vision/pose-detection",
        "[2] Google, 'Flutter: Build Apps for Any Screen,' Flutter Documentation, 2024. [Online]. https://flutter.dev/docs",
        "[3] J. Allen, 'Photoplethysmography and its application in clinical physiological measurement,' Physiol. Meas., vol. 28, pp. R1–R39, 2007.",
        "[4] Flutter Community, 'sensors_plus: Flutter Plugin for Accessing Accelerometer Sensors,' pub.dev, 2024. https://pub.dev/packages/sensors_plus",
        "[5] Flutter Community, 'camera: Flutter Plugin for Controlling Device Cameras,' pub.dev, 2024. https://pub.dev/packages/camera",
        "[6] Google, 'google_mlkit_pose_detection: On-Device Pose Landmark Detection Plugin,' pub.dev, 2024. https://pub.dev/packages/google_mlkit_pose_detection",
        "[7] Airbnb, 'Lottie for Flutter: Native After Effects Animation Vector Engine,' pub.dev, 2024. https://pub.dev/packages/lottie",
        "[8] Flutter Community, 'flutter_local_notifications: Cross-Platform Periodic Notification Plugin,' pub.dev, 2024.",
    ]
    for r in refs_list:
        p = tf18.add_paragraph()
        p.space_after = Pt(6)
        p.font.name = 'Calibri'
        p.font.size = Pt(11.5)
        p.font.color.rgb = GRAY_TEXT
        p.text = r

    # Save to Official presentation file
    prs.save(OUTPUT_PATH)
    print(f"Presentation created successfully with {len(prs.slides)} slides: {OUTPUT_PATH}")
    
    # Also save to FitFi_Presentation.pptx
    try:
        prs.save(os.path.join(BASE, 'FitFi_Presentation.pptx'))
        print("Updated FitFi_Presentation.pptx as well!")
    except Exception as e:
        print(f"Note: {e}")

if __name__ == '__main__':
    create_presentation()
