import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'leaderboard_screen.dart';
import 'login_register_screen.dart';
import '../heart_rate_screen.dart';
import '../water_tracker_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/family_service.dart';
import 'package:flutter/services.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with TickerProviderStateMixin {
  late AnimationController _pointsAnimController;
  late Animation<double> _pointsAnim;

  final FamilyService _familyService = FamilyService();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  
  // App theme colors
  static const _bg = Color(0xFFF9F7F3);
  static const _cardBg = Color(0xFFFFFFFF);
  static const _accent = Color(0xFF5B7E5F);
  static const _accentLight = Color(0xFFD3D8C8);
  static const _textDark = Color(0xFF1A1A1A);
  static const _textMuted = Color(0xFF8D8D8D);

  // Remaining mock data for unimplemented features
  final int _streak = 7;
  final int _totalWorkouts = 86;
  final int _totalMinutes = 2580;
  final int _caloriesBurned = 18400;
  final List<int> _weeklyActivity = [45, 30, 60, 20, 55, 40, 50];

  @override
  void initState() {
    super.initState();
    _pointsAnimController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pointsAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _pointsAnimController, curve: Curves.easeOutCubic),
    );
    _pointsAnimController.forward();
  }

  @override
  void dispose() {
    _pointsAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text("Please Login to view your account.")));
    }
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("Missing User Data."));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final userName = data['name'] ?? 'User';
            final email = data['email'] ?? '';
            final totalPoints = data['points'] ?? 0;
            final level = (totalPoints ~/ 500) + 1; // 500 points per level
            final familyId = data['familyId'];

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 8),
                  _buildProfileHeader(userName, email),
                  const SizedBox(height: 24),
                  _buildPointsAndLevel(totalPoints, level),
                  const SizedBox(height: 24),
                  _buildFamilySection(familyId),
                  const SizedBox(height: 24),
                  _buildStatsCards(),
                  const SizedBox(height: 24),
                  _buildWeeklyImprovement(),
                  const SizedBox(height: 24),
                  _buildDataAnalysis(),
                  const SizedBox(height: 24),
                  _buildLeaderboardPreview(totalPoints, familyId),
                  const SizedBox(height: 24),
                  _buildSettingsSection(),
                  const SizedBox(height: 40),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Text(
            'ACCOUNT',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: _textDark,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginRegisterScreen())),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Login',
                style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String userName, String email) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accent,
              boxShadow: [
                BoxShadow(color: _accent.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6)),
              ],
            ),
            child: Center(
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                style: GoogleFonts.outfit(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800, color: _textDark)),
                const SizedBox(height: 4),
                Text(email, style: GoogleFonts.inter(fontSize: 13, color: _textMuted)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department, color: Color(0xFFFF6B35), size: 14),
                      const SizedBox(width: 4),
                      Text('$_streak Day Streak',
                        style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFFFF6B35)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsAndLevel(int totalPoints, int level) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _pointsAnim,
              builder: (context, child) {
                return SizedBox(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    painter: _ProgressRingPainter(
                      progress: _pointsAnim.value * (totalPoints % 500) / 500,
                      color: _accent,
                      bgColor: _accentLight.withValues(alpha: 0.5),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Lv $level', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w900, color: _textDark)),
                          Text('${(_pointsAnim.value * totalPoints).toInt()}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: _accent)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Points', style: GoogleFonts.inter(fontSize: 12, color: _textMuted)),
                  const SizedBox(height: 4),
                  AnimatedBuilder(
                    animation: _pointsAnim,
                    builder: (context, _) {
                      return Text('${(_pointsAnim.value * totalPoints).toInt()} XP',
                        style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, color: _textDark),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 6,
                    decoration: BoxDecoration(color: _accentLight.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(3)),
                    child: AnimatedBuilder(
                      animation: _pointsAnim,
                      builder: (context, _) {
                        return FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _pointsAnim.value * (totalPoints % 500) / 500,
                          child: Container(
                            decoration: BoxDecoration(color: _accent, borderRadius: BorderRadius.circular(3)),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('${500 - (totalPoints % 500)} XP to Level ${level + 1}', style: GoogleFonts.inter(fontSize: 11, color: _textMuted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilySection(String? familyId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.group, color: _accent, size: 20),
                const SizedBox(width: 8),
                Text('Family System', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: _textDark)),
              ],
            ),
            const SizedBox(height: 16),
            if (familyId != null) ...[
              Text("Your Family Code:", style: GoogleFonts.inter(fontSize: 12, color: _textMuted)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(familyId, style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, color: _accent, letterSpacing: 2)),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20, color: _accent),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: familyId));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied Family Code!')));
                    },
                  )
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  await _familyService.leaveFamily();
                },
                child: const Text('Leave Family', style: TextStyle(color: Colors.red)),
              )
            ] else ...[
              Text("Join or create a family to compete together!", style: GoogleFonts.inter(fontSize: 12, color: _textMuted), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: _accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () => _showJoinFamilyDialog(),
                      child: Text('Join', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _accent.withValues(alpha: 0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        try {
                          await _familyService.createFamily();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                      child: Text('Create', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: _accent)),
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  void _showJoinFamilyDialog() {
    final tc = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text("Join Family"),
      content: TextField(
        controller: tc,
        textCapitalization: TextCapitalization.characters,
        maxLength: 6,
        decoration: const InputDecoration(hintText: "Enter 6-char Family Code"),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () async {
            try {
              await _familyService.joinFamily(tc.text.trim());
              Navigator.pop(ctx);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
            }
          },
          child: const Text("Join"),
        )
      ],
    ));
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _StatCard(icon: Icons.favorite, label: 'Heart Rate', value: '72 bpm', color: const Color(0xFFFF6B8A),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HeartRateScreen())))),
          const SizedBox(width: 12),
          Expanded(child: _StatCard(icon: Icons.water_drop, label: 'Water', value: '6 / 8', color: const Color(0xFF5EC6C6),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WaterTrackerScreen())))),
          const SizedBox(width: 12),
          Expanded(child: _StatCard(icon: Icons.fitness_center, label: 'Workouts', value: '$_totalWorkouts', color: _accent, onTap: () {})),
        ],
      ),
    );
  }

  Widget _buildWeeklyImprovement() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxVal = _weeklyActivity.reduce(max).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: _accent, size: 20),
                const SizedBox(width: 8),
                Text('Weekly Activity', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: _textDark)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: _accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text('+12% vs last week', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: _accent)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 140,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (i) {
                  final ratio = maxVal > 0 ? _weeklyActivity[i] / maxVal : 0.0;
                  final isToday = i == DateTime.now().weekday - 1;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${_weeklyActivity[i]}m', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600, color: _textMuted)),
                          const SizedBox(height: 4),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 600 + i * 100),
                            height: (90 * ratio).clamp(8.0, 90.0),
                            decoration: BoxDecoration(
                              color: isToday ? _accent : _accentLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(days[i], style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                            color: isToday ? _accent : _textMuted,
                          )),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataAnalysis() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: _accent, size: 20),
                const SizedBox(width: 8),
                Text('Your Journey', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: _textDark)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _AnalysisTile(icon: Icons.timer, label: 'Total Minutes', value: '$_totalMinutes', color: const Color(0xFFFFA000))),
                const SizedBox(width: 12),
                Expanded(child: _AnalysisTile(icon: Icons.local_fire_department, label: 'Calories', value: '$_caloriesBurned', color: const Color(0xFFFF5252))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _AnalysisTile(icon: Icons.fitness_center, label: 'Workouts', value: '$_totalWorkouts', color: _accent)),
                const SizedBox(width: 12),
                Expanded(child: _AnalysisTile(icon: Icons.emoji_events, label: 'Best Streak', value: '14 days', color: const Color(0xFFFFD700))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardPreview(int totalPoints, String? familyId) {
    if (familyId == null) {
      return _buildMockGlobalLeaderboard(totalPoints);
    }
    
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where('familyId', isEqualTo: familyId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        final List<Map<String, dynamic>> familyMembers = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'uid': doc.id,
            'name': data['name'] ?? 'User',
            'points': data['points'] ?? 0,
          };
        }).toList();

        // Sort locally by points descending
        familyMembers.sort((a, b) => (b['points'] as int).compareTo(a['points'] as int));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.groups, color: _accent, size: 20),
                    const SizedBox(width: 8),
                    Text('Family Clash', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: _textDark)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFF6B35).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text('Live', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFFF6B35))),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...familyMembers.asMap().entries.take(5).map((entry) {
                  final rank = entry.key + 1;
                  final user = entry.value;
                  final isYou = user['uid'] == currentUser!.uid;
                  
                  Color rankColor = _textMuted;
                  if (rank == 1) rankColor = const Color(0xFFFFD700);
                  if (rank == 2) rankColor = const Color(0xFFC0C0C0);
                  if (rank == 3) rankColor = const Color(0xFFCD7F32);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isYou ? _accent.withValues(alpha: 0.08) : const Color(0xFFF5F0EB),
                      borderRadius: BorderRadius.circular(14),
                      border: isYou ? Border.all(color: _accent.withValues(alpha: 0.3)) : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(color: rankColor.withValues(alpha: 0.15), shape: BoxShape.circle),
                          child: Center(child: Text('#$rank', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w800, color: rankColor))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(user['name'] as String,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(fontSize: 14, fontWeight: isYou ? FontWeight.w800 : FontWeight.w600, color: isYou ? _accent : _textDark))),
                        const SizedBox(width: 8),
                        Text('${user['points']} XP', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: isYou ? _accent : _textMuted)),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildMockGlobalLeaderboard(int totalPoints) {
    final mockLeaderboard = [
      {'name': 'Alex Pro', 'points': 5200, 'rank': 1},
      {'name': 'Sara Fit', 'points': 4800, 'rank': 2},
      {'name': 'Mike Strong', 'points': 4100, 'rank': 3},
      {'name': 'You', 'points': totalPoints, 'rank': 8},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 20),
                const SizedBox(width: 8),
                Text('Global Leaderboard', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: _textDark)),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen())),
                  child: Text('View All →', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, color: _accent)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...mockLeaderboard.map((user) {
              final isYou = user['name'] == 'You';
              final rank = user['rank'] as int;
              Color rankColor = _textMuted;
              if (rank == 1) rankColor = const Color(0xFFFFD700);
              if (rank == 2) rankColor = const Color(0xFFC0C0C0);
              if (rank == 3) rankColor = const Color(0xFFCD7F32);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isYou ? _accent.withValues(alpha: 0.08) : const Color(0xFFF5F0EB),
                  borderRadius: BorderRadius.circular(14),
                  border: isYou ? Border.all(color: _accent.withValues(alpha: 0.3)) : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(color: rankColor.withValues(alpha: 0.15), shape: BoxShape.circle),
                      child: Center(child: Text('#$rank', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w800, color: rankColor))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(user['name'] as String,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(fontSize: 14, fontWeight: isYou ? FontWeight.w800 : FontWeight.w600, color: isYou ? _accent : _textDark))),
                    Text('${user['points']} XP', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: isYou ? _accent : _textMuted)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            _SettingsTile(icon: Icons.person, label: 'Edit Profile', onTap: () {}),
            _SettingsTile(icon: Icons.notifications, label: 'Notifications', onTap: () {}),
            _SettingsTile(icon: Icons.privacy_tip, label: 'Privacy', onTap: () {}),
            _SettingsTile(icon: Icons.help, label: 'Help & Support', onTap: () {}),
            _SettingsTile(icon: Icons.logout, label: 'Logout', onTap: () {
              FirebaseAuth.instance.signOut();
            }, isLast: true),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════
//  Supporting Widgets
// ═══════════════════════════════════════

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({required this.icon, required this.label, required this.value, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(value, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF1A1A1A))),
            const SizedBox(height: 2),
            Text(label, style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF8D8D8D))),
          ],
        ),
      ),
    );
  }
}

class _AnalysisTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _AnalysisTile({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF1A1A1A))),
                Text(label, style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF8D8D8D))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLast;

  const _SettingsTile({required this.icon, required this.label, required this.onTap, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: isLast ? null : Border(bottom: BorderSide(color: Colors.black.withValues(alpha: 0.05))),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF8D8D8D), size: 20),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A)))),
            const Icon(Icons.chevron_right, color: Color(0xFFB0B0B0), size: 20),
          ],
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color bgColor;

  _ProgressRingPainter({required this.progress, required this.color, required this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    canvas.drawCircle(center, radius, Paint()..style = PaintingStyle.stroke..strokeWidth = 6..color = bgColor);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, 2 * pi * progress, false,
      Paint()..style = PaintingStyle.stroke..strokeWidth = 6..strokeCap = StrokeCap.round..color = color);
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter old) => old.progress != progress;
}
