import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  static const _bg = Color(0xFFF9F7F3);
  static const _cardBg = Color(0xFFFFFFFF);
  static const _accent = Color(0xFF5B7E5F);
  static const _textDark = Color(0xFF1A1A1A);
  static const _textMuted = Color(0xFF8D8D8D);

  late TabController _tabController;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String? currentUserFamilyId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchCurrentUserFamilyId();
  }

  Future<void> _fetchCurrentUserFamilyId() async {
    if (currentUser != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
      if (doc.exists && mounted) {
        setState(() {
          currentUserFamilyId = doc.data()?['familyId'];
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                decoration: BoxDecoration(color: const Color(0xFFF0EBE3), borderRadius: BorderRadius.circular(16)),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(color: _accent, borderRadius: BorderRadius.circular(14)),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: _textMuted,
                  labelStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700),
                  dividerHeight: 0,
                  tabs: const [Tab(text: 'Global'), Tab(text: 'Family')],
                ),
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLeaderboardList(isGlobal: true),
                  _buildLeaderboardList(isGlobal: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardList({required bool isGlobal}) {
    if (!isGlobal && currentUserFamilyId == null) {
      return Center(
        child: Text("You haven't joined a Family yet.", style: GoogleFonts.inter(color: _textMuted)),
      );
    }

    Query query = FirebaseFirestore.instance.collection('users').orderBy('points', descending: true).limit(50);
    if (!isGlobal) {
      query = FirebaseFirestore.instance.collection('users').where('familyId', isEqualTo: currentUserFamilyId).orderBy('points', descending: true);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: _accent));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No users found."));
        }

        final users = snapshot.data!.docs;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, -2))],
          ),
          child: Column(
            children: [
              if (users.length >= 3)
                _buildPodium(users.take(3).toList()),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final userData = users[index].data() as Map<String, dynamic>;
                    final isYou = users[index].id == currentUser?.uid;
                    return _buildLeaderboardTile(userData, index + 1, isYou);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeaderboardTile(Map<String, dynamic> userData, int rank, bool isYou) {
    Color rankColor = _textMuted;
    if (rank == 1) rankColor = const Color(0xFFFFD700);
    if (rank == 2) rankColor = const Color(0xFFC0C0C0);
    if (rank == 3) rankColor = const Color(0xFFCD7F32);

    String name = userData['name'] ?? 'Unknown';
    if (isYou) name += " (You)";

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
            child: Center(child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'U', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: isYou ? Colors.white : _textDark))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(name, style: GoogleFonts.outfit(fontSize: 15, fontWeight: isYou ? FontWeight.w800 : FontWeight.w600, color: isYou ? _accent : _textDark), overflow: TextOverflow.ellipsis),
          ),
          Text('${userData['points'] ?? 0} XP', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: isYou ? _accent : _textMuted)),
        ],
      ),
    );
  }

  Widget _buildPodium(List<QueryDocumentSnapshot> top3) {
    if (top3.length < 3) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: SizedBox(
        height: 180,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: _PodiumSpot(userData: top3[1].data() as Map<String, dynamic>, rank: 2, height: 120)),
            const SizedBox(width: 8),
            Expanded(child: _PodiumSpot(userData: top3[0].data() as Map<String, dynamic>, rank: 1, height: 160)),
            const SizedBox(width: 8),
            Expanded(child: _PodiumSpot(userData: top3[2].data() as Map<String, dynamic>, rank: 3, height: 100)),
          ],
        ),
      ),
    );
  }
}

class _PodiumSpot extends StatelessWidget {
  final Map<String, dynamic> userData;
  final int rank;
  final double height;

  const _PodiumSpot({required this.userData, required this.rank, required this.height});

  Color get _rankColor {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    return const Color(0xFFCD7F32);
  }

  @override
  Widget build(BuildContext context) {
    String name = userData['name'] ?? 'Unknown';

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
          child: Center(child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'U', style: GoogleFonts.outfit(fontSize: rank == 1 ? 22 : 18, fontWeight: FontWeight.w800, color: Colors.white))),
        ),
        const SizedBox(height: 8),
        Text(name, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A1A)), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
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
              Text('${userData['points'] ?? 0} XP', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF8D8D8D))),
            ],
          ),
        ),
      ],
    );
  }
}

