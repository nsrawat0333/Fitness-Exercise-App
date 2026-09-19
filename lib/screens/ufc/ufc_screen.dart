import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../data/ufc_data.dart';
import '../../models/ufc_model.dart';
import 'ufc_course_detail_screen.dart';

/// UFC course → image asset mapping
const _ufcCourseImages = {
  'Wrestling Fundamentals': 'assets/sections/ufc/ufc_wrestling.jpg',
  'Grappling Mastery': 'assets/sections/ufc/ufc_grappling.jpg',
  'Pressure Training': 'assets/sections/ufc/ufc_pressure.jpg',
  'Cardio Beast Mode': 'assets/sections/ufc/ufc_cardio.jpg',
  'Defensive Fighting': 'assets/sections/ufc/ufc_defensive.jpg',
  'Kickboxing Fundamentals': 'assets/sections/ufc/ufc_kickboxing.jpg',
  'Striking Precision': 'assets/sections/ufc/ufc_precision.jpg',
  'Power & Explosiveness': 'assets/sections/ufc/ufc_power.jpg',
  'Fight IQ & Movement': 'assets/sections/ufc/ufc_fightiq.jpg.jpg',
  'Defensive Striking': 'assets/sections/ufc/ufc_defense_striking.jpg.jpg',
  'Cardio & Fight Conditioning': 'assets/sections/ufc/ufc_fight_cardio.jpg.jpg',
  'Bone Strength & Power Striking': 'assets/sections/ufc/ufc_bone_strength.jpg.jpg',
  'Dodge & Speed Reflex': 'assets/sections/ufc/ufc_dodge_reflex.jpg.jpg',
};

/// Main UFC tab — Dagestani vs Irish selection + course lists
class UFCScreen extends StatefulWidget {
  const UFCScreen({super.key});

  @override
  State<UFCScreen> createState() => _UFCScreenState();
}

class _UFCScreenState extends State<UFCScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sageBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
              child: Text(
                'UFC TRAINING',
                style: AppTextStyles.sageTitle.copyWith(fontSize: 28),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Choose your fighting style',
                style: AppTextStyles.sageSubtitle.copyWith(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            // Style tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.sageGreen,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.sageTextMuted,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                tabs: const [
                  Tab(text: 'DAGESTANI'),
                  Tab(text: 'IRISH'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Course lists
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _CourseList(
                    courses: UFCData.getDagestaniCourses(),
                    accentColor: AppColors.sageGreen,
                    bannerImage: 'assets/sections/ufc/ufc_dagestani_banner.jpg',
                    bannerTitle: 'KHABIB STYLE',
                  ),
                  _CourseList(
                    courses: UFCData.getIrishCourses(),
                    accentColor: AppColors.sageGreen,
                    bannerImage: 'assets/sections/ufc/ufc_irish_banner.jpg',
                    bannerTitle: 'McGREGOR STYLE',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseList extends StatelessWidget {
  final List<UFCCourse> courses;
  final Color accentColor;
  final String bannerImage;
  final String bannerTitle;

  const _CourseList({
    required this.courses,
    required this.accentColor,
    required this.bannerImage,
    required this.bannerTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: courses.length + 1, // +1 for banner
      itemBuilder: (context, index) {
        // Banner at index 0
        if (index == 0) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 140,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  bannerImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: AppColors.sageGreenLight,
                    child: Center(child: Icon(Icons.sports_mma, color: accentColor, size: 48)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16, left: 16,
                  child: Text(
                    bannerTitle,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                ),
              ],
            ),
          );
        }

        final course = courses[index - 1];
        final courseImage = _ufcCourseImages[course.name];

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UFCCourseDetailScreen(course: course)),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 90,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Image section instead of background
                SizedBox(
                  width: 90,
                  height: 90,
                  // Clip manually left rounded
                  child: courseImage != null
                      ? Image.asset(courseImage, fit: BoxFit.cover, errorBuilder: (_,_,_)=>Container(color: AppColors.sageGreenLight))
                      : Container(color: AppColors.sageGreenLight),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        course.name,
                        style: AppTextStyles.sageTitle.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _InfoChip(text: course.level, color: AppColors.sageGreen, bgColor: AppColors.sageGreenLight),
                          const SizedBox(width: 6),
                          _InfoChip(text: '${course.days.length} Days', color: AppColors.sageTextMuted, bgColor: AppColors.sageBg),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: AppColors.sageGreenLight, size: 16),
                const SizedBox(width: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String text;
  final Color color;
  final Color bgColor;
  const _InfoChip({required this.text, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700)),
    );
  }
}
