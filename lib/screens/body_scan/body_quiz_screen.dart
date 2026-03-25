import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../services/tflite_service.dart'; // To reuse BodyScanResult models
import 'body_scan_processing_screen.dart';

class BodyQuizScreen extends StatefulWidget {
  const BodyQuizScreen({super.key});

  @override
  State<BodyQuizScreen> createState() => _BodyQuizScreenState();
}

class _BodyQuizScreenState extends State<BodyQuizScreen> {
  int _currentQuestionIndex = 0;
  
  // Track answers to calculate majority body type
  int _leanScore = 0;
  int _fitScore = 0;
  int _fatScore = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'How would you describe your natural physical build?',
      'options': [
        {'text': 'Slender or skinny. I have trouble gaining weight.', 'type': BodyType.lean},
        {'text': 'Athletic or muscular. I build muscle easily.', 'type': BodyType.fit},
        {'text': 'Round or heavy. I carry extra body fat easily.', 'type': BodyType.fat},
      ]
    },
    {
      'question': 'When eating without tracking calories, what usually happens?',
      'options': [
        {'text': 'My weight stays the same or drops. Hard to eat enough.', 'type': BodyType.lean},
        {'text': 'My weight stays relatively stable and proportionate.', 'type': BodyType.fit},
        {'text': 'I tend to gain weight quickly if I am not careful.', 'type': BodyType.fat},
      ]
    },
    {
      'question': 'What are your primary fitness goals right now?',
      'options': [
        {'text': 'Gain serious muscle mass & weight.', 'type': BodyType.lean},
        {'text': 'Maintain my athletic shape & improve endurance.', 'type': BodyType.fit},
        {'text': 'Lose fat & drop overall body weight.', 'type': BodyType.fat},
      ]
    }
  ];

  void _answerQuestion(BodyType selectedType) {
    if (selectedType == BodyType.lean) _leanScore++;
    if (selectedType == BodyType.fit) _fitScore++;
    if (selectedType == BodyType.fat) _fatScore++;

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _processResults();
    }
  }

  void _processResults() {
    BodyType finalType;
    if (_leanScore > _fitScore && _leanScore > _fatScore) {
      finalType = BodyType.lean;
    } else if (_fatScore > _leanScore && _fatScore > _fitScore) {
      finalType = BodyType.fat;
    } else {
      finalType = BodyType.fit; // Default tie-breaker
    }

    // Skip the real processing delay, but we'll show the animation briefly for UX
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BodyScanProcessingScreen(
          imageFile: null, // Indicates Quiz mode
          precalculatedResult: BodyScanResult(
            type: finalType,
            description: "Based on your questionnaire, we've identified your primary body composition profile to customize your workout and diet.",
            confidence: 0.99, // High confidence since it's user-reported
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Quick Body Quiz',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Indicator
              Row(
                children: List.generate(_questions.length, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index <= _currentQuestionIndex 
                            ? AppColors.primary 
                            : AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              
              Text(
                'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                currentQ['question'],
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 40),

              ...((currentQ['options'] as List<Map<String, dynamic>>).map((option) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    onTap: () => _answerQuestion(option['type']),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEBEBEB), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option['text'],
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                );
              })),
            ],
          ),
        ),
      ),
    );
  }
}
