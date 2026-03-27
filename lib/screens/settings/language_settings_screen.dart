import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';

/// Language settings screen with a clean toggle UI.
class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F0EB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          loc.tr('select_language'),
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.tr('language'),
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ...LocaleProvider.supportedLanguages.map((lang) {
              final isSelected = currentLocale.languageCode == lang['code'];
              return _buildLanguageTile(
                context,
                flag: lang['flag']!,
                name: lang['name']!,
                code: lang['code']!,
                isSelected: isSelected,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context, {
    required String flag,
    required String name,
    required String code,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        // Find LocaleProvider from the widget tree
        final provider = context
            .findAncestorStateOfType<_LocaleProviderFinderState>()
            ?.provider;
        if (provider != null) {
          provider.setLocale(Locale(code));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2D6A4F).withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2D6A4F)
                : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF2D6A4F)
                      : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: Color(0xFF2D6A4F), size: 24),
          ],
        ),
      ),
    );
  }
}

/// Helper: wrap your MaterialApp to provide LocaleProvider access.
/// Place this widget as a parent in your widget tree.
class LocaleProviderFinder extends StatefulWidget {
  final LocaleProvider provider;
  final Widget child;

  const LocaleProviderFinder({
    super.key,
    required this.provider,
    required this.child,
  });

  @override
  State<LocaleProviderFinder> createState() => _LocaleProviderFinderState();
}

class _LocaleProviderFinderState extends State<LocaleProviderFinder> {
  LocaleProvider get provider => widget.provider;

  @override
  Widget build(BuildContext context) => widget.child;
}
