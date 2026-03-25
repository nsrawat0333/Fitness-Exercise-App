import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../constants/app_colors.dart';
import '../../services/body_scan_service.dart';
import 'widgets/ml_result_popup.dart';

class BodyScanProcessingScreen extends StatefulWidget {
  final File? imageFile;
  final BodyScanResult? precalculatedResult;

  const BodyScanProcessingScreen({
    super.key, 
    this.imageFile,
    this.precalculatedResult,
  });

  @override
  State<BodyScanProcessingScreen> createState() => _BodyScanProcessingScreenState();
}

class _BodyScanProcessingScreenState extends State<BodyScanProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  String _currentStatus = 'Analyzing proportions...';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _processImage();
    _cycleStatusMessages();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _cycleStatusMessages() async {
    final messages = [
      'Initializing TFLite Model...',
      'Converting image to Tensor...',
      'Running local inference...',
      'Mapping classification...'
    ];
    for (var msg in messages) {
      if (!mounted) break;
      await Future.delayed(const Duration(milliseconds: 600)); // Super fast local UX
      if (mounted) {
        setState(() => _currentStatus = msg);
      }
    }
  }

  Future<void> _processImage() async {
    try {
      // 1. Minimum UX delay just so the user sees the cool scanning screen
      await Future.delayed(const Duration(milliseconds: 2400)); 
      
      BodyScanResult result;
      if (widget.precalculatedResult != null) {
        // Came from Questionnaire
        result = widget.precalculatedResult!;
      } else if (widget.imageFile != null) {
        // Came from ML Camera/Gallery Scan
        final service = BodyScanService(); // Now uses TFLite internally
        result = await service.analyzeBodyImage(widget.imageFile!);
      } else {
        throw Exception("No image or precalculated result provided.");
      }

      if (mounted) {
        // Stop the pulse
        _pulseController.stop();

        // Show Real-time Popup Instead of routing directly
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => MLResultPopup(
            result: result,
            imageFile: widget.imageFile,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error analyzing image: $e')));
        Navigator.pop(context); // Go back to scanner
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mapDarkBg, // Using dark theme for AI feel
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar / Image preview with scanning effect
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryLight, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryLight.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    )
                  ],
                  image: widget.imageFile != null
                      ? DecorationImage(
                          image: FileImage(widget.imageFile!),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withValues(alpha: 0.3), BlendMode.darken),
                        )
                      : null,
                ),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.mapNeonGreen,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mapNeonGreen,
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ]
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 50),
            
            // Loading text
            Text(
              'AI Engine Processing',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _currentStatus,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            
            // Progress indicator
            const SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: Color(0xFF333333),
                color: AppColors.mapNeonGreen,
                minHeight: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
