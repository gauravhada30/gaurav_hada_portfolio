import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'utils/app_colors.dart';
import 'utils/responsive.dart';
import 'widgets/app_navbar.dart';
import 'modules/home/home_section.dart';
import 'modules/about/about_section.dart';
import 'modules/experience/experience_section.dart';
import 'modules/projects/projects_section.dart';
import 'modules/skills/skills_section.dart';
import 'modules/ai/ai_section.dart';
import 'modules/contact/contact_section.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<String> _activeSection = ValueNotifier('home');

  final Map<String, GlobalKey> _sectionKeys = {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'experience': GlobalKey(),
    'projects': GlobalKey(),
    'skills': GlobalKey(),
    'ai': GlobalKey(),
    'contact': GlobalKey(),
  };

  void _scrollTo(String key) {
    final keyObj = _sectionKeys[key];
    if (keyObj == null) return;
    final ctx = keyObj.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _activeSection.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(String section, double fraction) {
    // Trigger at just 5% visible — almost immediately on scroll
    if (fraction > 0.05) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_activeSection.value != section) {
          _activeSection.value = section;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      endDrawer: isMobile ? _buildMobileDrawer() : null,
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Anchor for home section
                SizedBox(key: _sectionKeys['home'], height: 0),
                const SizedBox(height: 20),
                VisibilityDetector(
                  key: const Key('vd-home'),
                  onVisibilityChanged: (i) =>
                      _onVisibilityChanged('home', i.visibleFraction),
                  child: HomeSection(
                    scrollController: _scrollController,
                    sectionKeys: _sectionKeys,
                  ),
                ),
                SizedBox(key: _sectionKeys['about'], height: 0),
                VisibilityDetector(
                  key: const Key('vd-about'),
                  onVisibilityChanged: (i) =>
                      _onVisibilityChanged('about', i.visibleFraction),
                  child: AboutSection(scrollController: _scrollController),
                ),
                SizedBox(key: _sectionKeys['experience'], height: 0),
                VisibilityDetector(
                  key: const Key('vd-exp'),
                  onVisibilityChanged: (i) =>
                      _onVisibilityChanged('experience', i.visibleFraction),
                  child: ExperienceSection(scrollController: _scrollController),
                ),
                SizedBox(key: _sectionKeys['projects'], height: 0),
                VisibilityDetector(
                  key: const Key('vd-proj'),
                  onVisibilityChanged: (i) =>
                      _onVisibilityChanged('projects', i.visibleFraction),
                  child: ProjectsSection(activeSectionNotifier: _activeSection, scrollController: _scrollController),
                ),
                SizedBox(key: _sectionKeys['skills'], height: 0),
                VisibilityDetector(
                  key: const Key('vd-skills'),
                  onVisibilityChanged: (i) =>
                      _onVisibilityChanged('skills', i.visibleFraction),
                  child: SkillsSection(activeSectionNotifier: _activeSection, scrollController: _scrollController),
                ),
                SizedBox(key: _sectionKeys['ai'], height: 0),
                VisibilityDetector(
                  key: const Key('vd-ai'),
                  onVisibilityChanged: (i) =>
                      _onVisibilityChanged('ai', i.visibleFraction),
                  child: AiSection(activeSectionNotifier: _activeSection, scrollController: _scrollController),
                ),
                SizedBox(key: _sectionKeys['contact'], height: 0),
                VisibilityDetector(
                  key: const Key('vd-contact'),
                  onVisibilityChanged: (i) =>
                      _onVisibilityChanged('contact', i.visibleFraction),
                  child: ContactSection(scrollController: _scrollController),
                ),
              ],
            ),
          ),

          // Fixed navbar overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppNavbar(
              sectionKeys: _sectionKeys,
              scrollController: _scrollController,
              activeSectionNotifier: _activeSection,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer() {
    const navItems = [
      ('About', 'about'),
      ('Experience', 'experience'),
      ('Projects', 'projects'),
      ('Skills', 'skills'),
      ('AI Tools', 'ai'),
      ('Contact', 'contact'),
    ];

    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ShaderMask(
                    shaderCallback: (b) =>
                        AppColors.primaryGradient.createShader(b),
                    child: const Text(
                      'GH.',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Gaurav Hada',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(height: 1, color: AppColors.border),
              const SizedBox(height: 24),
              ...navItems.map(
                (item) => GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Future.delayed(
                      const Duration(milliseconds: 300),
                      () => _scrollTo(item.$2),
                    );
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: AppColors.border, width: 0.5),
                        ),
                      ),
                      child: Text(
                        item.$1,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(
                    const Duration(milliseconds: 300),
                    () => _scrollTo('contact'),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withAlpha(60),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Hire Me',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
