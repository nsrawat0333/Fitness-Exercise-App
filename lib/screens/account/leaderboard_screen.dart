import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  static const _bg = Color(0xFFF9F7F3);
  static const _cardBg = Color(0xFFFFFFFF);
  static const _accent = Color(0xFF5B7E5F);
  static const _textDark = Color(0xFF1A1A1A);
  static const _textMuted = Color(0xFF8D8D8D);

  static const List<Map<String, dynamic>> _mockUsers = [
    {'name': 'Alex Pro', 'points': 5200, 'avatar': 'A', 'streak': 21},
    {'name': 'Sara Fit', 'points': 4800, 'avatar': 'S', 'streak': 18},
    {'name': 'Mike Strong', 'points': 4100, 'avatar': 'M', 'streak': 15},
    {'name': 'Emily Run', 'points': 3900, 'avatar': 'E', 'streak': 12},
    {'name': 'Jake Power', 'points': 3600, 'avatar': 'J', 'streak': 10},
    {'name': 'Lisa Yoga', 'points': 3200, 'avatar': 'L', 'streak': 9},
    {'name': 'Dan Lift', 'points': 2900, 'avatar': 'D', 'streak': 7},
    {'name': 'You', 'points': 2750, 'avatar': 'Y', 'streak': 7},
    {'name': 'Chris Core', 'points': 2500, 'avatar': 'C', 'streak': 5},
    {'name': 'Nina Flow', 'points': 2100, 'avatar': 'N', 'streak': 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.arrow_back, color: _textDark, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('LEADERBOARD', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w900, color: _textDark, letterSpacing: 0.5)),
                  const Spacer(),
                  const Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 24),
                ],
              ),
            ),
            _buildPodium(),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, -2))],
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: _mockUsers.length,
                  itemBuilder: (context, index) {
                    final user = _mockUsers[index];
                    final rank = index + 1;
                    final isYou = user['name'] == 'You';

                    Color rankColor = _textMuted;
                    if (rank == 1) rankColor = const Color(0xFFFFD700);
                    if (rank == 2) rankColor = const Color(0xFFC0C0C0);
                    if (rank == 3) rankColor = const Color(0xFFCD7F32);

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: isYou ? _accent.withValues(alpha: 0.08) : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: isYou ? Border.all(color: _accent.withValues(alpha: 0.3)) : null,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32,
                            child: rank <= 3
                                ? Icon(Icons.emoji_events, color: rankColor, size: 22)
                                : Text('#$rank', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w800, color: _textMuted)),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isYou ? _accent : rankColor.withValues(alpha: 0.15),
                            ),
                            child: Center(child: Text(user['avatar'] as String, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: isYou ? Colors.white : _textDark))),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user['name'] as String, style: GoogleFonts.outfit(fontSize: 15, fontWeight: isYou ? FontWeight.w800 : FontWeight.w600, color: isYou ? _accent : _textDark)),
                                const SizedBox(height: 2),
                                Row(children: [
                                  const Icon(Icons.local_fire_department, color: Color(0xFFFF6B35), size: 12),
                                  const SizedBox(width: 3),
                                  Text('${user['streak']} day streak', style: GoogleFonts.inter(fontSize: 11, color: _textMuted)),
                                ]),
                              ],
                            ),
                          ),
                          Text('${user['points']} XP', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: isYou ? _accent : _textMuted)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodium() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 180,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: _PodiumSpot(user: _mockUsers[1], rank: 2, height: 120)),
            const SizedBox(width: 8),
            Expanded(child: _PodiumSpot(user: _mockUsers[0], rank: 1, height: 160)),
            const SizedBox(width: 8),
            Expanded(child: _PodiumSpot(user: _mockUsers[2], rank: 3, height: 100)),
          ],
        ),
      ),
    );
  }
}

class _PodiumSpot extends StatelessWidget {
  final Map<String, dynamic> user;
  final int rank;
  final double height;

  const _PodiumSpot({required this.user, required this.rank, required this.height});

  Color get _rankColor {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    return const Color(0xFFCD7F32);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: rank == 1 ? 56 : 44,
          height: rank == 1 ? 56 : 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _rankColor,
            boxShadow: [BoxShadow(color: _rankColor.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Center(child: Text(user['avatar'] as String, style: GoogleFonts.outfit(fontSize: rank == 1 ? 22 : 18, fontWeight: FontWeight.w800, color: Colors.white))),
        ),
        const SizedBox(height: 8),
        Text(user['name'] as String, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A1A)), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: height * 0.45,
          decoration: BoxDecoration(
            color: _rankColor.withValues(alpha: 0.12),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('#$rank', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, color: _rankColor)),
              Text('${user['points']} XP', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF8D8D8D))),
            ],
          ),
        ),
      ],
    );
  }
}
