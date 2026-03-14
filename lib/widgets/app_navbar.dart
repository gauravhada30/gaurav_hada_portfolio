import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';
import '../utils/responsive.dart';

class AppNavbar extends StatefulWidget {
  final Map<String, GlobalKey> sectionKeys;
  final ScrollController scrollController;
  final ValueNotifier<String>? activeSectionNotifier;

  const AppNavbar({
    super.key,
    required this.sectionKeys,
    required this.scrollController,
    this.activeSectionNotifier,
  });

  @override
  State<AppNavbar> createState() => _AppNavbarState();
}

class _AppNavbarState extends State<AppNavbar> {
  bool _isScrolled = false;

  final List<_NavItem> _navItems = const [
    _NavItem('About', 'about'),
    _NavItem('Experience', 'experience'),
    _NavItem('Projects', 'projects'),
    _NavItem('Skills', 'skills'),
    _NavItem('AI Tools', 'ai'),
    _NavItem('Contact', 'contact'),
  ];

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = widget.scrollController.offset > 30;
    if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: _isScrolled
            ? AppColors.surface.withAlpha(220)
            : Colors.transparent,
        border: _isScrolled
            ? const Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              )
            : null,
        boxShadow: _isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withAlpha(80),
                  blurRadius: 30,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 14),
        child: Row(
          children: [
            // Logo
            GestureDetector(
              onTap: () => _scrollTo('home'),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (b) =>
                          AppColors.primaryGradient.createShader(b),
                      child: const Text(
                        'GH',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const Text(
                      '.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 1,
                      height: 16,
                      color: AppColors.border,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Gaurav Hada',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (isMobile) _buildMobileMenu(context) else _buildDesktopMenu(),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.3);
  }

  Widget _buildDesktopMenu() {
    return Row(
      children: [
        if (widget.activeSectionNotifier != null)
          ValueListenableBuilder<String>(
            valueListenable: widget.activeSectionNotifier!,
            builder: (context, activeSection, child) {
              return Row(
                children: _navItems
                    .map(
                      (item) => _NavButton(
                        item: item,
                        isActive: activeSection == item.key,
                        onTap: () => _scrollTo(item.key),
                      ),
                    )
                    .toList(),
              );
            },
          )
        else
          ..._navItems.map(
            (item) => _NavButton(
              item: item,
              isActive: false,
              onTap: () => _scrollTo(item.key),
            ),
          ),
        const SizedBox(width: 20),
        _HireMeButton(onTap: () => _scrollTo('contact')),
      ],
    );
  }

  Widget _buildMobileMenu(BuildContext context) {
    return Builder(
      builder: (ctx) => GestureDetector(
        onTap: () => Scaffold.of(ctx).openEndDrawer(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
            color: AppColors.surface,
          ),
          child: const Icon(
            Icons.menu_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _HireMeButton extends StatefulWidget {
  final VoidCallback onTap;
  const _HireMeButton({required this.onTap});

  @override
  State<_HireMeButton> createState() => _HireMeButtonState();
}

class _HireMeButtonState extends State<_HireMeButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
          decoration: BoxDecoration(
            gradient: _hovered ? AppColors.primaryGradient : null,
            color: _hovered ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: _hovered ? Colors.transparent : AppColors.gold.withAlpha(150),
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.gold.withAlpha(60),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Text(
            'Hire Me',
            style: TextStyle(
              color: _hovered ? Colors.black : AppColors.gold,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String key;
  const _NavItem(this.label, this.key);
}

class _NavButton extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;
  const _NavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.item.label,
                style: TextStyle(
                  color: (widget.isActive || _hovered)
                      ? AppColors.gold
                      : AppColors.textSecondary,
                  fontWeight:
                      widget.isActive ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: (widget.isActive || _hovered) ? 18 : 0,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
