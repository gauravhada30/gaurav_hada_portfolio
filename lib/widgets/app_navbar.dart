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
    final scrolled = widget.scrollController.offset > 50;
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
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _isScrolled ? Colors.white.withAlpha(240) : Colors.transparent,
        border: _isScrolled
            ? Border(bottom: BorderSide(color: AppColors.border, width: 1))
            : null,
        boxShadow: _isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
        child: Row(
          children: [
            // Logo
            GestureDetector(
              onTap: () => _scrollTo('home'),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  children: [
                    ValueListenableBuilder<String>(
                      valueListenable:
                          widget.activeSectionNotifier ?? ValueNotifier(''),
                      builder: (context, activeSection, child) {
                        return Text(
                          'Gaurav',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: activeSection == 'home'
                                ? AppColors.gold
                                : AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Hada.',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
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
        const SizedBox(width: 24),
        GestureDetector(
          onTap: () => _scrollTo('contact'),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.darkAccent,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkAccent.withAlpha(30),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'Hire Me',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
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
            color: Colors.white,
          ),
          child: const Icon(Icons.menu, color: AppColors.textPrimary, size: 20),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.item.label,
                style: TextStyle(
                  color: (widget.isActive || _hovered)
                      ? AppColors.gold
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: (widget.isActive || _hovered) ? 20 : 0,
                decoration: BoxDecoration(
                  color: AppColors.gold,
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
