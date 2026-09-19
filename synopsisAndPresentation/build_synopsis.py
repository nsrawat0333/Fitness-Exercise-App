import docx
from docx.shared import Inches, Pt, Cm, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.enum.section import WD_SECTION
from docx.oxml import OxmlElement
from docx.oxml.ns import qn

def set_cell_shading(cell, color_hex):
    shading_elm = OxmlElement('w:shd')
    shading_elm.set(qn('w:fill'), color_hex)
    shading_elm.set(qn('w:val'), 'clear')
    cell._tc.get_or_add_tcPr().append(shading_elm)

def add_page_number_to_run(run):
    fldChar1 = OxmlElement('w:fldChar')
    fldChar1.set(qn('w:fldCharType'), 'begin')
    instrText = OxmlElement('w:instrText')
    instrText.set(qn('xml:space'), 'preserve')
    instrText.text = 'PAGE'
    fldChar2 = OxmlElement('w:fldChar')
    fldChar2.set(qn('w:fldCharType'), 'separate')
    fldChar3 = OxmlElement('w:fldChar')
    fldChar3.set(qn('w:fldCharType'), 'end')
    r = run._r
    r.append(fldChar1)
    r.append(instrText)
    r.append(fldChar2)
    r.append(fldChar3)

def create_official_synopsis(output_filepath):
    doc = docx.Document()

    # SECTION 1: PRELIMINARY PAGES (A4, Margins: Top 1.0", Bottom 1.0", Left 1.5", Right 1.0")
    sec1 = doc.sections[0]
    sec1.top_margin = Inches(1.0)
    sec1.bottom_margin = Inches(1.0)
    sec1.left_margin = Inches(1.5)
    sec1.right_margin = Inches(1.0)
    sec1.page_width = Cm(21.0)
    sec1.page_height = Cm(29.7)
    sec1.different_first_page_header_footer = True

    # Roman numerals for preliminary pages (i, ii, iii...)
    sectPr1 = sec1._sectPr
    pgNumType1 = OxmlElement('w:pgNumType')
    pgNumType1.set(qn('w:fmt'), 'lowerRoman')
    pgNumType1.set(qn('w:start'), '1')
    sectPr1.append(pgNumType1)

    # Footer for subsequent preliminary pages
    footer1 = sec1.footer
    p_foot1 = footer1.paragraphs[0]
    p_foot1.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    run_foot1 = p_foot1.add_run()
    run_foot1.font.name = 'Times New Roman'
    run_foot1.font.size = Pt(10)
    add_page_number_to_run(run_foot1)

    # STYLES CONFIGURATION
    style_normal = doc.styles['Normal']
    style_normal.font.name = 'Times New Roman'
    style_normal.font.size = Pt(12)
    style_normal.paragraph_format.line_spacing = 1.5
    style_normal.paragraph_format.space_after = Pt(6)

    def add_centered(text, size=12, bold=False, space_after=6):
        p = doc.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p.paragraph_format.line_spacing = 1.5
        p.paragraph_format.space_after = Pt(space_after)
        run = p.add_run(text)
        run.font.name = 'Times New Roman'
        run.font.size = Pt(size)
        run.bold = bold
        return p

    def add_body_p(text, space_after=6):
        p = doc.add_paragraph(style='Normal')
        p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
        p.paragraph_format.line_spacing = 1.5
        p.paragraph_format.space_after = Pt(space_after)
        run = p.add_run(text)
        run.font.name = 'Times New Roman'
        run.font.size = Pt(12)
        return p

    def add_h1(text):
        p = doc.add_paragraph()
        p.paragraph_format.line_spacing = 1.5
        p.paragraph_format.space_before = Pt(14)
        p.paragraph_format.space_after = Pt(6)
        p.paragraph_format.keep_with_next = True
        run = p.add_run(text)
        run.font.name = 'Times New Roman'
        run.font.size = Pt(14)
        run.bold = True
        run.font.color.rgb = RGBColor(0, 0, 0)
        return p

    def add_h2(text):
        p = doc.add_paragraph()
        p.paragraph_format.line_spacing = 1.5
        p.paragraph_format.space_before = Pt(10)
        p.paragraph_format.space_after = Pt(4)
        p.paragraph_format.keep_with_next = True
        run = p.add_run(text)
        run.font.name = 'Times New Roman'
        run.font.size = Pt(12)
        run.bold = True
        run.font.color.rgb = RGBColor(0, 0, 0)
        return p

    def spacer(lines=1):
        for _ in range(lines):
            p = doc.add_paragraph()
            p.paragraph_format.space_before = Pt(0)
            p.paragraph_format.space_after = Pt(0)
            p.paragraph_format.line_spacing = 1.0

    # =========================================================================
    # PRELIMINARY PAGE 1: TITLE PAGE (Page i - suppressed header/footer)
    # =========================================================================
    spacer(1)
    add_centered("FitFi: AI-Powered Smart Fitness Coach", 18, True, 6)
    add_centered("A Comprehensive Mobile Fitness and Wellness Application", 13, False, 28)

    add_centered("Synopsis", 16, True, 6)
    add_centered("Submitted to", 12, False, 4)
    add_centered("Dev Bhoomi Uttarakhand University", 14, True, 6)
    add_centered("In partial fulfillment of the requirements for the degree of", 12, False, 4)
    add_centered("Bachelor of Technology", 14, True, 4)
    add_centered("in", 12, False, 4)
    add_centered("Computer Science & Engineering", 14, True, 20)

    add_centered("By", 12, True, 6)
    add_centered("Student Name 1\nEnrollment No.: ………………...", 12, False, 4)
    add_centered("Student Name 2\nEnrollment No.: ………………...", 12, False, 4)
    add_centered("Student Name 3\nEnrollment No.: ………………...", 12, False, 16)

    # Supervisor Table
    table_sup = doc.add_table(rows=3, cols=2)
    table_sup.alignment = WD_TABLE_ALIGNMENT.CENTER
    sup_entries = [
        ("Supervisor", "Co-Supervisor (If Any)"),
        ("Name: ………………………", "Name: ………………………"),
        ("Designation: ………………", "Designation: ………………"),
    ]
    for r_idx, (c0, c1) in enumerate(sup_entries):
        for c_idx, val in enumerate((c0, c1)):
            cell = table_sup.cell(r_idx, c_idx)
            p = cell.paragraphs[0]
            p.alignment = WD_ALIGN_PARAGRAPH.CENTER
            p.paragraph_format.line_spacing = 1.15
            p.paragraph_format.space_after = Pt(2)
            run = p.add_run(val)
            run.font.name = 'Times New Roman'
            run.font.size = Pt(11)
            if r_idx == 0:
                run.bold = True

    spacer(1)
    add_centered("DEV BHOOMI UTTARAKHAND UNIVERSITY", 13, True, 2)
    add_centered("(Established by Govt. of Uttarakhand vide Dev Bhoomi Uttarakhand University Act No. 17 of 2021)", 10, False, 4)
    add_centered("Batch (2026 - 2027)", 12, True, 0)

    doc.add_page_break()

    # =========================================================================
    # PRELIMINARY PAGE 2: CERTIFICATE (Page ii)
    # =========================================================================
    spacer(1)
    add_centered("CERTIFICATE", 14, True, 18)

    add_body_p(
        "This is to certify that Mr./Ms. _________________________ is a Bachelor of Technology student "
        "at Dev Bhoomi Uttarakhand University, Dehradun. He/She has worked on the project entitled "
        "\"FitFi: AI-Powered Smart Fitness Coach\" under my/our supervision and guidance at the School of "
        "Engineering and Computing (SoEC), Department of Computer Science & Engineering, for the partial "
        "fulfillment of the requirements for the degree of Bachelor of Technology (B.Tech.) in Computer "
        "Science & Engineering."
    )

    spacer(2)

    cert_tbl = doc.add_table(rows=4, cols=2)
    cert_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    cert_rows = [
        ("Supervisor", "Co-Supervisor (If Any)"),
        ("", ""),
        ("Signature: …………………………", "Signature: …………………………"),
        ("Name: ………………………………", "Name: ………………………………"),
    ]
    for r_idx, (c0, c1) in enumerate(cert_rows):
        for c_idx, val in enumerate((c0, c1)):
            cell = cert_tbl.cell(r_idx, c_idx)
            p = cell.paragraphs[0]
            p.alignment = WD_ALIGN_PARAGRAPH.CENTER
            p.paragraph_format.line_spacing = 1.15
            p.paragraph_format.space_after = Pt(2)
            run = p.add_run(val)
            run.font.name = 'Times New Roman'
            run.font.size = Pt(11)
            if r_idx == 0:
                run.bold = True

    spacer(1)
    add_body_p("Date: ………………………")

    doc.add_page_break()

    # =========================================================================
    # PRELIMINARY PAGE 3: DECLARATION (Page iii)
    # =========================================================================
    spacer(1)
    add_centered("DECLARATION BY RESEARCH SCHOLAR", 14, True, 18)

    add_body_p(
        "I/We hereby declare that the synopsis of proposed project work entitled \"FitFi: AI-Powered "
        "Smart Fitness Coach\" submitted in partial fulfillment of the requirements for the award of degree "
        "of Bachelor of Technology in Computer Science & Engineering and submitted to Dev Bhoomi Uttarakhand "
        "University, Dehradun, Uttarakhand, has been carried out by me/us under the expert guidance as well as "
        "direct supervision of <Supervisor Name>."
    )
    add_body_p(
        "I/We further declare that the work carried out is our original work and material obtained from other "
        "sources has been duly acknowledged in the synopsis. This work has not been submitted to any other "
        "university or institute for the award of any other degree or diploma."
    )

    spacer(2)

    decl_tbl = doc.add_table(rows=4, cols=1)
    decl_data = [
        "Signature: …………………………………",
        "Name: ………………………………………",
        "Enrollment No.: …………………………",
        "Department/School: CSE / SoEC",
    ]
    for r_idx, text_val in enumerate(decl_data):
        cell = decl_tbl.cell(r_idx, 0)
        p = cell.paragraphs[0]
        p.paragraph_format.line_spacing = 1.15
        p.paragraph_format.space_after = Pt(3)
        run = p.add_run(text_val)
        run.font.name = 'Times New Roman'
        run.font.size = Pt(12)

    spacer(1)
    add_body_p("Date: ………………………")
    add_body_p("Place: Dev Bhoomi Uttarakhand University, Dehradun")

    doc.add_page_break()

    # =========================================================================
    # PRELIMINARY PAGE 4: PROJECT DETAILS (Page iv)
    # =========================================================================
    spacer(1)
    add_centered("DETAILS OF PROPOSED MAJOR PROJECT - I", 14, True, 18)

    info_data = [
        ("Title of Proposed Work:", "FitFi: AI-Powered Smart Fitness Coach"),
        ("Programme:", "Bachelor of Technology (B.Tech.)"),
        ("Department / School:", "Computer Science & Engineering / SoEC"),
        ("Names of Students:", "1. Student Name 1 (Enrollment No.: ………………)\n"
                               "2. Student Name 2 (Enrollment No.: ………………)\n"
                               "3. Student Name 3 (Enrollment No.: ………………)"),
        ("Supervisor Name & Designation:", "Supervisor Name, Professor (CSE), SoEC, DBUU"),
        ("Co-Supervisor Name & Designation:", "Co-Supervisor Name, Professor (CSE), SoEC, DBUU"),
        ("Place of Work:", "Dev Bhoomi Uttarakhand University, Dehradun"),
    ]

    info_tbl = doc.add_table(rows=len(info_data), cols=2)
    info_tbl.style = 'Table Grid'
    info_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    for r_idx, (col0, col1) in enumerate(info_data):
        cell0 = info_tbl.cell(r_idx, 0)
        cell1 = info_tbl.cell(r_idx, 1)
        cell0.width = Inches(2.2)
        cell1.width = Inches(4.3)
        p0 = cell0.paragraphs[0]
        p0.paragraph_format.line_spacing = 1.15
        p0.paragraph_format.space_after = Pt(2)
        r0 = p0.add_run(col0)
        r0.font.name = 'Times New Roman'
        r0.font.size = Pt(11)
        r0.bold = True
        set_cell_shading(cell0, "F2F2F2")

        p1 = cell1.paragraphs[0]
        p1.paragraph_format.line_spacing = 1.15
        p1.paragraph_format.space_after = Pt(2)
        r1 = p1.add_run(col1)
        r1.font.name = 'Times New Roman'
        r1.font.size = Pt(11)

    spacer(2)
    add_body_p("Signatures:")
    add_body_p("1. Supervisor: ………………………   2. Co-Supervisor: ………………………   3. Students: ………………………")

    doc.add_page_break()

    # =========================================================================
    # PRELIMINARY PAGE 5: TABLE OF CONTENTS (Page v)
    # =========================================================================
    add_centered("TABLE OF CONTENTS", 14, True, 16)

    toc_items = [
        ("Heading", "Page No."),
        ("Certificate", "ii"),
        ("Declaration by Research Scholar", "iii"),
        ("Details of Proposed Major Project - I", "iv"),
        ("Table of Contents", "v"),
        ("1. Introduction", "1"),
        ("    1.1 Problem Statement", "1"),
        ("    1.2 Objectives of the Project", "2"),
        ("    1.3 Scope of the Project", "3"),
        ("2. Literature Review and Existing Systems", "4"),
        ("3. Research and Development Gaps", "5"),
        ("4. Proposed System — FitFi", "6"),
        ("    4.1 System Architecture", "6"),
        ("    4.2 Modules of the Project", "7"),
        ("    4.3 Technologies and Tools Used", "10"),
        ("    4.4 System Requirements", "11"),
        ("5. Expected Outcomes and Innovation", "12"),
        ("    5.1 Expected Outcomes", "12"),
        ("    5.2 Innovation and Novelty", "12"),
        ("6. Work Plan and Timeline", "13"),
        ("7. Conclusion", "14"),
        ("8. References", "15"),
    ]

    toc_table = doc.add_table(rows=len(toc_items), cols=2)
    toc_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    for r_idx, (title_str, page_str) in enumerate(toc_items):
        cell0 = toc_table.cell(r_idx, 0)
        cell1 = toc_table.cell(r_idx, 1)
        cell0.width = Inches(5.3)
        cell1.width = Inches(1.2)
        p0 = cell0.paragraphs[0]
        p0.paragraph_format.line_spacing = 1.15
        p0.paragraph_format.space_after = Pt(2)
        r0 = p0.add_run(title_str)
        r0.font.name = 'Times New Roman'
        r0.font.size = Pt(11)
        if r_idx == 0 or (title_str[0].isdigit() and not title_str.startswith(' ')):
            r0.bold = True

        p1 = cell1.paragraphs[0]
        p1.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p1.paragraph_format.line_spacing = 1.15
        p1.paragraph_format.space_after = Pt(2)
        r1 = p1.add_run(page_str)
        r1.font.name = 'Times New Roman'
        r1.font.size = Pt(11)
        if r_idx == 0 or (title_str[0].isdigit() and not title_str.startswith(' ')):
            r1.bold = True

    # =========================================================================
    # SECTION 2: MAIN TEXT ONWARDS (Arabic numerals 1, 2, 3...)
    # =========================================================================
    sec2 = doc.add_section(WD_SECTION.NEW_PAGE)
    sec2.top_margin = Inches(1.0)
    sec2.bottom_margin = Inches(1.0)
    sec2.left_margin = Inches(1.5)
    sec2.right_margin = Inches(1.0)
    sec2.page_width = Cm(21.0)
    sec2.page_height = Cm(29.7)
    sec2.footer.is_linked_to_previous = False

    sectPr2 = sec2._sectPr
    pgNumType2 = OxmlElement('w:pgNumType')
    pgNumType2.set(qn('w:fmt'), 'decimal')
    pgNumType2.set(qn('w:start'), '1')
    sectPr2.append(pgNumType2)

    footer2 = sec2.footer
    p_foot2 = footer2.paragraphs[0]
    p_foot2.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    run_foot2 = p_foot2.add_run()
    run_foot2.font.name = 'Times New Roman'
    run_foot2.font.size = Pt(10)
    add_page_number_to_run(run_foot2)

    # -------------------------------------------------------------------------
    # CHAPTER 1: INTRODUCTION
    # -------------------------------------------------------------------------
    add_h1("1. Introduction")

    add_body_p(
        "With the rapid advancement of mobile computing and pervasive sensor technologies, "
        "smartphones have emerged as ubiquitous platforms for personal health and wellness monitoring. "
        "Modern mobile devices are equipped with sophisticated cameras, accelerometers, gyroscopes, "
        "and multi-core processors capable of running complex algorithms locally. Despite this technological "
        "capability, the existing landscape of health and fitness applications remains substantially fragmented. "
        "A typical user is required to juggle three to four separate applications: one application for daily "
        "step counting, a second for logging water consumption, a third for guided workout demonstrations, "
        "and a fourth for heart rate measurement. This fragmentation leads to user fatigue, inconsistent tracking, "
        "and poor long-term retention."
    )
    add_body_p(
        "FitFi (\"AI-Powered Smart Fitness Coach\") addresses this challenge by providing a unified, cross-platform "
        "mobile application developed with the Flutter framework. FitFi integrates on-device Artificial Intelligence "
        "via Google ML Kit Pose Detection, hardware-based Photoplethysmography (PPG) heart rate sensing, accelerometer-based "
        "step counting, interactive hydration management, structured gym workouts containing 256 mapped exercises, "
        "UFC combat training routines, and a Solo Leveling-inspired gamified progression system into a single cohesive interface. "
        "Crucially, the entire application is architected to operate fully offline, ensuring complete data privacy and "
        "uninterrupted functionality without dependency on remote servers or cloud connectivity."
    )

    add_h2("1.1 Problem Statement")
    add_body_p(
        "An investigation of the current mobile health and fitness domain identifies several critical shortcomings:\n"
        "1. Fragmented Ecosystem: Users must install and maintain multiple disconnected applications to track basic "
        "health indicators (steps, hydration, heart rate, workouts). Each application maintains an isolated data silo, "
        "preventing a holistic assessment of overall physical wellness.\n"
        "2. Absence of Real-Time Biomechanical Form Analysis: Conventional fitness applications present pre-recorded "
        "workout video streams. They lack the computational intelligence to evaluate whether the user is executing an exercise "
        "with anatomically correct form. Incorrect exercise posture frequently leads to musculoskeletal injuries and sub-optimal "
        "training outcomes.\n"
        "3. Dependency on Dedicated Wearable Hardware: Standard cardiovascular monitoring solutions rely on external "
        "smartwatches or chest straps. Although smartphone cameras are technically capable of performing optical "
        "Photoplethysmography (PPG), this technique remains widely neglected in consumer fitness suites.\n"
        "4. High User Attrition Due to Insufficient Gamification: Fitness applications experience exceptionally high drop-off "
        "rates within the first thirty days. Standard motivational mechanisms, such as plain streak counters, fail to provide "
        "the immersive engagement offered by modern gamification paradigms.\n"
        "5. Excessive Cloud Dependency: Numerous commercial fitness platforms require active internet connectivity even for "
        "rudimentary operations, creating privacy risks and rendering the application unusable in off-grid or poor-network environments."
    )

    add_h2("1.2 Objectives of the Project")
    add_body_p(
        "The primary objectives of this project are strictly formulated based on the implemented technical architecture:\n"
        "1. Unified Cross-Platform Architecture: To engineer an all-in-one mobile fitness platform using Flutter, seamlessly "
        "integrating step counting, hydration tracking, heart rate monitoring, computer vision exercise tracking, gym routines, "
        "combat training, and gamification.\n"
        "2. Real-Time On-Device AI Pose Detection: To integrate Google ML Kit Pose Detection to accurately detect 33 human "
        "body landmarks from live camera video frames at interactive frame rates without cloud transmission.\n"
        "3. Biomechanical Angle and Repetition State Machine: To build a dedicated RepCounterService utilizing trigonometric "
        "angle calculations (atan2) across critical joint vectors to automate repetition counting for Push-ups, Pull-ups, "
        "Squats, Lunges, Crunches, Burpees, Jumping Jacks, and High Knees, and validate posture linearity for isometric holds "
        "(Planks, Wall Sits, Side Planks).\n"
        "4. Optical PPG Heart Rate Sensing: To implement rear camera and flashlight Photoplethysmography that measures systolic "
        "capillary blood volume fluctuations across a 50x50 region of interest, yielding real-time BPM and signal quality.\n"
        "5. Sensor-Driven Accelerometer Pedometer: To develop an accelerometer-based step counter utilizing 3D vector magnitude "
        "thresholding (>12.0 m/s2) coupled with a 300ms debounce filter for precise step, distance, and calorie estimation.\n"
        "6. Structured Workout and Gamification Framework: To implement a 256-exercise library with animated guides (Lottie, GIF), "
        "guided interval workout player, UFC combat modules (Dagestani and Irish philosophies), and a 10-level, 11-rank XP "
        "progression system."
    )

    add_h2("1.3 Scope of the Project")
    add_body_p(
        "Target Users: Fitness enthusiasts of all experience tiers (Beginner, Intermediate, Advanced), gym practitioners, "
        "combat sports trainees, and individuals seeking holistic daily wellness tracking.\n"
        "Supported Platform: Cross-platform mobile architecture built on Flutter, targeting Android 5.0 (API level 21) and above, "
        "with architectural compatibility for iOS deployment.\n"
        "Functional Boundaries: All computer vision pose inference, sensor streaming, signal processing, and data persistence "
        "execute completely locally on the device. Cloud synchronization, multi-user social leaderboards, and GPS map tracking "
        "are explicitly outside the current implementation scope and designated for future releases.\n"
        "Scalability and Extensibility: The codebase adheres to strict separation of concerns across presentation, service, "
        "data, and model layers. Offline Python machine learning models for body classification, caloric adjustment, and "
        "progressive overload estimation have been authored and stand prepared for subsequent TensorFlow Lite mobile embedding."
    )

    doc.add_page_break()

    # -------------------------------------------------------------------------
    # CHAPTER 2: LITERATURE REVIEW / EXISTING SYSTEMS
    # -------------------------------------------------------------------------
    add_h1("2. Literature Review and Existing Systems")

    add_body_p(
        "An exhaustive survey of commercial fitness applications and peer-reviewed literature in mobile health informatics "
        "was conducted to benchmark existing solutions. The findings are summarized in Table 2.1 below."
    )

    add_centered("Table 2.1: Comparative Analysis of Existing Fitness Applications", 11, True, 4)

    lit_data = [
        ("Application", "Core Capabilities", "Identified Limitations"),
        ("Google Fit",
         "Passive step tracking, GPS activity logging, Google ecosystem integration.",
         "No real-time AI exercise form detection, no structured strength courses, no camera PPG heart rate, lacks gamification."),
        ("MyFitnessPal",
         "Comprehensive nutritional database, caloric and macronutrient logging, barcode scanner.",
         "Lacks real-time exercise form validation, no optical heart rate scanning, relies completely on manual logging."),
        ("Nike Training Club",
         "High-production instructional workout videos, categorized training routines.",
         "Zero real-time feedback on user execution posture, cannot automatically count repetitions, lacks hydration and heart rate tracking."),
        ("Freeletics",
         "Algorithmic workout plan generation based on periodic user inputs.",
         "AI is restricted to static routine generation; no computer vision pose analysis during exercise execution; subscription barrier."),
        ("FitFi (Proposed)",
         "Unified suite: Real-time ML Kit pose detection, PPG camera heart rate, accelerometer pedometer, 256 exercises, UFC combat, XP gamification.",
         "Current operational boundary is completely local and offline (cloud synchronization planned for Phase II)."),
    ]

    lit_table = doc.add_table(rows=len(lit_data), cols=3)
    lit_table.style = 'Table Grid'
    lit_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    for r_idx, row in enumerate(lit_data):
        for c_idx, val in enumerate(row):
            cell = lit_table.cell(r_idx, c_idx)
            cell.width = Inches(1.5 if c_idx == 0 else 2.5)
            p = cell.paragraphs[0]
            p.paragraph_format.line_spacing = 1.15
            p.paragraph_format.space_after = Pt(2)
            run = p.add_run(val)
            run.font.name = 'Times New Roman'
            run.font.size = Pt(10)
            if r_idx == 0:
                run.bold = True
                set_cell_shading(cell, "D9E1F2")
            elif r_idx == len(lit_data) - 1:
                set_cell_shading(cell, "E2EFDA")

    spacer(1)
    add_body_p(
        "Literature in biomedical engineering (Allen, 2007) demonstrates that smartphone camera sensors utilizing "
        "Photoplethysmography can accurately resolve arterial pulse signals by quantifying light absorption changes in "
        "microvascular tissue. Furthermore, recent breakthroughs in edge computer vision (Google ML Kit, 2023) allow "
        "deep neural networks to execute pose landmark estimation in under thirty milliseconds on mobile hardware. FitFi "
        "capitalizes on these advancements by synthesizing real-time pose tracking, optical PPG, and accelerometer processing "
        "into an integrated mobile health architecture."
    )

    doc.add_page_break()

    # -------------------------------------------------------------------------
    # CHAPTER 3: RESEARCH AND DEVELOPMENT GAPS
    # -------------------------------------------------------------------------
    add_h1("3. Research and Development Gaps")

    add_body_p(
        "A rigorous synthesis of existing systems and academic literature identifies six prominent development gaps "
        "that FitFi directly resolves:"
    )

    gaps_data = [
        ("S.No.", "Identified Development Gap", "FitFi Technical Resolution"),
        ("1",
         "Application Fragmentation: Users must switch between multiple single-purpose apps for basic health tracking.",
         "FitFi unifies step counting, hydration logging, heart rate scanning, AI exercise feedback, gym routines, combat training, and diet into one app."),
        ("2",
         "Absence of Real-Time Form Correction: Video-based workout apps provide passive instruction without evaluating posture.",
         "FitFi embeds Google ML Kit Pose Detection with atan2 joint angle calculation to monitor joint angles and deliver instant visual and textual cues."),
        ("3",
         "Hardware Barrier for Cardiovascular Metrics: Pulse monitoring is gated behind costly smartwatches or chest straps.",
         "FitFi implements camera torch PPG, allowing any standard smartphone to record beats per minute with zero peripheral cost."),
        ("4",
         "Superficial Gamification: Existing apps employ simplistic day streaks that fail to prevent user attrition.",
         "FitFi integrates a multi-tier XP engine (10 levels, 11 ranks) featuring dual progression tracks (Gym and Challenge) with animated milestone rewards."),
        ("5",
         "Cloud Vulnerability and Privacy Concerns: Commercial fitness suites stream private biometric metrics to remote servers.",
         "FitFi executes all inference and analytics on-device with SharedPreferences persistence, guaranteeing complete data privacy."),
        ("6",
         "Neglect of Combat Sports Conditioning: Standard platforms cater solely to conventional gym or calisthenics routines.",
         "FitFi provides dedicated UFC combat conditioning curriculums embodying Dagestani (grappling/cardio) and Irish (striking/explosiveness) disciplines."),
    ]

    add_centered("Table 3.1: Research and Development Gaps Addressed by FitFi", 11, True, 4)

    gaps_table = doc.add_table(rows=len(gaps_data), cols=3)
    gaps_table.style = 'Table Grid'
    gaps_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    for r_idx, row in enumerate(gaps_data):
        for c_idx, val in enumerate(row):
            cell = gaps_table.cell(r_idx, c_idx)
            cell.width = Inches(0.6 if c_idx == 0 else 2.9)
            p = cell.paragraphs[0]
            p.paragraph_format.line_spacing = 1.15
            p.paragraph_format.space_after = Pt(2)
            run = p.add_run(val)
            run.font.name = 'Times New Roman'
            run.font.size = Pt(10)
            if r_idx == 0:
                run.bold = True
                set_cell_shading(cell, "D9E1F2")

    doc.add_page_break()

    # -------------------------------------------------------------------------
    # CHAPTER 4: PROPOSED SYSTEM
    # -------------------------------------------------------------------------
    add_h1("4. Proposed System — FitFi")

    add_body_p(
        "FitFi is engineered as a robust, layered mobile software application built using Dart and the Flutter framework. "
        "The architecture enforces clean separation between user interface components, domain business logic services, "
        "underlying sensor APIs, and local data persistence."
    )

    add_h2("4.1 System Architecture")
    add_body_p(
        "The architectural structure of FitFi is organized into five primary logical tiers:\n"
        "1. Presentation Tier (UI & Widgets): Implemented via Flutter stateful widgets and custom rendering canvases. "
        "High-performance visualization is achieved using CustomPainter for real-time skeletal overlays (_RealPosePainter), "
        "continuous ECG heartbeat waveforms (_EcgPainter), animated sinusoidal liquid waves (_WavePainter), and cubic Bezier "
        "trend curves (_TrendChartPainter).\n"
        "2. Service Tier (Business & Sensor Logic): Comprises dedicated singleton services encapsulating complex processing: "
        "PoseDetectionService, RepCounterService, HeartRateService, StepCounterService, WaterStorageService, HomeWorkoutService, "
        "XPService, ProgressService, NotificationService, and SchedulingService.\n"
        "3. Data Tier: Contains static, indexed data files housing 256 categorized exercises, structured multi-week gym programs, "
        "UFC combat regimes, challenge matrices, and nutritional meal templates.\n"
        "4. Storage Tier: Employs local key-value persistence via SharedPreferences to store historical workout logs, sensor "
        "baselines, user XP, language preferences, and hydration timestamps without cloud dependence.\n"
        "5. Performance & Hardware Abstraction Tier: Integrates DeviceProfiler, MemoryManager, and AnimationManager to profile "
        "hardware capability and dynamically scale image caching and animation complexity on constrained hardware."
    )

    add_body_p(
        "[System Architecture Flow: Camera / Sensors -> Hardware Services (ML Kit / PPG / Accelerometer) -> "
        "Biomechanical State Engines -> Reactive Notifiers -> Custom Painted Presentation Screens -> Local Storage]"
    )

    add_h2("4.2 Modules of the Project")

    # Module 1
    add_body_p(
        "Module 1: AI Exercise Detection and Form Analysis\n"
        "Primary Source Files: lib/screens/ai_activity_screen.dart, lib/services/pose_detection_service.dart, "
        "lib/services/rep_counter_service.dart\n"
        "Underlying Technologies: google_mlkit_pose_detection, camera, permission_handler\n"
        "Technical Operation: The live camera image stream (NV21 format on Android) is ingested by PoseDetectionService, "
        "which invokes Google ML Kit's PoseDetector in streaming mode to resolve 33 spatial landmarks per frame. "
        "The landmark coordinates are transmitted to RepCounterService, which computes joint angles via the atan2 trigonometric "
        "relation across specified vectors. For example, during Push-ups, the angle formed by the shoulder, elbow, and wrist is "
        "tracked. A state machine registers a 'Down' transition when the elbow flexion falls below 90 degrees, and an 'Up' "
        "transition when the angle extends past 150 degrees, incrementing the repetition counter. For Squats, the hip-knee-ankle "
        "angle is evaluated (down <100 degrees, up >158 degrees). For isometric holds such as Planks, vector alignment between "
        "the shoulder, hip, and ankle is required to remain above 150 degrees to maintain the active timer. Real-time visual "
        "feedback is rendered via _RealPosePainter: green skeletal bones signify correct biomechanics, whereas red segments "
        "indicate improper form, coupled with contextual instructions ('Go lower', 'Push up', 'Keep body straight')."
    )

    # Module 2
    add_body_p(
        "Module 2: Optical Photoplethysmography (PPG) Heart Rate Monitor\n"
        "Primary Source Files: lib/screens/heart_rate_screen.dart, lib/services/heart_rate_service.dart\n"
        "Underlying Technologies: camera (Torch mode + Image Stream)\n"
        "Technical Operation: HeartRateService activates the rear camera LED flashlight in continuous torch mode. When the user "
        "places their fingertip against the lens, the sensor samples frame luminance and red-channel pixel intensities across a "
        "central 50x50 pixel region of interest. Periodic capillary blood volume pulsations alter light absorption. The service "
        "computes a moving average threshold; upward threshold crossings denote systolic peaks. Real-time BPM and signal quality "
        "indices are derived from inter-beat intervals. The user experience is governed by a 3-stage state machine: "
        "(1) Instruction State with biometric guidance, (2) Scanning State featuring an animated circular countdown radar and "
        "audio-style equalizer bars, and (3) Result State presenting BPM, cardiovascular stress estimates, recovery index, and "
        "7-day historical bar charts."
    )

    # Module 3
    add_body_p(
        "Module 3: Accelerometer-Based Step Counter\n"
        "Primary Source Files: lib/screens/step_counter_screen.dart, lib/services/step_counter_service.dart\n"
        "Underlying Technologies: sensors_plus, shared_preferences, percent_indicator\n"
        "Technical Operation: StepCounterService subscribes to the userAccelerometerEventStream, sampling linear triaxial "
        "acceleration (x, y, z). It evaluates dynamic vector magnitude sqrt(x^2 + y^2 + z^2). A step event is recorded when the "
        "magnitude breaches a 12.0 m/s2 threshold, governed by a 300ms debounce filter to eliminate spurious vibrational noise. "
        "Distance is estimated using biometric stride approximations, and metabolic caloric burn is calculated. The screen "
        "renders a circular progress arc against the 10,000 daily step benchmark, weekly and monthly toggleable analytics, "
        "cubic Bezier trend graphs, and historical achievement badges."
    )

    # Module 4
    add_body_p(
        "Module 4: Hydration Tracking and Notification System\n"
        "Primary Source Files: lib/screens/water_tracker_screen.dart, lib/services/water_storage_service.dart, "
        "lib/services/notification_service.dart\n"
        "Underlying Technologies: flutter_local_notifications, timezone, shared_preferences\n"
        "Technical Operation: Facilitates precision water intake logging with pre-calibrated vessel selectors (Cup: 150ml, "
        "Glass: 250ml, Bottle: 500ml). Water level is visualized using a custom sinusoidal wave painter (_WavePainter) "
        "animating fill depth relative to the customizable daily goal. Integrates with NotificationService to schedule exact "
        "local hydration notifications at 2-hour intervals between 8:00 AM and 8:00 PM, fully compliant with Android 13+ "
        "exact alarm permissions."
    )

    # Module 5
    add_body_p(
        "Module 5: Gym Workout System and Progressive Overload Engine\n"
        "Primary Source Files: lib/screens/gym/ (15+ files), lib/services/home_workout_service.dart, "
        "lib/screens/workout_player_screen.dart\n"
        "Underlying Technologies: lottie, flutter\n"
        "Technical Operation: Features an 8-stage personalized onboarding questionnaire gathering gender, BMI, body focus areas "
        "(interactive anatomical silhouette), activity rating, and goals. Houses a 256-exercise library equipped with Lottie "
        "and GIF animations. Delivers a 5-phase structured workout runner: Breathing (20s) -> Preview (20s) -> Perform (30s) -> "
        "Recovery (20s) -> Next Preview (20s). The HomeWorkoutService computes algorithmic progressive overload across 1 to 12-week "
        "cycles, increasing target repetitions by up to 30% and tapering rest durations by up to 10 seconds."
    )

    # Module 6
    add_body_p(
        "Module 6: UFC Combat Conditioning Module\n"
        "Primary Source Files: lib/screens/ufc/ufc_screen.dart, lib/screens/ufc/ufc_course_detail_screen.dart\n"
        "Technical Operation: Offers specialized combat conditioning organized into two distinct schools: Dagestani Style "
        "(Khabib Nurmagomedov inspired, emphasizing grappling endurance, isometric core power, and wrestling cardio) and "
        "Irish Style (Conor McGregor inspired, concentrating on striking speed, kickboxing fluidity, and rotational power). "
        "Each program spans 6 active training days and 1 rest day, converting into structured playlists executed via the WorkoutPlayer."
    )

    # Module 7
    add_body_p(
        "Module 7: Gamified Challenge Framework and XP Progression Engine\n"
        "Primary Source Files: lib/screens/challenge/challenge_screen.dart, lib/services/xp_service.dart, "
        "lib/screens/session_summary_screen.dart\n"
        "Technical Operation: Provides 6 ranked tiers: Level 10 (Junior Trainee), Level 20 (Senior Trainee), Level 30 (Gym Bro), "
        "Level 50 (Beast Mode), Level 60 (Apex Predator), and Level 100 (UFC Fighter), supplemented by 15 standalone quick challenges. "
        "The XPService incorporates a Solo Leveling-inspired progression model comprising 10 experience thresholds (100 to 100,000 XP) "
        "and 11 rank designations (Unranked through X Rank) across dual Gym and Challenge tracks, awarding post-workout XP and "
        "triggering celebration modals."
    )

    # Module 8
    add_body_p(
        "Module 8: Nutritional Guidance and Growth Analytics Dashboard\n"
        "Primary Source Files: lib/screens/gym/diet_plan_screen.dart, lib/screens/account/account_screen.dart\n"
        "Technical Operation: Delivers tailored dietary meal templates (Lose Weight, Build Muscle, Keep Fit) with macronutrient "
        "guidance. The Growth Analytics dashboard synthesizes real-time metrics across all modules into a centralized hub, displaying "
        "cumulative steps, water intake, average BPM, daily AI rep totals, unlocked rank tiers, and overall workout volume."
    )

    # Module 9
    add_body_p(
        "Module 9: Localization and Performance Optimization Infrastructure\n"
        "Primary Source Files: lib/services/performance/, lib/screens/settings/language_settings_screen.dart\n"
        "Technical Operation: Provides runtime language switching between English and Hindi with SharedPreferences persistence. "
        "The performance subsystem incorporates DeviceProfiler to determine device hardware tiers, MemoryManager to regulate "
        "Flutter image cache quotas, and AnimationManager to disable heavy shaders on low-memory handsets."
    )

    add_h2("4.3 Technologies and Tools Used")

    tech_specs = [
        ("Component", "Technology / Framework", "Role in FitFi Architecture"),
        ("Language", "Dart SDK (v3.11.3+)", "Core object-oriented programming language"),
        ("Framework", "Flutter SDK", "Cross-platform high-performance UI rendering"),
        ("Computer Vision", "google_mlkit_pose_detection", "On-device 33-point body landmark inference"),
        ("Camera Subsystem", "camera (^0.12.0+1)", "Live preview feed for pose detection and optical PPG"),
        ("Motion Sensing", "sensors_plus (^7.0.0)", "Triaxial accelerometer sampling for pedometer"),
        ("Local Persistence", "shared_preferences (^2.5.4)", "On-device key-value storage for offline data"),
        ("Alarm / Scheduling", "flutter_local_notifications, timezone", "Exact periodic notifications for hydration and workouts"),
        ("Vector Animation", "lottie (^3.3.2)", "JSON-based After Effects animation rendering"),
        ("UI Indicators", "percent_indicator (^4.2.3)", "Circular and linear animated progress elements"),
        ("Calendar View", "table_calendar (^3.1.2)", "Interactive calendar for workout streak logging"),
        ("Typography", "google_fonts (^6.2.1)", "Stylized typography (Outfit, Poppins)"),
        ("Permissions", "permission_handler (^11.3.0)", "Runtime camera, sensor, and notification permission flow"),
        ("Development IDE", "Android Studio / VS Code", "Application engineering, compilation, and profiling"),
        ("Version Control", "Git / GitHub", "Source code management and version control"),
    ]

    add_centered("Table 4.1: Technical Stack and Library Dependencies", 11, True, 4)

    tech_table = doc.add_table(rows=len(tech_specs), cols=3)
    tech_table.style = 'Table Grid'
    tech_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    for r_idx, row in enumerate(tech_specs):
        for c_idx, val in enumerate(row):
            cell = tech_table.cell(r_idx, c_idx)
            cell.width = Inches(1.5 if c_idx == 0 else (2.2 if c_idx == 1 else 2.7))
            p = cell.paragraphs[0]
            p.paragraph_format.line_spacing = 1.15
            p.paragraph_format.space_after = Pt(2)
            run = p.add_run(val)
            run.font.name = 'Times New Roman'
            run.font.size = Pt(10)
            if r_idx == 0:
                run.bold = True
                set_cell_shading(cell, "D9E1F2")

    add_h2("4.4 System Requirements")
    add_body_p(
        "Hardware Requirements:\n"
        "• Smartphone: Android device equipped with functional front and rear cameras\n"
        "• Optical Sensor: Rear camera paired with functional LED flashlight (torch mode capability for PPG)\n"
        "• Motion Sensor: Built-in triaxial hardware accelerometer\n"
        "• Memory (RAM): Minimum 2.0 GB (4.0 GB recommended for optimal 30 FPS pose detection)\n"
        "• Storage: Minimum 200 MB available internal memory"
    )
    add_body_p(
        "Software Requirements:\n"
        "• Target Operating System: Android 5.0 (Lollipop, API Level 21) or higher\n"
        "• Compilation Toolchain: Flutter SDK v3.11.3 or higher, Dart SDK\n"
        "• Network Connectivity: None required (100% offline operational capability)"
    )

    doc.add_page_break()

    # -------------------------------------------------------------------------
    # CHAPTER 5: EXPECTED OUTCOMES AND INNOVATION
    # -------------------------------------------------------------------------
    add_h1("5. Expected Outcomes and Innovation")

    add_h2("5.1 Expected Outcomes")
    add_body_p(
        "The deployment and evaluation of FitFi yield the following concrete outcomes:\n"
        "1. Complete Unified Health Suite: A fully functional mobile application providing a consolidated dashboard that "
        "eliminates the necessity of switching between disparate single-purpose fitness applications.\n"
        "2. Validated Real-Time AI Exercise Feedback: Interactive on-device pose estimation capable of auto-counting repetitions "
        "and evaluating form accuracy across 11 major exercises at interactive frame rates without cloud latency.\n"
        "3. Zero-Cost Biometric Heart Rate Monitoring: Reliable optical PPG pulse estimation using existing smartphone camera "
        "hardware, democratizing cardiovascular tracking without requiring wearable accessories.\n"
        "4. Precise Sensor Pedometer: Robust step tracking with vector thresholding and debounce filtering, yielding accurate daily "
        "distance and calorie expenditure curves.\n"
        "5. Comprehensive 256-Exercise Library: Fully mapped exercise catalog with animated execution guides across gym, calisthenics, "
        "and combat disciplines.\n"
        "6. Measurable Motivational Engagement: A validated XP and ranking gamification system that incentivizes long-term "
        "consistency through progressive rewards."
    )

    add_h2("5.2 Innovation and Novelty")
    add_body_p(
        "FitFi introduces several distinct technical innovations in consumer mobile fitness applications:\n"
        "1. Edge-Computed Biomechanical Pose State Machine: Unlike conventional apps that merely stream pre-recorded workout "
        "clips, FitFi executes live geometric angle calculations on-device, establishing real-time feedback loops that assist "
        "in preventing exercise-induced injury.\n"
        "2. Holistic Sensor-Vision Synthesis: Synthesizes camera optical PPG, accelerometer dynamics, and neural pose detection "
        "into a single coordinated application framework.\n"
        "3. Solo Leveling Gamification Paradigm: Adapts multi-tiered leveling mechanics directly into physical conditioning, "
        "transforming routine workout sessions into goal-oriented progression quests.\n"
        "4. UFC Combat Disciplines Integration: Integrates authentic Dagestani grappling conditioning and Irish striking drills "
        "directly alongside conventional gym routines.\n"
        "5. Dynamic Device-Adaptive Performance Profiling: Automatically profiles host hardware capabilities to adjust memory "
        "footprints and shader workloads, ensuring consistent 60 FPS UI transitions even on entry-tier devices.\n"
        "6. Absolute Offline Privacy: Enforces zero-cloud reliance, guaranteeing that sensitive biometric data, video feeds, and "
        "health logs never leave the user's personal hardware."
    )

    doc.add_page_break()

    # -------------------------------------------------------------------------
    # CHAPTER 6: WORK PLAN AND TIMELINE
    # -------------------------------------------------------------------------
    add_h1("6. Work Plan and Timeline")

    add_body_p(
        "The project execution follows a disciplined 4-month development schedule divided into requirements analysis, "
        "architectural setup, core module engineering, AI and sensor integration, testing, and documentation as shown in Table 6.1."
    )

    add_centered("Table 6.1: Project Work Plan and Timeline", 11, True, 4)

    timeline_data = [
        ("Activity / Milestone", "Month 1", "Month 2", "Month 3", "Month 4", "Status"),
        ("Problem Formulation & Requirements Gathering", "[X]", "", "", "", "Completed"),
        ("UI/UX Design Mockups & Design System (Figma)", "[X]", "", "", "", "Completed"),
        ("Project Architecture & Base Scaffolding Setup", "[X]", "", "", "", "Completed"),
        ("Step Counter & Accelerometer Integration", "", "[X]", "", "", "Completed"),
        ("Water Tracker & Scheduled Notifications", "", "[X]", "", "", "Completed"),
        ("Optical PPG Heart Rate Scanner Development", "", "[X]", "", "", "Completed"),
        ("Google ML Kit Pose Detection & Rep Counter", "", "[X]", "[X]", "", "Completed"),
        ("Gym Course Modules & 5-Phase Workout Player", "", "", "[X]", "", "Completed"),
        ("UFC Combat Programs & Challenge XP System", "", "", "[X]", "", "Completed"),
        ("Diet Plan, Growth Dashboard & Localization", "", "", "[X]", "", "Completed"),
        ("Performance Profiling & Multi-Device Testing", "", "", "", "[X]", "Completed"),
        ("Comprehensive Documentation & Final Presentation", "", "", "", "[X]", "In Progress"),
    ]

    timeline_tbl = doc.add_table(rows=len(timeline_data), cols=6)
    timeline_tbl.style = 'Table Grid'
    timeline_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    for r_idx, row in enumerate(timeline_data):
        for c_idx, val in enumerate(row):
            cell = timeline_tbl.cell(r_idx, c_idx)
            cell.width = Inches(2.6 if c_idx == 0 else (0.75 if c_idx < 5 else 1.1))
            p = cell.paragraphs[0]
            p.alignment = WD_ALIGN_PARAGRAPH.CENTER if c_idx > 0 else WD_ALIGN_PARAGRAPH.LEFT
            p.paragraph_format.line_spacing = 1.15
            p.paragraph_format.space_after = Pt(2)
            run = p.add_run(val)
            run.font.name = 'Times New Roman'
            run.font.size = Pt(9.5)
            if r_idx == 0:
                run.bold = True
                set_cell_shading(cell, "D9E1F2")
            elif val == "Completed":
                set_cell_shading(cell, "E2EFDA")
            elif val == "In Progress":
                set_cell_shading(cell, "FFF2CC")
            elif val == "[X]":
                run.bold = True
                set_cell_shading(cell, "DDEBF7")

    doc.add_page_break()

    # -------------------------------------------------------------------------
    # CHAPTER 7: CONCLUSION
    # -------------------------------------------------------------------------
    add_h1("7. Conclusion")

    add_body_p(
        "The FitFi project successfully realizes a comprehensive, production-ready, AI-driven mobile fitness coach built upon "
        "the Flutter cross-platform ecosystem. By unifying computer vision exercise tracking, camera-based Photoplethysmography "
        "heart rate sensing, accelerometer-driven step counting, hydration management, structured gym curriculums, UFC combat "
        "modules, and immersive XP gamification, the application solves the persistent challenge of fitness app fragmentation."
    )
    add_body_p(
        "All formulated project objectives have been rigorously accomplished. The on-device integration of Google ML Kit Pose "
        "Detection and custom trigonometric angle state machines enables real-time repetition counting and postural validation "
        "across eleven exercise variations with zero network latency. The optical PPG module extracts physiological pulse waveforms "
        "using standard smartphone cameras, making cardiovascular tracking broadly accessible without specialized wearables."
    )
    add_body_p(
        "Furthermore, the modular architecture guarantees clean maintainability and forward scalability. Offline Python machine "
        "learning pipelines for convolutional body type classification (MobileNetV2), caloric adjustment regression, and progressive "
        "overload prediction have already been established and stand prepared for future on-device TensorFlow Lite deployment. "
        "FitFi provides a solid foundation for the next generation of intelligent, privacy-first mobile fitness solutions."
    )

    doc.add_page_break()

    # -------------------------------------------------------------------------
    # REFERENCES (IEEE FORMAT)
    # -------------------------------------------------------------------------
    add_h1("8. References")

    references = [
        "[1] Google, \"ML Kit Pose Detection API Overview,\" Google Developers, 2023. [Online]. "
        "Available: https://developers.google.com/ml-kit/vision/pose-detection. [Accessed: Sept. 2026].",

        "[2] Google, \"Flutter: Build Apps for Any Screen,\" Flutter Documentation, 2024. [Online]. "
        "Available: https://flutter.dev/docs. [Accessed: Sept. 2026].",

        "[3] J. Allen, \"Photoplethysmography and its application in clinical physiological measurement,\" "
        "Physiological Measurement, vol. 28, no. 3, pp. R1–R39, 2007. doi: 10.1088/0967-3334/28/3/R01.",

        "[4] Flutter Community, \"sensors_plus: Flutter Plugin for Accessing Accelerometer and Gyroscope Sensors,\" "
        "pub.dev, 2024. [Online]. Available: https://pub.dev/packages/sensors_plus. [Accessed: Sept. 2026].",

        "[5] Flutter Community, \"camera: Flutter Plugin for Controlling Device Cameras,\" "
        "pub.dev, 2024. [Online]. Available: https://pub.dev/packages/camera. [Accessed: Sept. 2026].",

        "[6] Google, \"google_mlkit_pose_detection: On-Device Pose Landmark Detection Plugin for Flutter,\" "
        "pub.dev, 2024. [Online]. Available: https://pub.dev/packages/google_mlkit_pose_detection. [Accessed: Sept. 2026].",

        "[7] Airbnb, \"Lottie for Flutter: Native After Effects Animation Vector Engine,\" "
        "pub.dev, 2024. [Online]. Available: https://pub.dev/packages/lottie. [Accessed: Sept. 2026].",

        "[8] Flutter Community, \"flutter_local_notifications: Cross-Platform Periodic Notification Plugin,\" "
        "pub.dev, 2024. [Online]. Available: https://pub.dev/packages/flutter_local_notifications. [Accessed: Sept. 2026].",

        "[9] M. Stumpp, \"percent_indicator: Circular and Linear Progress Indicator Library for Flutter,\" "
        "pub.dev, 2023. [Online]. Available: https://pub.dev/packages/percent_indicator. [Accessed: Sept. 2026].",

        "[10] A. Borysov, \"table_calendar: Highly Customizable Feature-Packed Calendar Package for Flutter,\" "
        "pub.dev, 2024. [Online]. Available: https://pub.dev/packages/table_calendar. [Accessed: Sept. 2026].",
    ]

    for ref_str in references:
        p = doc.add_paragraph(style='Normal')
        p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
        p.paragraph_format.line_spacing = 1.15
        p.paragraph_format.space_after = Pt(6)
        run = p.add_run(ref_str)
        run.font.name = 'Times New Roman'
        run.font.size = Pt(10.5)

    doc.save(output_filepath)
    print(f"Successfully generated official synopsis: {output_filepath}")

if __name__ == '__main__':
    out_file = 'c:/Users/nsraw/StudioProjects/dhfif/synopsisAndPresentation/FitFi_Synopsis_Official.docx'
    create_official_synopsis(out_file)
    try:
        create_official_synopsis('c:/Users/nsraw/StudioProjects/dhfif/synopsisAndPresentation/FitFi_Synopsis.docx')
        print("Updated FitFi_Synopsis.docx as well!")
    except Exception as e:
        print(f"Could not overwrite FitFi_Synopsis.docx: {e}")
