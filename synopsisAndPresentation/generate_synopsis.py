import collections
import collections.abc
import docx
from docx.shared import Inches, Pt, Cm, RGBColor, Emu
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml.ns import qn

def set_cell_shading(cell, color_hex):
    shading_elm = docx.oxml.OxmlElement('w:shd')
    shading_elm.set(qn('w:fill'), color_hex)
    shading_elm.set(qn('w:val'), 'clear')
    cell._tc.get_or_add_tcPr().append(shading_elm)

def set_cell_borders(cell, top=None, bottom=None, left=None, right=None):
    tc = cell._tc
    tcPr = tc.get_or_add_tcPr()
    tcBorders = docx.oxml.OxmlElement('w:tcBorders')
    for edge, val in [('top', top), ('bottom', bottom), ('left', left), ('right', right)]:
        if val:
            el = docx.oxml.OxmlElement(f'w:{edge}')
            el.set(qn('w:val'), 'single')
            el.set(qn('w:sz'), str(val))
            el.set(qn('w:space'), '0')
            el.set(qn('w:color'), '000000')
            tcBorders.append(el)
    tcPr.append(tcBorders)

def create_synopsis():
    doc = docx.Document()

    # ===== PAGE SETUP =====
    for section in doc.sections:
        section.top_margin = Inches(1.0)
        section.bottom_margin = Inches(1.0)
        section.left_margin = Inches(1.5)
        section.right_margin = Inches(1.0)
        section.page_width = Cm(21.0)
        section.page_height = Cm(29.7)

    # ===== STYLES =====
    style_normal = doc.styles['Normal']
    style_normal.font.name = 'Times New Roman'
    style_normal.font.size = Pt(12)
    style_normal.paragraph_format.line_spacing = 1.5
    style_normal.paragraph_format.space_after = Pt(6)

    style_h1 = doc.styles['Heading 1']
    style_h1.font.name = 'Times New Roman'
    style_h1.font.size = Pt(14)
    style_h1.font.bold = True
    style_h1.font.color.rgb = RGBColor(0, 0, 0)
    style_h1.paragraph_format.line_spacing = 1.5
    style_h1.paragraph_format.space_before = Pt(18)
    style_h1.paragraph_format.space_after = Pt(10)

    style_h2 = doc.styles['Heading 2']
    style_h2.font.name = 'Times New Roman'
    style_h2.font.size = Pt(12)
    style_h2.font.bold = True
    style_h2.font.color.rgb = RGBColor(0, 0, 0)
    style_h2.paragraph_format.line_spacing = 1.5
    style_h2.paragraph_format.space_before = Pt(12)
    style_h2.paragraph_format.space_after = Pt(6)

    def centered(text, size=12, bold=False, after=6):
        p = doc.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        run = p.add_run(text)
        run.font.name = 'Times New Roman'
        run.font.size = Pt(size)
        run.bold = bold
        p.paragraph_format.space_after = Pt(after)
        p.paragraph_format.line_spacing = 1.5
        return p

    def body(text, after=6):
        p = doc.add_paragraph(text, style='Normal')
        p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
        p.paragraph_format.space_after = Pt(after)
        return p

    def h1(text):
        return doc.add_paragraph(text, style='Heading 1')

    def h2(text):
        return doc.add_paragraph(text, style='Heading 2')

    def add_table(headers, rows, col_widths=None):
        table = doc.add_table(rows=len(rows) + 1, cols=len(headers))
        table.style = 'Table Grid'
        table.alignment = WD_TABLE_ALIGNMENT.CENTER
        # Header row
        for j, header in enumerate(headers):
            cell = table.cell(0, j)
            p = cell.paragraphs[0]
            p.alignment = WD_ALIGN_PARAGRAPH.CENTER
            run = p.add_run(header)
            run.font.name = 'Times New Roman'
            run.font.size = Pt(11)
            run.bold = True
            set_cell_shading(cell, "1F4E79")
            run.font.color.rgb = RGBColor(255, 255, 255)
        # Data rows
        for i, row in enumerate(rows):
            for j, val in enumerate(row):
                cell = table.cell(i + 1, j)
                p = cell.paragraphs[0]
                run = p.add_run(str(val))
                run.font.name = 'Times New Roman'
                run.font.size = Pt(11)
                if i % 2 == 0:
                    set_cell_shading(cell, "D6E4F0")
        if col_widths:
            for i, w in enumerate(col_widths):
                for row in table.rows:
                    row.cells[i].width = Inches(w)
        doc.add_paragraph()
        return table

    def spacer(lines=1):
        for _ in range(lines):
            p = doc.add_paragraph()
            p.paragraph_format.space_after = Pt(0)
            p.paragraph_format.space_before = Pt(0)

    # ================================================================
    #                        TITLE PAGE (Page i)
    # ================================================================
    spacer(2)
    centered("FitFi: AI-Powered Smart Fitness Coach", 18, True, 8)
    centered("A Comprehensive Mobile Fitness and Wellness Application", 13, False, 30)

    centered("Synopsis", 16, True, 8)
    centered("Submitted to", 12, False, 4)
    centered("Dev Bhoomi Uttarakhand University", 14, True, 8)
    centered("In partial fulfillment of the requirements for the degree of", 12, False, 4)
    centered("Bachelor of Technology", 14, True, 4)
    centered("in", 12, False, 4)
    centered("Computer Science & Engineering", 14, True, 24)

    centered("By", 12, True, 10)
    centered("Student Name 1\nEnrollment No.: ………………..", 12, False, 6)
    centered("Student Name 2\nEnrollment No.: ………………..", 12, False, 6)
    centered("Student Name 3\nEnrollment No.: ………………..", 12, False, 18)

    # Supervisor/Co-Supervisor table
    t = doc.add_table(rows=3, cols=2)
    t.alignment = WD_TABLE_ALIGNMENT.CENTER
    sup_data = [
        ("Supervisor", "Co-Supervisor (If Any)"),
        ("Name: ………………………", "Name: ………………………"),
        ("Designation: ……………", "Designation: ……………"),
    ]
    for i, (left_val, right_val) in enumerate(sup_data):
        for j, val in enumerate((left_val, right_val)):
            cell = t.cell(i, j)
            p = cell.paragraphs[0]
            p.alignment = WD_ALIGN_PARAGRAPH.CENTER
            run = p.add_run(val)
            run.font.name = 'Times New Roman'
            run.font.size = Pt(12)
            if i == 0:
                run.bold = True

    spacer(2)
    centered("DEV BHOOMI UTTARAKHAND UNIVERSITY", 13, True, 2)
    centered("(Established by Govt. of Uttarakhand vide Act No. 17 of 2021)", 10, False, 4)
    centered("Batch (2026 - 2027)", 12, True, 0)

    doc.add_page_break()

    # ================================================================
    #                      CERTIFICATE (Page ii)
    # ================================================================
    spacer(1)
    centered("CERTIFICATE", 14, True, 24)

    body(
        'This is to certify that Mr./Ms. _________________________ is a Bachelor of Technology '
        'Student at Dev Bhoomi Uttarakhand University, Dehradun. He/She has worked on the '
        'project entitled "FitFi: AI-Powered Smart Fitness Coach" under my/our supervision '
        'and guidance at School of Engineering and Computing (SoEC), Department of Computer '
        'Science & Engineering, for the partial fulfillment of the requirements for the degree '
        'of Bachelor of Technology (B.Tech.) in Computer Science & Engineering.'
    )

    spacer(3)

    cert_t = doc.add_table(rows=4, cols=2)
    cert_t.alignment = WD_TABLE_ALIGNMENT.CENTER
    cert_data = [
        ("Supervisor", "Co-Supervisor (If Any)"),
        ("", ""),
        ("Signature: ………………………", "Signature: ………………………"),
        ("Name: ……………………………", "Name: ……………………………"),
    ]
    for i, (l, r) in enumerate(cert_data):
        for j, val in enumerate((l, r)):
            cell = cert_t.cell(i, j)
            p = cell.paragraphs[0]
            p.alignment = WD_ALIGN_PARAGRAPH.CENTER
            run = p.add_run(val)
            run.font.name = 'Times New Roman'
            run.font.size = Pt(12)
            if i == 0:
                run.bold = True

    spacer(2)
    body("Date: ……………………")

    doc.add_page_break()

    # ================================================================
    #                      DECLARATION (Page iii)
    # ================================================================
    spacer(1)
    centered("DECLARATION BY STUDENT", 14, True, 24)

    body(
        'I/We hereby declare that the synopsis of the proposed project work entitled '
        '"FitFi: AI-Powered Smart Fitness Coach" submitted in partial fulfillment of the '
        'requirements for the award of degree of B.Tech. in Computer Science & Engineering '
        'and submitted to Dev Bhoomi Uttarakhand University, Dehradun, Uttarakhand, has been '
        'carried out by me/us under the expert guidance as well as direct supervision of '
        '<Supervisor Name>.'
    )
    body(
        'I/We further declare that the work carried out is our original work and material '
        'obtained from other sources has been duly acknowledged in the synopsis. This work '
        'has not been submitted to any other university or institution for the award of any '
        'other degree or diploma.'
    )

    spacer(3)

    decl_t = doc.add_table(rows=4, cols=1)
    decl_data = [
        "Signature: ………………………",
        "Name: …………………………",
        "Enrollment No: ……………………",
        "Department/School: CSE / SoEC",
    ]
    for i, val in enumerate(decl_data):
        cell = decl_t.cell(i, 0)
        run = cell.paragraphs[0].add_run(val)
        run.font.name = 'Times New Roman'
        run.font.size = Pt(12)

    spacer(1)
    body("Date: ……………………")
    body("Place: Dehradun, Uttarakhand")

    doc.add_page_break()

    # ================================================================
    #                  TABLE OF CONTENTS (Page iv)
    # ================================================================
    centered("TABLE OF CONTENTS", 14, True, 18)

    toc = [
        ("", "Certificate", "i"),
        ("", "Declaration by Student", "ii"),
        ("", "Table of Contents", "iii"),
        ("1.", "Introduction", "1"),
        ("1.1", "Problem Statement", "1"),
        ("1.2", "Objectives of the Project", "2"),
        ("1.3", "Scope of the Project", "3"),
        ("2.", "Existing Systems and Their Limitations", "4"),
        ("3.", "Development Gap", "5"),
        ("4.", "Proposed System — FitFi", "6"),
        ("4.1", "System Architecture", "6"),
        ("4.2", "Modules of the Project", "7"),
        ("4.3", "Technologies and Tools Used", "10"),
        ("4.4", "System Requirements", "11"),
        ("5.", "Expected Outcomes", "12"),
        ("5.1", "Innovation and Novelty", "12"),
        ("6.", "Work Plan and Timeline", "13"),
        ("7.", "Conclusion", "14"),
        ("", "References", "15"),
    ]

    toc_table = doc.add_table(rows=len(toc), cols=3)
    toc_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    for i, (num, heading, page) in enumerate(toc):
        for j, val in enumerate((num, heading, page)):
            cell = toc_table.cell(i, j)
            p = cell.paragraphs[0]
            run = p.add_run(val)
            run.font.name = 'Times New Roman'
            run.font.size = Pt(12)
            if num.endswith('.') and not num.startswith(' '):
                run.bold = True
            if j == 2:
                p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        # Set column widths roughly
        toc_table.cell(i, 0).width = Inches(0.5)
        toc_table.cell(i, 1).width = Inches(4.5)
        toc_table.cell(i, 2).width = Inches(1.0)

    doc.add_page_break()

    # ================================================================
    #           CHAPTER 1: INTRODUCTION (Pages 1-3)
    # ================================================================
    h1("1. Introduction")

    body(
        'The rapid advancement in smartphone technology has made mobile devices the most '
        'accessible platform for personal health and fitness management. Modern smartphones '
        'are equipped with powerful processors, high-resolution cameras, accelerometers, and '
        'gyroscopes — hardware capabilities that were previously available only in dedicated '
        'medical or fitness devices. This presents a significant opportunity to build intelligent '
        'fitness applications that leverage these built-in capabilities.'
    )
    body(
        'However, despite the availability of hundreds of fitness applications on the market, '
        'most of them offer only isolated functionalities. A user typically needs one application '
        'for step counting, another for water intake tracking, a separate one for workout guidance, '
        'and yet another for heart rate monitoring. This fragmented ecosystem leads to inconsistent '
        'health data, poor user experience, and ultimately, reduced motivation to maintain fitness '
        'routines.'
    )
    body(
        'FitFi ("AI-Powered Smart Fitness Coach") addresses this challenge by providing a '
        'comprehensive, unified, cross-platform mobile application developed using the Flutter '
        'framework. FitFi integrates the following capabilities into a single application:'
    )
    body(
        '(a) Real-time on-device AI exercise tracking using Google ML Kit Pose Detection that '
        'identifies 33 body landmarks through the camera and counts exercise repetitions while '
        'evaluating posture correctness.\n\n'
        '(b) Camera-based Photoplethysmography (PPG) heart rate measurement using the rear '
        'camera lens and LED flashlight — eliminating the need for external wearable devices.\n\n'
        '(c) Hardware accelerometer-based step counting with distance and calorie estimation.\n\n'
        '(d) Interactive water intake tracking with customizable goals and automated notification '
        'reminders.\n\n'
        '(e) A comprehensive library of 256 exercises across gym workout courses, UFC-inspired '
        'combat training programs (Dagestani and Irish styles), and ranked challenge levels.\n\n'
        '(f) A gamified XP and ranking progression system inspired by Solo Leveling to motivate '
        'user consistency.\n\n'
        '(g) Diet plan templates, session summaries, progress calendar, and an aggregated '
        'analytics dashboard.\n\n'
        '(h) Multi-language support (English and Hindi) with runtime language switching.\n\n'
        'The entire application operates offline with on-device AI processing, local data '
        'persistence via SharedPreferences, and does not require internet connectivity for '
        'any of its core features.'
    )

    h2("1.1 Problem Statement")
    body(
        'The current mobile fitness application ecosystem suffers from several critical limitations '
        'that this project aims to address:'
    )
    body(
        '1. Fragmented User Experience: Users are forced to install and manage 3-5 separate '
        'applications to cover basic fitness tracking needs — one for steps, one for water, one '
        'for workouts, one for heart rate, and one for diet. Each app has its own interface, '
        'account, and data storage, making it difficult to get a holistic view of one\'s health.\n\n'
        '2. Absence of Real-Time AI Exercise Feedback: The vast majority of workout applications '
        'provide pre-recorded video demonstrations of exercises. They cannot detect whether the '
        'user is performing the exercise correctly, count repetitions automatically, or provide '
        'real-time feedback on posture. This gap can lead to injuries from improper form and '
        'reduced workout effectiveness.\n\n'
        '3. Dependency on External Hardware for Biometrics: Heart rate monitoring typically '
        'requires smartwatches, chest straps, or other external devices. Despite the fact that '
        'smartphone cameras are technically capable of measuring heart rate through '
        'Photoplethysmography (PPG), this technique remains underutilized in consumer fitness '
        'applications.\n\n'
        '4. Low User Retention Due to Lack of Gamification: Fitness apps suffer from notoriously '
        'high abandonment rates. Most applications rely on simple streak counters but lack the '
        'comprehensive gamification systems (experience points, levels, ranks, achievements) '
        'that have proven effective in gaming for sustaining user engagement.\n\n'
        '5. Cloud Dependency: Many popular fitness applications require constant internet '
        'connectivity for features that could easily function offline, limiting usability in '
        'areas with poor connectivity or for users concerned about data privacy.'
    )

    h2("1.2 Objectives of the Project")
    body('The following are the key objectives of this project:')
    body(
        'Objective 1: To design and develop a unified, cross-platform mobile application using '
        'the Flutter framework that combines step counting, water intake tracking, heart rate '
        'monitoring, AI-based exercise detection, structured workout programs, diet planning, '
        'and gamified progression into a single cohesive application.\n\n'
        'Objective 2: To implement real-time, on-device Artificial Intelligence for exercise '
        'form analysis using Google ML Kit Pose Detection. The system should be capable of '
        'identifying 33 body landmarks from the live camera feed, calculating joint angles using '
        'trigonometric functions, counting exercise repetitions through state machine logic, and '
        'providing real-time visual and textual feedback on posture correctness. Supported exercises '
        'include Push-ups, Pull-ups, Squats, Lunges, Crunches, Burpees, Jumping Jacks, High Knees, '
        'Planks, Wall Sits, and Side Planks.\n\n'
        'Objective 3: To implement camera-based Photoplethysmography (PPG) for measuring heart '
        'rate using the smartphone\'s rear camera and LED flashlight, processing frame-by-frame '
        'luminance variations to detect pulse peaks and calculate beats per minute (BPM).\n\n'
        'Objective 4: To implement a hardware accelerometer-based pedometer using the sensors_plus '
        'package, applying peak-detection algorithms with appropriate thresholds and debounce filters '
        'to accurately count steps and estimate distance and calories.\n\n'
        'Objective 5: To develop a comprehensive workout ecosystem featuring 256 mapped exercises '
        'with animated visual guides (Lottie, GIF, images), structured gym courses with progressive '
        'overload algorithms, UFC combat training programs, and a ranked challenge system.\n\n'
        'Objective 6: To build a gamified XP and ranking progression system with 10 experience levels, '
        '11 ranks, dual domain tracks (Gym and Challenge), and level-up celebrations to enhance user '
        'motivation and long-term engagement.'
    )

    h2("1.3 Scope of the Project")
    body(
        'The scope of the FitFi application encompasses the following dimensions:\n\n'
        'Target Users: Fitness enthusiasts of all levels (beginner, intermediate, advanced), '
        'gym-goers, home workout users, and individuals who want to track daily health metrics '
        'such as steps, water intake, and heart rate.\n\n'
        'Platform Support: Built using Flutter for cross-platform compatibility with Android and '
        'iOS. Currently tested and deployed on Android devices.\n\n'
        'Core Functional Scope:\n'
        '- AI-powered exercise detection and rep counting via live camera (11 exercise types)\n'
        '- Camera PPG heart rate measurement\n'
        '- Accelerometer step counting with trends and history\n'
        '- Water intake tracking with scheduled notification reminders\n'
        '- 256-exercise library with Lottie/GIF/image animations\n'
        '- Gym courses with 8-step personalization onboarding wizard\n'
        '- UFC combat training (Dagestani and Irish programs)\n'
        '- 6-level ranked challenge system with 15 individual quick challenges\n'
        '- XP/leveling/ranking gamification engine\n'
        '- Diet plan templates (Lose Weight, Build Muscle, Keep Fit)\n'
        '- Session summary with XP rewards\n'
        '- Progress calendar with streak tracking\n'
        '- Aggregated growth analytics dashboard\n'
        '- Multi-language support (English and Hindi)\n'
        '- Performance optimization (device profiling, adaptive animations)\n\n'
        'Boundaries: The current version operates entirely offline using on-device AI processing '
        'and local storage. Cloud synchronization, social features, wearable device integration, '
        'and GPS-based outdoor activity tracking are planned for future phases.\n\n'
        'Scalability: The modular architecture with clearly separated layers (screens, widgets, '
        'models, services, data, utils, constants) is designed to accommodate future feature additions '
        'and backend integration without restructuring the existing codebase. Python ML training '
        'scripts for body type classification, diet optimization, and progressive overload prediction '
        'have already been developed and are ready for TensorFlow Lite integration in future releases.'
    )

    doc.add_page_break()

    # ================================================================
    #     CHAPTER 2: EXISTING SYSTEMS AND THEIR LIMITATIONS (Page 4)
    # ================================================================
    h1("2. Existing Systems and Their Limitations")

    body(
        'A thorough examination of the most widely used fitness applications reveals specific '
        'strengths and shortcomings. The following table provides a comparative analysis:'
    )

    add_table(
        ["Application", "Key Strengths", "Key Limitations"],
        [
            ["Google Fit",
             "Basic step tracking, activity recognition using phone sensors, Google ecosystem integration.",
             "No real-time AI exercise form detection, no structured workout courses, no gamification system, no heart rate via camera PPG."],
            ["MyFitnessPal",
             "Extensive food database for calorie tracking, macro nutrient breakdowns, barcode scanning.",
             "No exercise form detection, no camera heart rate, no workout player, heavily reliant on manual data entry."],
            ["Nike Training Club",
             "Professional trainer-guided workout videos, categorized by difficulty and body focus.",
             "No real-time feedback on user form, cannot auto-count reps, no step/water/heart rate tracking, no gamified XP system."],
            ["Freeletics",
             "AI-generated personalized workout plans, bodyweight exercise focus.",
             "AI limited to plan generation only (not real-time form analysis), no camera heart rate, no water tracking, subscription-heavy."],
            ["Samsung Health",
             "Step counting, heart rate (on supported Samsung devices), sleep tracking.",
             "Heart rate requires Samsung hardware, no AI pose detection for exercises, no UFC/combat training, limited gamification."],
        ],
        [2.0, 2.0, 2.5]
    )

    body(
        'From this analysis, it is evident that no single existing application combines real-time '
        'on-device AI pose detection for exercise form analysis, camera-based PPG heart rate '
        'measurement, accelerometer-based step counting, structured workout courses with guided '
        'players, combat training programs, and a comprehensive gamification system within one '
        'unified platform. This gap forms the foundation for the development of FitFi.'
    )

    doc.add_page_break()

    # ================================================================
    #              CHAPTER 3: DEVELOPMENT GAP (Page 5)
    # ================================================================
    h1("3. Development Gap")

    body('Based on the analysis of existing systems, the following development gaps have been identified:')

    add_table(
        ["S.No.", "Gap Identified", "How FitFi Addresses It"],
        [
            ["1", "Users need multiple apps for different fitness activities (steps, water, heart rate, workouts, diet).",
             "FitFi integrates all these features into one unified application with a consistent UI."],
            ["2", "Real-time AI pose detection is available (Google ML Kit) but not integrated into consumer fitness apps for exercise form analysis.",
             "FitFi uses Google ML Kit Pose Detection to track 33 body landmarks in real-time, count reps, and evaluate posture."],
            ["3", "Camera-based PPG heart rate is technically feasible but underutilized in fitness applications.",
             "FitFi implements PPG heart rate measurement using the rear camera and flashlight — no external hardware needed."],
            ["4", "Fitness apps lack gaming-level gamification systems to motivate consistent usage.",
             "FitFi implements a Solo Leveling-inspired XP system with 10 levels, 11 ranks, and dual domain tracks."],
            ["5", "Most fitness apps require internet connectivity for core features.",
             "FitFi operates entirely offline with on-device AI processing and local data storage."],
            ["6", "No fitness app combines traditional gym workouts with combat (UFC) training styles.",
             "FitFi includes both structured gym courses AND UFC combat training (Dagestani & Irish styles)."],
        ],
        [0.5, 2.5, 3.5]
    )

    doc.add_page_break()

    # ================================================================
    #            CHAPTER 4: PROPOSED SYSTEM (Pages 6-11)
    # ================================================================
    h1("4. Proposed System — FitFi")

    body(
        'FitFi is designed as a modular, layered mobile application built entirely with the '
        'Flutter framework. The application prioritizes a UI-first development approach — '
        'ensuring all screens, animations, and user flows are polished and production-ready '
        'before integrating backend services. The architecture allows individual modules to '
        'function independently while sharing common services and data stores.'
    )

    h2("4.1 System Architecture")

    body(
        'The application is organized into the following architectural layers:\n\n'
        'Layer 1 — Presentation (UI):\n'
        'Built using Flutter\'s widget system. Each feature has dedicated screen files with '
        'reusable widget components. Advanced visualizations are implemented using CustomPainter '
        'for circular progress arcs, ECG heartbeat waveforms, sinusoidal water wave animations, '
        'trend charts with cubic Bezier curves, and real-time AI skeleton overlays. The UI '
        'includes animated transitions, scale animations, fade effects, and smooth state changes.\n\n'
        'Layer 2 — Service (Business Logic):\n'
        'Singleton services encapsulate all core logic. Key services include PoseDetectionService '
        '(Google ML Kit integration), RepCounterService (biomechanical angle calculations and '
        'state machines), StepCounterService (accelerometer data processing), HeartRateService '
        '(PPG frame analysis), WaterStorageService (hydration data and reminders), '
        'HomeWorkoutService (algorithmic progressive overload plan generation), XPService '
        '(gamification engine), ProgressService (workout history), NotificationService '
        '(local alarms and reminders), and SchedulingService (course scheduling).\n\n'
        'Layer 3 — Data:\n'
        'Static exercise databases (256 exercises with mapped Lottie/GIF/image assets), '
        'gym course catalogs, UFC training program data, challenge configurations, and diet '
        'plan templates are stored as Dart data files. User data is persisted locally using '
        'SharedPreferences.\n\n'
        'Layer 4 — Performance Optimization:\n'
        'A dedicated performance layer handles device hardware profiling (determining low, mid, '
        'or high tier based on processor cores and memory), adaptive memory management (dynamic '
        'image cache limits), animation throttling for lower-end devices, and background task '
        'concurrency regulation.\n\n'
        '[Insert System Architecture Diagram Here]'
    )

    doc.add_page_break()

    h2("4.2 Modules of the Project")
    body(
        'The FitFi application consists of 10 major functional modules. Each module is described '
        'in detail below:'
    )

    # MODULE 1
    body(
        'Module 1: AI Exercise Detection\n'
        'Files: ai_activity_screen.dart, pose_detection_service.dart, rep_counter_service.dart\n'
        'Packages: google_mlkit_pose_detection, camera, permission_handler\n\n'
        'This is the flagship AI feature of FitFi. It enables real-time, on-device exercise '
        'tracking using the smartphone camera. The module works as follows:\n\n'
        'Step 1 — Camera Initialization: The app requests camera permission and initializes '
        'a live camera preview using the Flutter camera package.\n\n'
        'Step 2 — Pose Detection: Each camera frame is converted to an InputImage and processed '
        'by Google ML Kit\'s PoseDetector configured in streaming mode. The detector identifies '
        '33 anatomical landmarks (shoulders, elbows, wrists, hips, knees, ankles, etc.) with '
        'their x, y, z coordinates.\n\n'
        'Step 3 — Angle Calculation: The RepCounterService receives the detected landmarks and '
        'calculates joint angles using the atan2 trigonometric function. For example, for push-ups, '
        'it calculates the angle at the elbow joint formed by the shoulder-elbow-wrist landmarks.\n\n'
        'Step 4 — State Machine Logic: Each exercise type has a finite state machine with defined '
        'angle thresholds. For push-ups: the "down" state is triggered when elbow angle falls '
        'below 90 degrees, and the "up" state when it exceeds 150 degrees. A complete transition '
        'from up to down and back to up counts as one repetition. Similar state machines exist '
        'for all supported exercises.\n\n'
        'Step 5 — Visual Feedback: A CustomPainter (_RealPosePainter) draws the detected skeleton '
        'over the camera preview in real-time. Bone segments are rendered in neon green when the '
        'posture is correct and in red when incorrect. The UI displays a live rep counter, dynamic '
        'form feedback messages ("Go lower", "Push up", "Keep body straight in plank"), and a '
        'status badge ("Searching...", "Pose Correct", "Fix Position").\n\n'
        'Supported Exercises:\n'
        '- Repetition-based: Push-ups, Pull-ups, Squats, Lunges, Crunches, Burpees, '
        'Jumping Jacks, High Knees, Tricep Dips, Russian Twists, Leg Raises\n'
        '- Isometric holds: Planks (shoulder-hip-ankle alignment >150 degrees), Wall Sits '
        '(knee flexion 70-115 degrees), Side Planks, V-Sits\n\n'
        'The module supports front and rear camera switching and integrates with the Challenge '
        'system for AI-validated challenge completion.'
    )

    # MODULE 2
    body(
        'Module 2: Heart Rate Monitor\n'
        'Files: heart_rate_screen.dart, heart_rate_service.dart\n'
        'Packages: camera\n\n'
        'This module measures the user\'s heart rate using camera-based Photoplethysmography (PPG). '
        'When the user places their fingertip over the rear camera lens, the HeartRateService '
        'activates the camera torch (flashlight) and begins processing video frames. It extracts '
        'luminance and red channel intensity values from a 50x50 pixel region of interest at the '
        'center of each frame. Blood volume changes beneath the fingertip cause measurable '
        'variations in the light absorbed, which the service tracks using a moving average threshold. '
        'Pulse peaks are detected from upward threshold crossings, and BPM is calculated from the '
        'inter-peak intervals.\n\n'
        'The screen presents a 3-state UI flow:\n'
        '1. Instruction State: Displays a fingerprint illustration with instructions to place '
        'the finger on the flashlight. Shows cards for last reading and daily average BPM.\n'
        '2. Scanning State: Dark biometric theme with an animated pulse radar painter, circular '
        '10-second countdown sweep, live BPM readout, signal quality indicator, and animated '
        'audio equalizer visualizer bars.\n'
        '3. Result State: Displays the final BPM reading with health status assessment ("Normal — '
        'Vital signs are excellent"), stress level ring (percentage), recovery rating, health '
        'description, 7-day weekly trend bar graph, and a "Measure Again" button.\n\n'
        'The measured BPM is persisted via HealthStorageService for historical tracking.'
    )

    # MODULE 3
    body(
        'Module 3: Step Counter\n'
        'Files: step_counter_screen.dart, step_counter_service.dart, step_counter_widget.dart\n'
        'Packages: sensors_plus, shared_preferences, percent_indicator\n\n'
        'The step counter uses the device\'s built-in accelerometer through the sensors_plus '
        'package. The StepCounterService subscribes to the userAccelerometerEventStream and '
        'processes 3D acceleration data. It computes the vector magnitude as the square root of '
        '(x-squared + y-squared + z-squared) and applies a peak-detection algorithm with a '
        'threshold of 12.0 m/s-squared. A 300ms debounce filter prevents false positives from '
        'noise or rapid vibrations.\n\n'
        'The service estimates walking distance in kilometers using an average stride length '
        'and calculates calorie expenditure. It maintains rolling 7-day statistics, monthly '
        'totals, and persists historical data in SharedPreferences.\n\n'
        'The step counter screen features a large custom-painted circular arc progress indicator '
        '(animating steps versus the daily goal of 10,000 steps), a context-aware motivational '
        'banner, daily average cards with toggle tabs for weekly and monthly views, trend charts '
        'with cubic Bezier curves, and a recent history list with achievement status badges '
        '(Goal Reached, Active, Started).'
    )

    # MODULE 4
    body(
        'Module 4: Water Tracker\n'
        'Files: water_tracker_screen.dart, water_storage_service.dart, water_tracker_card.dart\n'
        'Packages: shared_preferences, flutter_local_notifications, timezone\n\n'
        'The water tracker provides comprehensive hydration management. Users can log water '
        'intake by selecting from three vessel sizes: Small Cup (150ml), Medium Glass (250ml), '
        'or Large Bottle (500ml). The screen features an animated glass card with a custom '
        'sinusoidal wave painter (_WavePainter) that simulates liquid fill proportional to '
        'current intake.\n\n'
        'Additional UI elements include weekly average bar charts (7 animated vertical bars), '
        'a monthly completion ring painter, a customizable daily goal dialog, and a timestamped '
        'intake history log. The module integrates with NotificationService to schedule recurring '
        'hydration reminders every 2 hours between 8:00 AM and 8:00 PM.\n\n'
        'Data is persisted locally through WaterStorageService using SharedPreferences.'
    )

    # MODULE 5
    body(
        'Module 5: Gym Workout System\n'
        'Files: gym/ directory (15+ files), home_workout_service.dart, workout_player_screen.dart\n'
        'Packages: lottie, flutter\n\n'
        'The gym module is the largest feature set in FitFi, comprising:\n\n'
        '(a) Personalization Onboarding: An 8-step questionnaire wizard that collects gender, '
        'height and weight (with live BMI calculation), body focus areas (interactive human '
        'silhouette), activity level, fitness goals (Lose Weight, Build Muscle, Keep Fit, '
        'Relieve Stress), weekly workout targets, and push-up baseline assessment.\n\n'
        '(b) Course Catalog: A browsable library of gym courses filterable by body type '
        '(fat, fit, lean) and focus areas. The catalog maps to 256 exercises, each with animated '
        'visual guides in Lottie JSON, GIF, PNG, or JPG format.\n\n'
        '(c) Workout Player: A guided 5-phase workout runner with timed intervals — Breathing '
        '(20s), Preview (20s), Perform (30s), Recovery (20s), and Next Preview (20s). Includes '
        'play/pause controls, skip/previous navigation, and exercise media display. A victory '
        'dialog is shown upon completion.\n\n'
        '(d) Custom Workout Builder: Allows users to construct personalized routines by selecting '
        'exercises from the 256-exercise library.\n\n'
        '(e) Algorithmic Plan Generation: The HomeWorkoutService dynamically generates 1 to 12-week '
        'progressive overload programs based on user level (Beginner/Intermediate/Advanced) and '
        'goal. It calculates increasing rep multipliers (up to +30%) and decreasing rest periods '
        '(up to -10 seconds per rest interval) across weeks.'
    )

    doc.add_page_break()

    # MODULE 6
    body(
        'Module 6: UFC Combat Training\n'
        'Files: ufc/ directory (ufc_screen.dart, ufc_course_detail_screen.dart)\n\n'
        'A unique combat fitness module featuring two distinct training philosophies:\n\n'
        '- Dagestani Style (inspired by Khabib Nurmagomedov): Focuses on wrestling, grappling, '
        'pressure fighting, and cardiovascular endurance.\n'
        '- Irish Style (inspired by Conor McGregor): Focuses on striking precision, kickboxing '
        'technique, explosive power, fight IQ, and bone conditioning.\n\n'
        'Each training style contains multiple courses organized into 6 training days plus 1 rest '
        'day. Day cards expand to reveal individual exercises with animated media thumbnails and '
        'sets/reps specifications. The "START WORKOUT" button converts UFC exercises into '
        'CourseExercise objects and launches the WorkoutPlayerScreen for a guided session. '
        'Completion is tracked via ProgressService.'
    )

    # MODULE 7
    body(
        'Module 7: Challenge System and XP Gamification\n'
        'Files: challenge/ directory, xp_service.dart, session_summary_screen.dart\n\n'
        'The challenge system provides structured, progressively difficult exercise challenges '
        'across 6 ranked levels:\n'
        '- Level 10: Junior Trainee\n'
        '- Level 20: Senior Trainee\n'
        '- Level 30: Gym Bro\n'
        '- Level 50: Beast Mode\n'
        '- Level 60: Apex Predator\n'
        '- Level 100: UFC Fighter\n\n'
        'Each level contains a roster of exercises that are validated through the AI Detection '
        'camera module. Additionally, 15 individual quick challenges are available (Push-ups, '
        'Pull-ups, Squats, Lunges, Crunches, Burpees, Jump Squats, Tricep Dips, Russian Twists, '
        'Leg Raises, Planks, Side Planks, Wall Sits, High Knees, Jumping Jacks).\n\n'
        'The XP Service implements a Solo Leveling-inspired progression system with:\n'
        '- 10 experience levels (from 100 XP to 100,000 XP thresholds)\n'
        '- 11 ranks (Unranked, F Rank, E Rank, D Rank, C Rank, B Rank, A Rank, S Rank, '
        'SS Rank, SSS Rank, X Rank)\n'
        '- Dual domain XP tracks for Gym and Challenge activities\n'
        '- Celebratory level-up dialogs with rank badge displays\n\n'
        'The Session Summary screen displays post-workout results including completed reps/time, '
        'calories burned, XP earned, current rank and level, and quick-action buttons for '
        'continuing to other modules.'
    )

    # MODULE 8
    body(
        'Module 8: Diet Plan\n'
        'Files: gym/diet_plan_screen.dart, data/diet_plan_data.dart\n\n'
        'Provides pre-configured daily meal plan breakdowns based on three templates matched '
        'to user goals: Lose Weight, Build Muscle, and Keep Fit. Each plan displays structured '
        'meals (breakfast, lunch, dinner, snacks) with caloric totals and nutritional guidance. '
        'The diet data is stored as static Dart data files.'
    )

    # MODULE 9
    body(
        'Module 9: Account Dashboard and Growth Analytics\n'
        'Files: account/account_screen.dart\n\n'
        'The Growth tab serves as the master analytics dashboard, aggregating real-time data '
        'from all modules. It displays:\n'
        '- Primary stat tiles: Today\'s steps, water intake (ml), average BPM, workouts completed\n'
        '- Interactive progress cards for steps and water with percentage bars and tap navigation\n'
        '- Daily AI exercise rep totals across all exercise types\n'
        '- Challenge and achievement summaries with unlocked tiers and XP ranks\n'
        '- Workout history statistics (total sessions, total minutes, total calories)\n'
        '- Quick-action shortcuts to all major modules'
    )

    # MODULE 10
    body(
        'Module 10: Supporting Features\n\n'
        '(a) Splash Screen: Animated brand launch with "FITFI" logo in GoogleFonts Outfit, '
        '"AI POWERED SMART FITNESS COACH" subtitle, linear loading progress bar, and permission '
        'initialization before routing to main navigation.\n\n'
        '(b) Progress Calendar: Integrates table_calendar package for month view display with '
        'streak tracking, workout day markers, and fire icon streak counter.\n\n'
        '(c) Multi-Language Support: Full English and Hindi localization using Flutter\'s '
        'localization framework with runtime language switching. User preference is persisted '
        'in SharedPreferences.\n\n'
        '(d) Notification System: Manages Android notification channels for water reminders '
        'and course reminders, daily zoned scheduling using timezone package, and handles '
        'Android 13+ exact alarm permission requirements.\n\n'
        '(e) Performance Optimization: DeviceProfiler determines hardware tier, MemoryManager '
        'adjusts image cache limits, AnimationManager toggles complex animations on lower-end '
        'devices, and TaskManager regulates background concurrency.\n\n'
        '(f) Main Navigation: Bottom navigation bar with 5 tabs — Home, Challenge, UFC, Gym, '
        'and Growth (Account) — with IndexedStack for state preservation and animated pill indicator.'
    )

    doc.add_page_break()

    h2("4.3 Technologies and Tools Used")

    add_table(
        ["Category", "Technology / Tool", "Purpose in FitFi"],
        [
            ["Programming Language", "Dart", "Primary language for Flutter application development"],
            ["Framework", "Flutter", "Cross-platform mobile app framework (Android & iOS)"],
            ["AI / Machine Learning", "Google ML Kit Pose Detection", "On-device 33-landmark body pose detection in real-time"],
            ["Camera", "camera (Flutter package)", "Live camera preview for AI pose detection and PPG heart rate"],
            ["Sensors", "sensors_plus", "Accelerometer data streaming for step counting"],
            ["Local Storage", "SharedPreferences", "Offline persistence of user data, settings, and history"],
            ["Notifications", "flutter_local_notifications", "Scheduled hydration and workout reminders"],
            ["Time Zone", "timezone", "Accurate zoned scheduling for notifications"],
            ["Animations", "Lottie", "Rich exercise animations (JSON-based After Effects)"],
            ["UI Components", "percent_indicator", "Circular and linear progress indicators"],
            ["Calendar", "table_calendar", "Interactive month view for workout history"],
            ["Typography", "google_fonts", "Custom font families (Outfit, etc.)"],
            ["Permissions", "permission_handler", "Runtime camera, activity, and notification permissions"],
            ["IDE", "Android Studio", "Development environment"],
            ["Version Control", "Git", "Source code version management"],
            ["UI Design", "Figma", "UI/UX mockup design"],
        ],
        [1.8, 2.0, 2.8]
    )

    h2("4.4 System Requirements")

    body('Hardware Requirements:')
    add_table(
        ["Requirement", "Specification"],
        [
            ["Smartphone", "Android device with front and rear cameras"],
            ["Sensors", "Accelerometer (built-in), Camera with flashlight/torch"],
            ["RAM", "Minimum 2 GB (4 GB recommended for smooth AI processing)"],
            ["Storage", "Minimum 200 MB free space"],
            ["Processor", "ARM-based processor (Snapdragon/MediaTek/Exynos)"],
        ],
        [2.5, 4.0]
    )

    body('Software Requirements:')
    add_table(
        ["Requirement", "Specification"],
        [
            ["Operating System", "Android 5.0 (Lollipop, API Level 21) or above"],
            ["Flutter SDK", "Version 3.11.3 or above"],
            ["Dart SDK", "Compatible with Flutter 3.11.3"],
            ["Development IDE", "Android Studio"],
            ["Internet", "Not required for core features (fully offline)"],
        ],
        [2.5, 4.0]
    )

    doc.add_page_break()

    # ================================================================
    #          CHAPTER 5: EXPECTED OUTCOMES (Page 12)
    # ================================================================
    h1("5. Expected Outcomes")

    body(
        'The following outcomes are expected from the successful completion of this project:\n\n'
        '1. A fully functional, production-quality mobile application that provides a unified '
        'fitness experience, eliminating the need for multiple separate applications.\n\n'
        '2. Demonstrated real-time on-device AI exercise detection capable of accurately counting '
        'repetitions for 11+ exercise types and evaluating posture correctness through '
        'biomechanical angle analysis — all without internet connectivity.\n\n'
        '3. Validated camera-based PPG heart rate measurement that provides reasonably accurate '
        'BPM readings using only the smartphone\'s rear camera and flashlight.\n\n'
        '4. Accurate accelerometer-based step counting with distance and calorie estimation, '
        'supported by historical trend analysis.\n\n'
        '5. A comprehensive exercise library of 256 exercises with animated visual guides across '
        'gym, home workout, UFC combat, and challenge categories.\n\n'
        '6. An engaging gamification system that demonstrates measurable user retention through '
        'XP progression, rank achievements, and celebratory feedback.\n\n'
        '7. A scalable, modular codebase architecture that can accommodate future enhancements '
        'such as cloud synchronization, TFLite ML model integration (training scripts already '
        'prepared in Python), social features, and wearable device connectivity.'
    )

    h2("5.1 Innovation and Novelty")
    body(
        'The key innovations and novel aspects of FitFi include:\n\n'
        '1. Real-Time AI Pose Detection in a Consumer Fitness App: While Google ML Kit Pose '
        'Detection is available as a technology, its integration into a full-featured fitness '
        'app with biomechanical angle calculations, exercise-specific state machines, and '
        'real-time visual skeleton feedback is a novel application.\n\n'
        '2. Comprehensive All-in-One Architecture: The combination of AI vision, hardware sensor '
        'integration (PPG + accelerometer), structured course-based workouts, combat training, '
        'and gamification in a single offline application is unprecedented in the consumer '
        'fitness app space.\n\n'
        '3. Solo Leveling-Inspired Gamification for Fitness: Applying a multi-tier XP/ranking '
        'system inspired by anime/gaming culture to fitness is a novel approach to solving the '
        'user retention problem in health applications.\n\n'
        '4. UFC Combat Training Integration: Offering structured Dagestani and Irish combat '
        'training styles alongside traditional gym workouts within the same application is unique.\n\n'
        '5. Adaptive Performance Optimization: The built-in device profiling and adaptive '
        'animation/memory management ensures consistent user experience across device tiers — '
        'a consideration often overlooked in fitness app development.\n\n'
        '6. Fully Offline On-Device AI: All computer vision processing, sensor analysis, and '
        'data persistence occurs on-device without requiring internet connectivity, making the '
        'app accessible in any network condition.'
    )

    doc.add_page_break()

    # ================================================================
    #            CHAPTER 6: WORK PLAN AND TIMELINE (Page 13)
    # ================================================================
    h1("6. Work Plan and Timeline")

    body(
        'The following table presents the month-wise work plan followed during the development '
        'of FitFi:'
    )

    timeline = doc.add_table(rows=14, cols=6)
    timeline.style = 'Table Grid'
    timeline.alignment = WD_TABLE_ALIGNMENT.CENTER

    headers = ["Activity", "Month 1", "Month 2", "Month 3", "Month 4", "Status"]
    activities = [
        ("Problem Identification & Requirement Analysis", [1,0,0,0], "Completed"),
        ("UI/UX Design (Figma Mockups)", [1,0,0,0], "Completed"),
        ("Project Setup & Folder Architecture", [1,0,0,0], "Completed"),
        ("Core Navigation & Home Dashboard", [0,1,0,0], "Completed"),
        ("Step Counter (Accelerometer Integration)", [0,1,0,0], "Completed"),
        ("Water Tracker (with Notifications)", [0,1,0,0], "Completed"),
        ("Heart Rate Monitor (PPG Camera)", [0,1,0,0], "Completed"),
        ("AI Pose Detection & Rep Counter", [0,1,1,0], "Completed"),
        ("Gym Courses, Onboarding & Workout Player", [0,0,1,0], "Completed"),
        ("UFC Combat Training Programs", [0,0,1,0], "Completed"),
        ("Challenge System & XP Gamification", [0,0,1,0], "Completed"),
        ("Diet Plan & Account Dashboard", [0,0,1,0], "Completed"),
        ("Performance Optimization, Testing & Documentation", [0,0,0,1], "In Progress"),
    ]

    # Write headers
    for j, h in enumerate(headers):
        cell = timeline.cell(0, j)
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        run = p.add_run(h)
        run.font.name = 'Times New Roman'
        run.font.size = Pt(10)
        run.bold = True
        set_cell_shading(cell, "1F4E79")
        run.font.color.rgb = RGBColor(255, 255, 255)

    for i, (activity, months_active, status) in enumerate(activities):
        row_idx = i + 1
        # Activity name
        cell = timeline.cell(row_idx, 0)
        run = cell.paragraphs[0].add_run(activity)
        run.font.name = 'Times New Roman'
        run.font.size = Pt(10)
        # Month columns
        for j, active in enumerate(months_active):
            cell = timeline.cell(row_idx, j + 1)
            cell.paragraphs[0].alignment = WD_ALIGN_PARAGRAPH.CENTER
            if active:
                run = cell.paragraphs[0].add_run(">>>")
                run.font.name = 'Times New Roman'
                run.font.size = Pt(10)
                run.bold = True
                set_cell_shading(cell, "A9D18E")
        # Status
        cell = timeline.cell(row_idx, 5)
        cell.paragraphs[0].alignment = WD_ALIGN_PARAGRAPH.CENTER
        run = cell.paragraphs[0].add_run(status)
        run.font.name = 'Times New Roman'
        run.font.size = Pt(10)
        if status == "Completed":
            set_cell_shading(cell, "C6EFCE")
        else:
            set_cell_shading(cell, "FFF2CC")
        if i % 2 == 0:
            for j in range(6):
                if not months_active[j-1] if 1 <= j <= 4 else True:
                    pass  # alternating handled by cell shading above

    doc.add_paragraph()

    doc.add_page_break()

    # ================================================================
    #              CHAPTER 7: CONCLUSION (Page 14)
    # ================================================================
    h1("7. Conclusion")

    body(
        'The FitFi project successfully demonstrates the design and development of a comprehensive, '
        'AI-powered fitness and wellness mobile application that integrates multiple health tracking '
        'and exercise guidance modules into a single unified platform. Built using the Flutter '
        'framework, the application delivers a polished, animated, and intuitive user experience '
        'across all its features.'
    )
    body(
        'The project has achieved all its primary objectives:\n\n'
        '- Real-time on-device AI exercise tracking using Google ML Kit Pose Detection has been '
        'successfully implemented, capable of identifying 33 body landmarks, calculating joint '
        'angles, counting repetitions, evaluating posture, and providing real-time visual and '
        'textual feedback for 11+ exercise types.\n\n'
        '- Camera-based PPG heart rate measurement has been implemented using the rear camera '
        'and flashlight, providing BPM readings without any external hardware.\n\n'
        '- Accelerometer-based step counting has been implemented with peak-detection algorithms, '
        'debounce filtering, and comprehensive trend analysis.\n\n'
        '- A comprehensive workout ecosystem has been built with 256 exercises, structured gym '
        'courses with personalization onboarding, UFC combat training in two styles, a 6-level '
        'ranked challenge system, and a guided 5-phase workout player.\n\n'
        '- A gamified XP and ranking system has been implemented with 10 levels, 11 ranks, '
        'and dual domain tracks, providing gaming-level motivation for fitness consistency.\n\n'
        '- The entire application operates offline with on-device processing and local storage.'
    )
    body(
        'The modular, layered architecture ensures that the application is ready for future '
        'enhancements. Python ML training scripts for body type classification (MobileNetV2), '
        'diet optimization, and progressive overload prediction have already been developed and '
        'exported as TFLite models, ready for integration in subsequent project phases. '
        'Additional planned features include cloud synchronization, social/community features, '
        'GPS-based outdoor activity tracking, and wearable device connectivity.'
    )
    body(
        'FitFi establishes a strong, practical, and scalable foundation for a next-generation '
        'fitness application that prioritizes user experience, intelligent fitness guidance, '
        'and offline accessibility.'
    )

    doc.add_page_break()

    # ================================================================
    #                   REFERENCES (Page 15)
    # ================================================================
    h1("References")

    refs = [
        '[1] Google, "ML Kit Pose Detection — Detect the position of the human body in real time," '
        '[Online]. Available: https://developers.google.com/ml-kit/vision/pose-detection. '
        'Accessed: Sept. 2026.',

        '[2] Google, "Flutter — Build apps for any screen," [Online]. Available: '
        'https://flutter.dev/. Accessed: Sept. 2026.',

        '[3] Flutter Community, "sensors_plus — Flutter plugin for accessing accelerometer, '
        'gyroscope, and magnetometer sensors," [Online]. Available: '
        'https://pub.dev/packages/sensors_plus. Accessed: Sept. 2026.',

        '[4] Flutter Community, "camera — Flutter plugin for controlling device cameras to display '
        'a preview, capture images and video," [Online]. Available: '
        'https://pub.dev/packages/camera. Accessed: Sept. 2026.',

        '[5] Google, "google_mlkit_pose_detection — Flutter plugin for Google ML Kit Pose Detection '
        'API," [Online]. Available: https://pub.dev/packages/google_mlkit_pose_detection. '
        'Accessed: Sept. 2026.',

        '[6] J. Allen, "Photoplethysmography and its application in clinical physiological '
        'measurement," Physiological Measurement, vol. 28, no. 3, pp. R1-R39, 2007.',

        '[7] Airbnb, "Lottie for Flutter — Render After Effects animations natively on Flutter," '
        '[Online]. Available: https://pub.dev/packages/lottie. Accessed: Sept. 2026.',

        '[8] Flutter Community, "percent_indicator — Circular and Linear percent indicators for '
        'Flutter," [Online]. Available: https://pub.dev/packages/percent_indicator. '
        'Accessed: Sept. 2026.',

        '[9] Flutter Community, "flutter_local_notifications — A cross-platform plugin for '
        'displaying local notifications," [Online]. Available: '
        'https://pub.dev/packages/flutter_local_notifications. Accessed: Sept. 2026.',

        '[10] Flutter Community, "table_calendar — Highly customizable, feature-packed Flutter '
        'Calendar," [Online]. Available: https://pub.dev/packages/table_calendar. '
        'Accessed: Sept. 2026.',
    ]

    for ref in refs:
        body(ref, 8)

    # ===== SAVE =====
    doc.save('c:/Users/nsraw/StudioProjects/dhfif/synopsisAndPresentation/FitFi_Synopsis.docx')
    print("Synopsis generated successfully! (Improved version)")

if __name__ == '__main__':
    create_synopsis()
