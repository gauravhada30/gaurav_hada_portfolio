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
    if (fraction > 0.3) {
      // Delay to avoid build phase errors
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
                const SizedBox(height: 70),
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
                  child: const AboutSection(),
                ),
                SizedBox(key: _sectionKeys['experience'], height: 0),
                VisibilityDetector(
                  key: const Key('vd-exp'),
                  onVisibilityChanged: (i) =>
                      _onVisibilityChanged('experience', i.visibleFraction),
                  child: const ExperienceSection(),
                ),
                SizedBox(key: _sectionKeys['projects'], height: 0),
                VisibilityDetector(
                  key: const Key('vd-proj'),
                  onVisibilityChanged: (i) =>
                      _onVisibilityChanged('projects', i.visibleFraction),
                  child: ProjectsSection(activeSectionNotifier: _activeSection),
                ),
                SizedBox(key: _sectionKeys['skills'], height: 0),
                VisibilityDetector(
                  key: const Key('vd-skills'),
                  onVisibilityChanged: (i) =>
                      _onVisibilityChanged('skills', i.visibleFraction),
                  child: SkillsSection(activeSectionNotifier: _activeSection),
                ),
                SizedBox(key: _sectionKeys['ai'], height: 0),
                VisibilityDetector(
                  key: const Key('vd-ai'),
                  onVisibilityChanged: (i) =>
                      _onVisibilityChanged('ai', i.visibleFraction),
                  child: AiSection(activeSectionNotifier: _activeSection),
                ),
                SizedBox(key: _sectionKeys['contact'], height: 0),
                VisibilityDetector(
                  key: const Key('vd-contact'),
                  onVisibilityChanged: (i) =>
                      _onVisibilityChanged('contact', i.visibleFraction),
                  child: const ContactSection(),
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
              ShaderMask(
                shaderCallback: (b) =>
                    AppColors.primaryGradient.createShader(b),
                child: const Text(
                  'GH.',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Gaurav Hada',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 32),
              Container(height: 1, color: AppColors.border),
              const SizedBox(height: 32),
              ...navItems.map(
                (item) => GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Future.delayed(
                      const Duration(milliseconds: 300),
                      () => _scrollTo(item.$2),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border, width: 0.5),
                      ),
                    ),
                    child: Text(
                      item.$1,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Hire Me',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
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
