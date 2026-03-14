import '../models/experience_model.dart';
import '../models/project_model.dart';
import '../models/ai_tool_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PortfolioData {
  // ── Personal Info ──────────────────────────────
  static const String name = 'Gaurav Hada';
  static const String title = 'Software Developer';
  static const String subtitle = 'Product Designer & Mobile Engineer';
  static const String tagline =
      'Crafting scalable, production-grade Flutter applications with deep Firebase '
      'integration, advanced state management, and smart AI-accelerated workflows.';
  static const String email = 'hadagaurav56@gmail.com';
  static const String phone = '+91-9001852825';
  static const String linkedIn =
      'https://www.linkedin.com/in/gaurav-hada-07286820b/';
  static const String github = 'https://github.com/gauravhada30';

  static const String bio =
      'I\'m a passionate Application Developer bridging the gap between pixel-perfect design and '
      'robust mobile architecture. With over 2 years of hands-on experience in shipping production '
      'applications, I specialize in building complete digital products using Flutter, Dart, GetX, and Firebase.\n\n'
      'From single-handedly architecting a full B2B/B2C agritech platform at Eravan to collaborating '
      'in high-velocity Agile teams at Deorwine Infotech, I take ownership of the entire product lifecycle '
      '— from scalable database design and REST API integration to Play Store deployment.\n\n'
      'I am a strong advocate for AI-augmented development, natively utilizing tools like Cursor, GitHub Copilot, '
      'and modern LLMs to dramatically accelerate delivery times while maintaining enterprise-level code quality.';

  // ── Tech Highlights (shown as badges in hero) ───
  static const List<String> heroTechBadges = [
    'Flutter SDK',
    'Dart',
    'Firebase Auth/Firestore',
    'GetX & Riverpod',
    'REST APIs',
    'Android Integration',
    'AI-Augmented Dev',
    'CI/CD Pipelines',
  ];

  // ── Hero Stats (only meaningful metrics) ─────
  static const List<Map<String, String>> heroStats = [
    {'value': '2+', 'label': 'Years Experience'},
    {'value': '10+', 'label': 'Apps Shipped'},
    {'value': '50K+', 'label': 'App Downloads'},
  ];

  // ── Education ──────────────────────────────────
  static const String degree =
      'B.Tech in Electronics & Communication Engineering';
  static const String university =
      'Indian Institute of Information Technology, Kota';
  static const String graduationYear = 'July 2020 – May 2024';
  static const String cgpa = '7 / 10';

  // ── Positions of Responsibility ────────────────
  static const List<String> positions = [
    'Executive — Film & Photography Club, MNIT Jaipur',
    'Co-founder — Neon Cinematic Club, IIIT Kota',
    'Executive — Artive Club (Creative Art Society), IIIT Kota',
    'Managed administrative & ideation activities for College Fest, MNIT Jaipur',
  ];

  // ── Experience ─────────────────────────────────
  static const List<ExperienceModel> experiences = [
    ExperienceModel(
      company: 'Deorwine Infotech',
      role: 'Software Development Engineer',
      duration: 'March 2025 – Present',
      location: 'India',
      isPresent: true,
      logoEmoji: '🏢',
      tags: [
        'Flutter',
        'GetX',
        'Provider',
        'Riverpod',
        'Firebase',
        'REST API',
        'Razorpay',
      ],
      points: [
        'Developed production-ready Flutter apps for Android & iOS with GetX/Provider/Riverpod state management, custom theming, responsive layouts, and Material Design principles.',
        'Integrated Firebase (Auth, Firestore, FCM, Crashlytics), REST APIs, and payment gateways (Razorpay, Stripe) for real-time features and secure transactions.',
        'Collaborated in Agile/Scrum teams using Git, Jira, Figma for requirements gathering, code reviews, pull requests, and daily stand-ups.',
      ],
    ),
    ExperienceModel(
      company: 'Eravan Agritech Services',
      role: 'Co-Founder',
      duration: 'April 2024 – March 2025',
      location: 'India',
      logoEmoji: '🌱',
      tags: [
        'Flutter',
        'Firebase',
        'Razorpay',
        'Google Auth',
        'Play Store',
        'Product Design',
        'UI/UX',
      ],
      points: [
        'Co-founded and architected a complete Flutter e-commerce platform for a hydroponic farm startup — buyer/seller profiles, catalog, order management & CRM, published on the Play Store.',
        'Integrated Firebase (FCM, Auto-updates), Razorpay payments, Google Auth, and dynamic WebView for a seamless cross-platform user experience.',
        'Led end-to-end product design, architecture decisions, deployment pipeline, testing, and team coordination using Git & Jira.',
      ],
    ),
    ExperienceModel(
      company: 'Scale AI',
      role: 'Freelance AI Model Developer',
      duration: 'January 2024 – April 2024',
      location: 'Remote',
      logoEmoji: '🤖',
      tags: [
        'C++',
        'Python',
        'Java',
        'JavaScript',
        'Code Quality',
        'AI Evaluation',
      ],
      points: [
        'Reviewed and optimized AI-generated code across C++, Python, Java, and JavaScript — improved execution speed and model output quality through structured feedback.',
        'Evaluated 1,500+ AI responses for accuracy and relevance, establishing feedback loops that improved model interpretability by 30%.',
      ],
    ),
  ];

  // ── Projects ───────────────────────────────────
  static const List<ProjectModel> projects = [
    ProjectModel(
      title: 'Assessment App',
      subtitle: 'Flutter & Dart · OTP · Material 3',
      description:
          'A secure assessment platform with OTP-based onboarding, timed MCQ tests, and detailed result analytics.',
      emoji: '📝',
      accentColor: '8B5CF6',
      githubUrl: 'https://github.com/gauravhada30/ASSESMENT_APP',
      tags: ['Flutter', 'Dart', 'GetX', 'Material 3', 'OTP Auth'],
      points: [
        'Built with OTP onboarding, timed MCQs, detailed score analytics, and Material 3 UI.',
        'Modular GetX architecture for clean UI/logic separation with Git version control.',
      ],
    ),
    ProjectModel(
      title: 'Satsang App',
      subtitle: 'Flutter · Firebase · YouTube API v3',
      description:
          'A spiritual content streaming app integrating YouTube Data API v3 with Firebase OTP auth for elderly users.',
      emoji: '📺',
      accentColor: 'EC4899',
      githubUrl: 'https://github.com/gauravhada30/Satsang_Application',
      tags: [
        'Flutter',
        'Firebase',
        'YouTube API v3',
        'OTP Auth',
        'Mobile Number Auth',
      ],
      points: [
        'Integrated YouTube Data API v3 + YouTube Player with Firebase mobile OTP authentication.',
        'Designed for elderly users — large text, simple navigation, and accessible UI.',
      ],
    ),
    ProjectModel(
      title: 'Eravan — Agritech Platform',
      subtitle: 'Flutter · Firebase · Razorpay · Play Store',
      description:
          'Full agritech e-commerce app for a hydroponic farm startup — buyer/seller platform, catalog, CRM, live on Play Store.',
      emoji: '🌿',
      accentColor: '10B981',
      githubUrl: null,
      liveUrl:
          'https://play.google.com/store/apps/details?id=com.farmer.eravan&hl=en_IN',
      tags: [
        'Flutter',
        'Firebase',
        'Razorpay',
        'Google Auth',
        'Play Store',
        'CRM',
      ],
      points: [
        'Solo-built a complete B2B/B2C e-commerce platform — product catalog, buyer/seller profiles, order management, CRM.',
        'Integrated Razorpay payments, Firebase Auth, FCM push notifications, and Google Sign-In.',
      ],
    ),
    ProjectModel(
      title: 'Robotic Arm',
      subtitle: 'Arduino · C++ · Gesture Recognition',
      description:
          'A gesture-controlled robotic arm using a glove interface with advanced motion recognition algorithms.',
      emoji: '🦾',
      accentColor: 'F97316',
      tags: ['Arduino', 'C++', 'Servo Motors', 'Gesture Recognition', 'IoT'],
      points: [
        'Controlled via hand gestures (pinching, picking, wrist rotation) using a sensor glove.',
        'Precise servo control based on real-time gesture data; showcases hardware-software integration.',
      ],
    ),
    ProjectModel(
      title: 'Crowned Conundrum',
      subtitle: 'HTML · CSS · JavaScript · DSA',
      description:
          'An interactive N-Queens problem visualizer with controllable animation speed.',
      emoji: '♛',
      accentColor: 'F59E0B',
      githubUrl: 'https://github.com/gauravhada30',
      tags: ['HTML', 'CSS', 'JavaScript', 'Algorithms', 'Async Animation'],
      points: [
        'Visualizes N-Queens backtracking algorithm on a live chessboard with speed control.',
        'Async JS for animation, DOM manipulation, and clean algorithm implementation.',
      ],
    ),
  ];

  // ── Skills ─────────────────────────────────────
  static const List<SkillCategory> skills = [
    SkillCategory(
      name: 'Flutter & Android Core',
      emoji: '📱',
      skills: [
        'Flutter SDK',
        'Dart Programming',
        'Android (Kotlin/Java Integration)',
        'Material 3 UI & Animations',
        'Responsive Design',
        'Platform Channels',
      ],
    ),
    SkillCategory(
      name: 'Backend & Cloud (Firebase)',
      emoji: '🔥',
      skills: [
        'Firebase Auth & Security Rules',
        'Cloud Firestore & Realtime DB',
        'Firebase Cloud Messaging (FCM)',
        'Crashlytics & App Distribution',
        'Payment Gateways (Razorpay/Stripe)',
        'Postman API Testing',
      ],
    ),
    SkillCategory(
      name: 'Architecture & State Management',
      emoji: '🏗️',
      skills: [
        'GetX (Advanced Routing & State)',
        'Provider & Riverpod',
        'BLoC Pattern',
        'Clean Architecture',
        'SOLID Principles',
        'Dependency Injection',
        'MVC / MVVM Patterns',
      ],
    ),
    SkillCategory(
      name: 'DevOps, CI/CD & Version Control',
      emoji: '🛠️',
      skills: [
        'Git & GitHub Advanced Workflows',
        'CI/CD GitHub Actions',
        'Google Play Console Deployment',
        'Apple App Store Connect',
        'Agile / Scrum Methodologies',
        'Jira Project Tracking',
      ],
    ),
  ];

  // ── AI Tools & Workflows ────────────────────────────────
  static const List<AiToolModel> aiTools = [
    AiToolModel(
      name: 'Claude 3.5 Sonnet',
      description:
          'Advanced reasoning, prompt-driven UI generation, and complex refactoring assistance.',
      icon: FontAwesomeIcons.robot,
      colorHex: 'D97757', // Anthropic color vibe
    ),
    AiToolModel(
      name: 'ChatGPT-4o',
      description:
          'Architecting complex logic, debugging deep Flutter state management, and algorithm design.',
      icon: FontAwesomeIcons.brain,
      colorHex: '10A37F', // OpenAI green
    ),
    AiToolModel(
      name: 'Cursor IDE',
      description:
          'Editor-native AI code completions, multi-file codebase indexing, and conversational coding.',
      icon: FontAwesomeIcons.codeBranch,
      colorHex: '6366F1', // Cursor brand vibe
    ),
    AiToolModel(
      name: 'Gemini Advanced',
      description:
          'Google ecosystem integration, intelligent code explanations, and Android Studio Bot synergies.',
      icon: FontAwesomeIcons.bolt,
      colorHex: '4285F4', // Google blue
    ),
    AiToolModel(
      name: 'GitHub Copilot',
      description:
          'Inline code prediction, rapid boilerplate generation, and continuous predictive typing.',
      icon: FontAwesomeIcons.squareGithub,
      colorHex: '1F2328', // GitHub dark
    ),
    AiToolModel(
      name: 'Antigravity Workspace',
      description:
          'Fully autonomous agentic coding, executing multi-step repository-wide refactors automatically.',
      icon: FontAwesomeIcons.rocket,
      colorHex: 'F59E0B', // Bright amber
    ),
  ];
}
