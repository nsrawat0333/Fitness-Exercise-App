import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> with SingleTickerProviderStateMixin {
  static const _bg = Color(0xFFF9F7F3);
  static const _cardBg = Color(0xFFFFFFFF);
  static const _accent = Color(0xFF5B7E5F);
  static const _textDark = Color(0xFF1A1A1A);
  static const _textMuted = Color(0xFF8D8D8D);

  late TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.arrow_back, color: _textDark, size: 22),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Logo
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _accent,
                    boxShadow: [BoxShadow(color: _accent.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: const Icon(Icons.fitness_center, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 20),
                Text('Welcome to FitApp', style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w900, color: _textDark)),
                const SizedBox(height: 6),
                Text('Track your fitness journey', style: GoogleFonts.inter(fontSize: 14, color: _textMuted)),
                const SizedBox(height: 32),

                // Tabs
                Container(
                  decoration: BoxDecoration(color: const Color(0xFFF0EBE3), borderRadius: BorderRadius.circular(16)),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(color: _accent, borderRadius: BorderRadius.circular(14)),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: _textMuted,
                    labelStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700),
                    dividerHeight: 0,
                    tabs: const [Tab(text: 'Login'), Tab(text: 'Register')],
                    onTap: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(height: 28),

                // Form
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _tabController.index == 0 ? _buildLoginForm() : _buildRegisterForm(),
                ),
                const SizedBox(height: 16),

                // Action button
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _tabController.index == 0 ? 'Login coming soon with Firebase!' : 'Register coming soon with Firebase!',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: _accent,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity, height: 56,
                    decoration: BoxDecoration(
                      color: _accent,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: _accent.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8))],
                    ),
                    child: Center(
                      child: Text(
                        _tabController.index == 0 ? 'Login' : 'Create Account',
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Divider
                Row(children: [
                  Expanded(child: Divider(color: Colors.black.withValues(alpha: 0.08))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('or continue with', style: GoogleFonts.inter(fontSize: 12, color: _textMuted)),
                  ),
                  Expanded(child: Divider(color: Colors.black.withValues(alpha: 0.08))),
                ]),
                const SizedBox(height: 20),

                // Social
                Row(children: [
                  Expanded(child: _SocialButton(icon: Icons.g_mobiledata, label: 'Google', onTap: () {})),
                  const SizedBox(width: 12),
                  Expanded(child: _SocialButton(icon: Icons.apple, label: 'Apple', onTap: () {})),
                ]),
                const SizedBox(height: 24),

                // Skip
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text('Skip for now', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _textMuted, decoration: TextDecoration.underline, decorationColor: _textMuted)),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(key: const ValueKey('login'), children: [
      _buildTextField(controller: _emailController, hint: 'Email', icon: Icons.email_outlined),
      const SizedBox(height: 14),
      _buildTextField(controller: _passwordController, hint: 'Password', icon: Icons.lock_outline, isPassword: true),
      const SizedBox(height: 10),
      Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(onTap: () {}, child: Text('Forgot Password?', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: _accent))),
      ),
    ]);
  }

  Widget _buildRegisterForm() {
    return Column(key: const ValueKey('register'), children: [
      _buildTextField(controller: _nameController, hint: 'Full Name', icon: Icons.person_outline),
      const SizedBox(height: 14),
      _buildTextField(controller: _emailController, hint: 'Email', icon: Icons.email_outlined),
      const SizedBox(height: 14),
      _buildTextField(controller: _passwordController, hint: 'Password', icon: Icons.lock_outline, isPassword: true),
    ]);
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && _obscurePassword,
        style: GoogleFonts.inter(color: _textDark, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: _textMuted, size: 20),
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                  child: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: _textMuted, size: 20),
                )
              : null,
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: const Color(0xFFB0B0B0), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF1A1A1A), size: 22),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A))),
          ],
        ),
      ),
    );
  }
}
