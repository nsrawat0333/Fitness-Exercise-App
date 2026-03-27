/// Comprehensive Hindi voice instructions for every exercise category.
/// Each exercise maps to phase-specific guidance lists.
class HindiExerciseInstructions {
  // ═══════════════════════════════════════════
  //  Instruction Data Structure
  // ═══════════════════════════════════════════

  /// Returns all instructions for a given exercise name (case-insensitive).
  static ExerciseVoiceData? getInstructions(String exerciseName) {
    final key = exerciseName.toLowerCase().trim();
    return _instructionMap[key];
  }

  /// Returns generic workout encouragement lines.
  static List<String> get genericMotivation => _genericMotivation;

  /// Dynamic rep announcement.
  static String repCompleted(int count, int total) {
    return 'आपने $count रेप्स पूरे कर लिए। अब केवल ${total - count} बाकी हैं।';
  }

  static String repMilestone(int count) {
    return 'शाबाश! $count रेप्स पूरे! बहुत बढ़िया!';
  }

  static String sessionComplete(String exerciseName) {
    return 'बधाई हो! $exerciseName पूरा हो गया! आपने बहुत अच्छा किया!';
  }

  // ═══════════════════════════════════════════
  //  Generic Lines
  // ═══════════════════════════════════════════

  static final List<String> _genericMotivation = [
    'बहुत बढ़िया, जारी रखें!',
    'आप बहुत अच्छा कर रहे हैं!',
    'हिम्मत मत हारिए, आप कर सकते हैं!',
    'शानदार! ऐसे ही जारी रखें!',
    'आपकी मेहनत रंग लाएगी!',
    'बस थोड़ा और, आप कर सकते हैं!',
  ];

  static const List<String> breathingInhale = [
    'सांस अंदर लें…',
    'गहरी सांस अंदर लें…',
  ];

  static const List<String> breathingExhale = [
    'सांस बाहर छोड़ें…',
    'धीरे-धीरे सांस बाहर छोड़ें…',
  ];

  // ═══════════════════════════════════════════
  //  Phase instructions for workout flow
  // ═══════════════════════════════════════════

  static const List<String> phaseBreathing = [
    'आराम करें… गहरी सांस लें…',
    'सांस अंदर लें… और धीरे-धीरे बाहर छोड़ें…',
    'ध्यान केंद्रित करें। शरीर को शांत रखें।',
  ];

  static String phasePreview(String exerciseName) {
    return 'अगला एक्सरसाइज: $exerciseName। तैयार हो जाएं!';
  }

  static const List<String> phaseRecovery = [
    'बहुत बढ़िया! अब आराम करें।',
    'गहरी सांस लें… शरीर को रिलैक्स करें…',
    'अगले एक्सरसाइज के लिए तैयार हो जाएं।',
  ];

  // ═══════════════════════════════════════════
  //  Exercise-Specific Instruction Map
  // ═══════════════════════════════════════════

  static final Map<String, ExerciseVoiceData> _instructionMap = {
    // ── GYM: SQUATS ──
    'squats': ExerciseVoiceData(
      start: ['चलिए स्क्वैट्स शुरू करते हैं। सीधे खड़े हो जाएं।'],
      posture: [
        'अपने पैरों को कंधे की चौड़ाई पर रखें।',
        'पीठ सीधी रखें।',
        'धीरे-धीरे नीचे बैठें, जैसे कुर्सी पर बैठ रहे हों।',
        'घुटने पंजों से आगे न जाएं।',
        'अब धीरे-धीरे ऊपर आएं।',
      ],
      breathing: ['नीचे जाते समय सांस अंदर लें।', 'ऊपर आते समय सांस बाहर छोड़ें।'],
      motivation: ['बहुत अच्छा! ऐसे ही जारी रखें!', 'पीठ सीधी रखें, शानदार!'],
      completion: ['स्क्वैट्स पूरे! बहुत बढ़िया काम किया!'],
    ),
    'squat': ExerciseVoiceData(
      start: ['चलिए स्क्वैट्स शुरू करते हैं। सीधे खड़े हो जाएं।'],
      posture: [
        'अपने पैरों को कंधे की चौड़ाई पर रखें।',
        'पीठ सीधी रखें।',
        'धीरे-धीरे नीचे बैठें।',
        'अब ऊपर आएं।',
      ],
      breathing: ['नीचे जाते समय सांस अंदर लें।', 'ऊपर आते समय सांस बाहर छोड़ें।'],
      motivation: ['बहुत अच्छा! जारी रखें!'],
      completion: ['स्क्वैट्स पूरे!'],
    ),

    // ── GYM: PUSH-UPS ──
    'push-ups': ExerciseVoiceData(
      start: ['चलिए पुश-अप्स शुरू करते हैं। प्लैंक पोज़िशन में आएं।'],
      posture: [
        'हाथों को कंधों के ठीक नीचे रखें।',
        'शरीर को एक सीधी लाइन में रखें।',
        'धीरे-धीरे नीचे जाएं, छाती ज़मीन के पास।',
        'अब ऊपर पुश करें।',
        'कमर को न झुकाएं, शरीर सीधा रखें।',
      ],
      breathing: ['नीचे जाते समय सांस अंदर लें।', 'ऊपर आते समय सांस बाहर छोड़ें।'],
      motivation: ['शानदार फॉर्म! जारी रखें!', 'कोर टाइट रखें, बहुत बढ़िया!'],
      completion: ['पुश-अप्स पूरे! आपने कमाल किया!'],
    ),
    'push ups': ExerciseVoiceData(
      start: ['प्लैंक पोज़िशन में आएं।'],
      posture: ['हाथों को कंधों के नीचे रखें।', 'धीरे-धीरे नीचे जाएं।', 'अब ऊपर पुश करें।'],
      breathing: ['नीचे सांस अंदर।', 'ऊपर सांस बाहर।'],
      motivation: ['बहुत बढ़िया!'],
      completion: ['पुश-अप्स पूरे!'],
    ),

    // ── GYM: PULL-UPS ──
    'pull-ups': ExerciseVoiceData(
      start: ['चलिए पुल-अप्स शुरू करते हैं। बार को अच्छे से पकड़ें।'],
      posture: [
        'हाथों को कंधे से थोड़ा चौड़ा रखें।',
        'शरीर को ऊपर खींचें, ठोड़ी बार के ऊपर।',
        'धीरे-धीरे नीचे आएं।',
        'कंधे पीछे रखें।',
      ],
      breathing: ['ऊपर जाते समय सांस बाहर छोड़ें।', 'नीचे आते समय सांस अंदर लें।'],
      motivation: ['बहुत अच्छा! ताकत दिखाइए!'],
      completion: ['पुल-अप्स पूरे! ज़बरदस्त!'],
    ),

    // ── GYM: CHIN-UPS ──
    'chin-ups': ExerciseVoiceData(
      start: ['चिन-अप्स शुरू करते हैं। बार को अंडरहैंड ग्रिप से पकड़ें।'],
      posture: [
        'हथेलियां आपकी तरफ़ होनी चाहिए।',
        'शरीर को ऊपर खींचें।',
        'धीरे-धीरे नीचे आएं, कंट्रोल में रहें।',
      ],
      breathing: ['ऊपर जाते समय सांस बाहर छोड़ें।', 'नीचे आते समय सांस अंदर लें।'],
      motivation: ['शानदार! बाइसेप्स का अच्छा काम!'],
      completion: ['चिन-अप्स पूरे!'],
    ),

    // ── GYM: LUNGES ──
    'lunges': ExerciseVoiceData(
      start: ['लंजेस शुरू करते हैं। सीधे खड़े हों।'],
      posture: [
        'एक पैर आगे बढ़ाएं।',
        'दोनों घुटने 90 डिग्री पर मोड़ें।',
        'पीठ सीधी रखें।',
        'वापस ऊपर आएं।',
      ],
      breathing: ['नीचे जाते समय सांस अंदर।', 'ऊपर आते समय सांस बाहर।'],
      motivation: ['बैलेंस बनाए रखें, बहुत अच्छा!'],
      completion: ['लंजेस पूरे!'],
    ),

    // ── GYM: PLANK ──
    'plank': ExerciseVoiceData(
      start: ['प्लैंक पोज़िशन में आएं।'],
      posture: [
        'कोहनियां कंधों के ठीक नीचे रखें।',
        'शरीर को एक सीधी लाइन में रखें।',
        'कोर को टाइट रखें।',
        'कमर को न गिराएं।',
      ],
      breathing: ['सामान्य रूप से सांस लेते रहें।', 'गहरी और स्थिर सांस लें।'],
      motivation: ['होल्ड करें! आप कर सकते हैं!', 'धीरे करें, जल्दबाज़ी न करें।'],
      completion: ['प्लैंक पूरा! बहुत बढ़िया कोर वर्कआउट!'],
    ),

    // ── GYM: BURPEES ──
    'burpees': ExerciseVoiceData(
      start: ['बर्पीज़ शुरू करते हैं। पूरी एनर्जी लगाएं!'],
      posture: [
        'खड़े हों, फिर नीचे झुकें।',
        'हाथ ज़मीन पर रखें, पैर पीछे ले जाएं।',
        'एक पुश-अप करें।',
        'पैर वापस लाएं और ऊपर जंप करें।',
      ],
      breathing: ['जंप करते समय सांस बाहर।', 'नीचे जाते समय सांस अंदर।'],
      motivation: ['एनर्जी बनाए रखें!'],
      completion: ['बर्पीज़ पूरे! कमाल की एनर्जी!'],
    ),

    // ── GYM: CRUNCHES ──
    'crunches': ExerciseVoiceData(
      start: ['क्रंचेज़ शुरू करते हैं। पीठ के बल लेट जाएं।'],
      posture: [
        'घुटने मोड़ें, पैर ज़मीन पर।',
        'हाथ सिर के पीछे।',
        'कंधे ऊपर उठाएं।',
        'गर्दन पर दबाव न डालें।',
      ],
      breathing: ['ऊपर उठते समय सांस बाहर।', 'नीचे जाते समय सांस अंदर।'],
      motivation: ['एब्स को महसूस करें! बढ़िया!'],
      completion: ['क्रंचेज़ पूरे!'],
    ),

    // ── GYM: DEADLIFT ──
    'deadlift': ExerciseVoiceData(
      start: ['डेडलिफ्ट शुरू करते हैं। बार के पास खड़े हों।'],
      posture: [
        'पैर कंधे की चौड़ाई पर।',
        'कमर से झुकें, पीठ सीधी रखें।',
        'बार उठाएं, पैरों और हिप्स से ताकत लगाएं।',
        'ऊपर खड़े हों।',
      ],
      breathing: ['उठाते समय सांस बाहर।', 'नीचे रखते समय सांस अंदर।'],
      motivation: ['फॉर्म बनाए रखें!'],
      completion: ['डेडलिफ्ट पूरा!'],
    ),

    // ═══════════════════════════════════════
    //  YOGA
    // ═══════════════════════════════════════

    'pranayama': ExerciseVoiceData(
      start: ['आराम से बैठ जाएं। आंखें बंद करें।'],
      posture: [
        'कमर सीधी रखें।',
        'हाथ घुटनों पर रखें।',
        'ध्यान केंद्रित करें।',
      ],
      breathing: [
        'सांस अंदर लें… तीन… दो… एक…',
        'सांस धीरे-धीरे बाहर छोड़ें… तीन… दो… एक…',
        'फिर से… सांस अंदर… गहरी… लंबी…',
        'और बाहर छोड़ें… पूरी तरह…',
      ],
      motivation: ['बहुत शांत… ऐसे ही जारी रखें।'],
      completion: ['प्राणायाम पूरा। आपका मन शांत है।'],
    ),

    'surya namaskar': ExerciseVoiceData(
      start: ['सूर्य नमस्कार शुरू करते हैं। प्रणाम की स्थिति में आएं।'],
      posture: [
        'हाथ ऊपर उठाएं, पीछे झुकें।',
        'आगे झुकें, हाथ ज़मीन पर।',
        'एक पैर पीछे ले जाएं।',
        'दोनों पैर पीछे, प्लैंक पोज़िशन।',
        'छाती और ठोड़ी ज़मीन पर।',
        'कोबरा पोज़ में ऊपर उठें।',
        'नीचे का कुत्ता पोज़।',
        'वापस प्रणाम।',
      ],
      breathing: ['ऊपर जाते समय सांस अंदर।', 'नीचे जाते समय सांस बाहर।'],
      motivation: ['ऊर्जा महसूस करें!'],
      completion: ['सूर्य नमस्कार पूरा! नमस्ते।'],
    ),

    'shavasana': ExerciseVoiceData(
      start: ['शवासन शुरू करते हैं। पीठ के बल लेट जाएं।'],
      posture: ['हाथ शरीर के बगल में रखें।', 'आंखें बंद करें।', 'पूरे शरीर को ढीला छोड़ दें।'],
      breathing: ['सामान्य रूप से सांस लें।', 'हर सांस के साथ शरीर को और रिलैक्स करें।'],
      motivation: ['शांत रहें… मन को खाली करें।'],
      completion: ['शवासन पूरा। धीरे-धीरे आंखें खोलें।'],
    ),

    // ═══════════════════════════════════════
    //  THERAPY
    // ═══════════════════════════════════════

    'neck rotation': ExerciseVoiceData(
      start: ['गर्दन की एक्सरसाइज़ शुरू करते हैं।'],
      posture: [
        'गर्दन को धीरे-धीरे दाईं ओर घुमाएं।',
        'अब बाईं ओर घुमाएं।',
        'कोई झटका न दें।',
        'धीरे और नियंत्रित मूवमेंट रखें।',
      ],
      breathing: ['एक तरफ़ जाते समय सांस अंदर।', 'दूसरी तरफ़ सांस बाहर।'],
      motivation: ['धीरे करें, जल्दबाज़ी न करें। बहुत अच्छा!'],
      completion: ['गर्दन की एक्सरसाइज़ पूरी!'],
    ),

    'back stretch': ExerciseVoiceData(
      start: ['पीठ की स्ट्रेचिंग शुरू करते हैं।'],
      posture: [
        'आगे झुकें, पैर सीधे रखें।',
        'हाथों को पैरों की तरफ़ ले जाएं।',
        'पीठ को गोल करें।',
        'धीरे-धीरे वापस आएं।',
      ],
      breathing: ['झुकते समय सांस बाहर।', 'ऊपर आते समय सांस अंदर।'],
      motivation: ['अच्छा स्ट्रेच! रिलैक्स करें।'],
      completion: ['बैक स्ट्रेच पूरा!'],
    ),

    'knee exercise': ExerciseVoiceData(
      start: ['घुटने की एक्सरसाइज़ शुरू करते हैं।'],
      posture: [
        'कुर्सी पर बैठें।',
        'एक पैर सीधा करें।',
        '5 सेकंड होल्ड करें।',
        'धीरे-धीरे नीचे लाएं।',
      ],
      breathing: ['पैर उठाते समय सांस बाहर।', 'नीचे लाते समय सांस अंदर।'],
      motivation: ['कंट्रोल में रहें, बहुत बढ़िया!'],
      completion: ['घुटने की एक्सरसाइज़ पूरी!'],
    ),

    'shoulder roll': ExerciseVoiceData(
      start: ['कंधे की एक्सरसाइज़ शुरू करते हैं।'],
      posture: [
        'कंधों को धीरे-धीरे ऊपर उठाएं।',
        'पीछे की ओर घुमाएं।',
        'अब आगे की ओर घुमाएं।',
        'गोल-गोल मूवमेंट करें।',
      ],
      breathing: ['सामान्य सांस लेते रहें।'],
      motivation: ['तनाव को छोड़ें। बहुत अच्छा!'],
      completion: ['शोल्डर रोल पूरा!'],
    ),

    'headache relief': ExerciseVoiceData(
      start: ['सिरदर्द राहत थेरेपी शुरू करते हैं। आराम से बैठ जाएं।'],
      posture: [
        'आंखें बंद करें।',
        'कनपटी पर हल्के से दबाव दें।',
        'गर्दन को धीरे-धीरे घुमाएं।',
      ],
      breathing: ['गहरी सांस लें और छोड़ें।'],
      motivation: ['रिलैक्स करें… तनाव कम हो रहा है।'],
      completion: ['थेरेपी पूरी। बेहतर महसूस करें!'],
    ),

    'period care': ExerciseVoiceData(
      start: ['पीरियड केयर थेरेपी शुरू करते हैं।'],
      posture: [
        'आराम से लेट जाएं या बैठ जाएं।',
        'घुटने छाती की तरफ़ लाएं।',
        'धीरे-धीरे एक तरफ़ घुमाएं।',
      ],
      breathing: ['गहरी और धीमी सांस लें।'],
      motivation: ['आपका शरीर मज़बूत है। आराम करें।'],
      completion: ['थेरेपी पूरी!'],
    ),

    'stomach pain': ExerciseVoiceData(
      start: ['पेट दर्द राहत थेरेपी शुरू करते हैं।'],
      posture: [
        'पीठ के बल लेट जाएं।',
        'घुटने मोड़ें।',
        'पेट पर हल्के से हाथ रखें।',
        'धीरे-धीरे दाएं-बाएं मूव करें।',
      ],
      breathing: ['पेट से गहरी सांस लें।', 'धीरे-धीरे छोड़ें।'],
      motivation: ['आराम से करें।'],
      completion: ['पेट थेरेपी पूरी!'],
    ),
  };
}

/// Data class holding exercise-specific voice instructions.
class ExerciseVoiceData {
  final List<String> start;
  final List<String> posture;
  final List<String> breathing;
  final List<String> motivation;
  final List<String> completion;

  const ExerciseVoiceData({
    required this.start,
    required this.posture,
    required this.breathing,
    required this.motivation,
    required this.completion,
  });
}
