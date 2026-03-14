import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';

class HomeSection extends StatefulWidget {
  final ScrollController scrollController;
  final Map<String, GlobalKey> sectionKeys;

  const HomeSection({
    super.key,
    required this.scrollController,
    required this.sectionKeys,
  });

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late AnimationController _particleController;
  late AnimationController _textCycleController;

  int _titleIndex = 0;
  bool _showCursor = true;

  final List<Map<String, String>> _roles = [
    {'text': 'Flutter Engineer', 'asset': 'assets/images/icon_flutter.png'},
    {'text': 'Application Developer', 'asset': 'assets/images/icon_play_store.png'},
    {'text': 'AI-Augmented Developer', 'asset': 'assets/images/icon_ai_brain.png'},
    {'text': 'iOS & Android Expert', 'asset': 'assets/images/icon_ios.png'},
    {'text': 'Firebase Architect', 'asset': 'assets/images/icon_firebase.png'},
  ];

  // Tech stack using local assets
  static const _techStack = [
    {'name': 'Flutter', 'asset': 'assets/images/icon_flutter.png'},
    {'name': 'Firebase', 'asset': 'assets/images/icon_firebase.png'},
    {'name': 'iOS', 'asset': 'assets/images/icon_ios.png'},
    {'name': 'Figma', 'asset': 'assets/images/icon_figma.png'},
    {'name': 'ChatGPT', 'asset': 'assets/images/icon_chatgpt.png'},
    {'name': 'Claude', 'asset': 'assets/images/icon_claude.png'},
    {'name': 'Gemini', 'asset': 'assets/images/icon_gemini.png'},
    {'name': 'Cursor', 'asset': 'assets/images/icon_cursor.png'},
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _textCycleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Blinking cursor
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) setState(() => _showCursor = !_showCursor);
      return mounted;
    });

    // Role cycling
    Future.delayed(const Duration(seconds: 2), _cycleTitle);
  }

  void _cycleTitle() async {
    if (!mounted) return;
    await _textCycleController.forward();
    if (mounted) {
      setState(() => _titleIndex = (_titleIndex + 1) % _roles.length);
      _textCycleController.reset();
    }
    Future.delayed(const Duration(seconds: 3), _cycleTitle);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    _particleController.dispose();
    _textCycleController.dispose();
    super.dispose();
  }

  void _scrollTo(String key) {
    final ctx = widget.sectionKeys[key]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final padding = Responsive.horizontalPadding(context);
    final screenH = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: screenH),
      color: AppColors.background,
      child: Stack(
        children: [
          // Live particle field
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (_, __) => CustomPaint(
                painter: _ParticlePainter(
                  progress: _particleController.value,
                ),
              ),
            ),
          ),

          // Gold ambient orb top-right
          Positioned(
            top: -250,
            right: -200,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (_, __) => Opacity(
                opacity: 0.10 + 0.06 * _pulseController.value,
                child: Container(
                  width: 700,
                  height: 700,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0x60D4AF37), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Amber orb bottom-left
          Positioned(
            bottom: -150,
            left: -100,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (_, __) => Opacity(
                opacity: 0.05 + 0.04 * _pulseController.value,
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0x50F59E0B), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Main content
          Padding(
            padding: EdgeInsets.only(
              left: padding,
              right: padding,
              top: isMobile ? 80 : 110,
              bottom: 60,
            ),
            child: isMobile ? _buildMobile(context) : _buildDesktop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 11, child: _buildText(context)),
            const SizedBox(width: 60),
            Expanded(flex: 9, child: _buildPhotoCard(context)),
          ],
        ),
        const SizedBox(height: 60),
        _buildTechStackRow(context),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildPhotoCard(context, isMobile: true),
        const SizedBox(height: 36),
        _buildText(context),
        const SizedBox(height: 44),
        _buildTechStackRow(context),
      ],
    );
  }

  Widget _buildText(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Status badge
        _buildStatusBadge()
            .animate()
            .fadeIn(delay: 60.ms)
            .slideY(begin: 0.3, curve: Curves.easeOutBack),

        const SizedBox(height: 20),

        // Main heading
        Text(
          "Building the Future",
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isMobile ? 36 : 56,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFF8F8FF),
            height: 1.1,
            letterSpacing: -1.5,
          ),
        )
            .animate()
            .fadeIn(delay: 150.ms)
            .slideY(begin: 0.3, curve: Curves.easeOutCubic),

        Row(
          mainAxisAlignment:
              isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Text(
              "with ",
              style: TextStyle(
                fontSize: isMobile ? 36 : 56,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFF8F8FF),
                height: 1.1,
                letterSpacing: -1.5,
              ),
            ),
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFF59E0B)],
              ).createShader(b),
              child: Text(
                "Flutter & AI",
                style: TextStyle(
                  fontSize: isMobile ? 36 : 56,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                  letterSpacing: -1.5,
                ),
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(delay: 250.ms)
            .slideY(begin: 0.3, curve: Curves.easeOutCubic),

        const SizedBox(height: 20),

        // Animated role ticker
        _buildRoleRow(isMobile)
            .animate()
            .fadeIn(delay: 350.ms),

        const SizedBox(height: 18),

        // Bio
        Text(
          "I'm Gaurav Hada - Software Engineer crafting production-grade iOS & Android apps "
          "with pixel-perfect UI, scalable Firebase backends, and AI-accelerated workflows. "
          "From ideation to production.",
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: const Color(0xFF9CA3AF),
            height: 1.75,
          ),
        )
            .animate()
            .fadeIn(delay: 450.ms)
            .slideY(begin: 0.2),

        const SizedBox(height: 32),

        // CTA Buttons
        Wrap(
          spacing: 14,
          runSpacing: 14,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _GoldButton(
              label: 'View Projects',
              icon: Icons.rocket_launch_rounded,
              onTap: () => _scrollTo('projects'),
            ),
            _GhostButton(
              label: 'GitHub Profile',
              icon: Icons.code_rounded,
              onTap: () =>
                  _launchUrl('https://github.com/gauravhada30'),
            ),
          ],
        )
            .animate()
            .fadeIn(delay: 550.ms)
            .slideY(begin: 0.2),

        const SizedBox(height: 22),

        // App Store + Play Store badges
        _buildStoreBadges(isMobile)
            .animate()
            .fadeIn(delay: 630.ms)
            .slideY(begin: 0.2),

        const SizedBox(height: 32),

        // Stats
        _buildStats(isMobile)
            .animate()
            .fadeIn(delay: 700.ms),
      ],
    );
  }

  Widget _buildStoreBadges(bool isMobile) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: [
        _StoreBadge(
          iconAsset: 'assets/images/icon_play_store.png',
          label: 'Play Store',
          sublabel: 'Get it on',
          onTap: () => _launchUrl('https://play.google.com/store/apps/details?id=com.farmer.eravan'),
        ),
        _StoreBadge(
          iconAsset: 'assets/images/icon_app_store.png',
          label: 'App Store',
          sublabel: 'Available on',
          onTap: () => _launchUrl('https://apps.apple.com'),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withAlpha(18),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF10B981).withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulsingDot(color: const Color(0xFF10B981)),
          const SizedBox(width: 8),
          const Text(
            'Open to work · Software Developer',
            style: TextStyle(
              color: Color(0xFF10B981),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleRow(bool isMobile) {
    final role = _roles[_titleIndex];
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        // Vertical gold line
        Container(
          width: 3,
          height: 22,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFD4AF37), Color(0xFFF59E0B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, 0.4),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: child,
            ),
          ),
          child: Row(
            key: ValueKey(_titleIndex),
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                role['asset']!,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox(width: 24, height: 24),
              ),
              const SizedBox(width: 10),
              Text(
                role['text']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFD1D5DB),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        // Blinking cursor
        AnimatedOpacity(
          opacity: _showCursor ? 1 : 0,
          duration: const Duration(milliseconds: 100),
          child: const Text(
            '|',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFFD4AF37),
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStats(bool isMobile) {
    final stats = [
      {'value': '2+', 'label': 'Years Exp', 'icon': '⚡'},
      {'value': '10+', 'label': 'Apps Shipped', 'icon': '📱'},
      {'value': '50K+', 'label': 'Downloads', 'icon': '⬇️'},
      {'value': '3+', 'label': 'Companies', 'icon': '🏢'},
    ];

    return Wrap(
      spacing: 20,
      runSpacing: 12,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: stats.map((s) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [Color(0xFFD4AF37), Color(0xFFF59E0B)],
                  ).createShader(b),
                  child: Text(
                    s['value']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  s['label']!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (s != stats.last)
              Container(
                width: 1,
                height: 30,
                margin: const EdgeInsets.only(left: 20),
                color: const Color(0xFF2A2A3E),
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTechStackRow(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Container(width: 24, height: 1, color: const Color(0xFF2A2A3E)),
            const SizedBox(width: 10),
            const Text(
              'TECH STACK',
              style: TextStyle(
                color: Color(0xFF4B5563),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 10),
            Container(width: 24, height: 1, color: const Color(0xFF2A2A3E)),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: _techStack.asMap().entries.map((e) {
            return _TechAssetChip(
              name: e.value['name'] as String,
              assetPath: e.value['asset'] as String,
              delay: e.key * 60,
            );
          }).toList(),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: 800.ms)
        .slideY(begin: 0.2, curve: Curves.easeOutCubic);
  }

  Widget _buildPhotoCard(BuildContext context, {bool isMobile = false}) {
    final size = isMobile ? 220.0 : 340.0;
    return AnimatedBuilder(
      animation: _floatController,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, (_floatController.value - 0.5) * 14),
        child: child,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing outer glow ring
          AnimatedBuilder(
            animation: _pulseController,
            builder: (_, __) => Container(
              width: size + 50,
              height: size + 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.gold.withAlpha(
                      (18 + 12 * _pulseController.value).toInt(),
                    ),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Gradient ring border
          Container(
            width: size + 10,
            height: size + 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  Color(0xFFD4AF37),
                  Color(0xFFF59E0B),
                  Color(0xFF1A1A26),
                  Color(0xFFD4AF37),
                ],
              ),
            ),
          ),

          Container(
            width: size + 4,
            height: size + 4,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF0A0A0F),
            ),
          ),

          // Profile photo
          ClipOval(
            child: SizedBox(
              width: size,
              height: size,
              child: Image.asset(
                'assets/images/profile.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: size,
                  height: size,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1A1A26),
                  ),
                  child: const Icon(Icons.person_rounded,
                      size: 80, color: Color(0xFF2A2A3E)),
                ),
              ),
            ),
          ),

          // Floating icon chips with real assets
          if (!isMobile) ...[
            _buildFloatingChip(
              assetPath: 'assets/images/icon_flutter.png',
              label: 'Flutter',
              dx: size / 2 + 20,
              dy: -size / 4,
              delayMs: 0,
            ),
            _buildFloatingChip(
              assetPath: 'assets/images/icon_firebase.png',
              label: 'Firebase',
              dx: size / 2 + 20,
              dy: size / 6,
              delayMs: 300,
            ),
            _buildFloatingChip(
              assetPath: 'assets/images/icon_ai_brain.png',
              label: 'AI Tools',
              dx: -size / 2 - 30,
              dy: -size / 5,
              delayMs: 150,
            ),
            _buildFloatingChip(
              assetPath: 'assets/images/icon_ios.png',
              label: 'iOS',
              dx: -size / 2 - 20,
              dy: size / 6,
              delayMs: 450,
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildFloatingChip({
    required String assetPath,
    required String label,
    required double dx,
    required double dy,
    required int delayMs,
  }) {
    return Positioned(
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (_, child) => Transform.translate(
          offset: Offset(
            dx,
            dy + (_floatController.value - 0.5) * 10 * (delayMs.isEven ? 1 : -1),
          ),
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A26),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF2A2A3E)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(80),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                assetPath,
                width: 16,
                height: 16,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.code, size: 14, color: Color(0xFF9CA3AF)),
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFD1D5DB),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        )
            .animate(delay: Duration(milliseconds: delayMs))
            .fadeIn()
            .slideY(begin: 0.3),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ── Pulsing Dot ─────────────────────────────────────
class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: widget.color.withAlpha((120 + 135 * _ctrl.value).toInt()),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color.withAlpha((60 * _ctrl.value).toInt()),
              blurRadius: 8,
              spreadRadius: 3,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tech Logo Chip ────────────────────────────────────
class _TechLogoChip extends StatefulWidget {
  final String name;
  final String logoUrl;
  final int delay;

  const _TechLogoChip({
    required this.name,
    required this.logoUrl,
    required this.delay,
  });

  @override
  State<_TechLogoChip> createState() => _TechLogoChipState();
}

class _TechLogoChipState extends State<_TechLogoChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _hovered
              ? const Color(0xFF1E1E2E)
              : const Color(0xFF12121A),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: _hovered
                ? AppColors.gold.withAlpha(100)
                : const Color(0xFF2A2A3E),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.gold.withAlpha(20),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              widget.logoUrl,
              width: 16,
              height: 16,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.code,
                size: 16,
                color: Color(0xFF4B5563),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.name,
              style: TextStyle(
                color: _hovered
                    ? const Color(0xFFF1F1F3)
                    : const Color(0xFF9CA3AF),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: widget.delay))
        .fadeIn()
        .slideY(begin: 0.2, curve: Curves.easeOutBack);
  }
}


// ── Tech Asset Chip (uses local asset images) ─────────
class _TechAssetChip extends StatefulWidget {
  final String name;
  final String assetPath;
  final int delay;

  const _TechAssetChip({
    required this.name,
    required this.assetPath,
    required this.delay,
  });

  @override
  State<_TechAssetChip> createState() => _TechAssetChipState();
}

class _TechAssetChipState extends State<_TechAssetChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _hovered ? const Color(0xFF1E1E2E) : const Color(0xFF12121A),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: _hovered
                ? AppColors.gold.withAlpha(100)
                : const Color(0xFF2A2A3E),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.gold.withAlpha(20),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              widget.assetPath,
              width: 16,
              height: 16,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.code,
                size: 16,
                color: Color(0xFF4B5563),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.name,
              style: TextStyle(
                color: _hovered
                    ? const Color(0xFFF1F1F3)
                    : const Color(0xFF9CA3AF),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: widget.delay))
        .fadeIn()
        .slideY(begin: 0.2, curve: Curves.easeOutBack);
  }
}

// ── Store Badge (App Store / Play Store) ──────────────
class _StoreBadge extends StatefulWidget {
  final String iconAsset;
  final String label;
  final String sublabel;
  final VoidCallback onTap;

  const _StoreBadge({
    required this.iconAsset,
    required this.label,
    required this.sublabel,
    required this.onTap,
  });

  @override
  State<_StoreBadge> createState() => _StoreBadgeState();
}

class _StoreBadgeState extends State<_StoreBadge> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFF1A1A26)
                : const Color(0xFF12121A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? AppColors.gold.withAlpha(80)
                  : const Color(0xFF2A2A3E),
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.gold.withAlpha(20),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                widget.iconAsset,
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.store, size: 24, color: Color(0xFF4B5563)),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sublabel,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: _hovered
                          ? const Color(0xFFF1F1F3)
                          : const Color(0xFFD1D5DB),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Buttons ─────────────────────────────────────────

class _GoldButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _GoldButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_GoldButton> createState() => _GoldButtonState();
}

class _GoldButtonState extends State<_GoldButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 80),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD4AF37), Color(0xFFF59E0B)],
              ),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withAlpha(_hovered ? 100 : 50),
                  blurRadius: _hovered ? 24 : 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 16, color: Colors.black87),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: 0.2,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform:
                      Matrix4.translationValues(_hovered ? 4 : 0, 0, 0),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GhostButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _GhostButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<_GhostButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFF1A1A26)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: _hovered
                  ? const Color(0xFF2A2A3E)
                  : const Color(0xFF2A2A3E),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon,
                  size: 16,
                  color: _hovered
                      ? const Color(0xFFF1F1F3)
                      : const Color(0xFF9CA3AF)),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: _hovered
                      ? const Color(0xFFF1F1F3)
                      : const Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Particle Painter ────────────────────────────────────
class _ParticlePainter extends CustomPainter {
  final double progress;
  static final List<_Particle> _particles = List.generate(
    40,
    (i) => _Particle(
      x: math.Random(i * 73).nextDouble(),
      y: math.Random(i * 131).nextDouble(),
      size: 0.5 + math.Random(i * 37).nextDouble() * 1.5,
      speed: 0.2 + math.Random(i * 59).nextDouble() * 0.4,
      phase: math.Random(i * 113).nextDouble() * math.pi * 2,
    ),
  );

  _ParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final p in _particles) {
      final x = (p.x + progress * p.speed * 0.3) % 1.0 * size.width;
      final y = p.y * size.height;
      final brightness =
          0.3 + 0.4 * math.sin(progress * math.pi * 2 * p.speed + p.phase);
      paint.color =
          const Color(0xFFD4AF37).withAlpha((brightness * 80).toInt());
      canvas.drawCircle(Offset(x, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _Particle {
  final double x, y, size, speed, phase;
  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
  });
}
