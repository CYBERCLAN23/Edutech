import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:educam_ai/widgets/route_transition.dart';
import 'package:educam_ai/screens/role_select_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _slides = [
    _OnboardingSlide(
      title: 'Apprenez\navec l\'IA',
      subtitle: 'Accédez à des cours personnalisés et des quiz intelligents adaptés au programme national.',
      imageUrl: 'assets/onboarding_1.png',
      backgroundColor: const Color(0xFFc4f05a),
      buttonBorderColor: const Color(0xFFa855f7),
    ),
    _OnboardingSlide(
      title: 'Votre tuteur IA\n24h/24',
      subtitle: 'Posez vos questions à TutorBot et obtenez des explications claires instantanément.',
      imageUrl: 'assets/onboarding_2.png',
      backgroundColor: const Color(0xFFE0F2FE),
      buttonBorderColor: const Color(0xFF4b41e1),
      hasCurvedBackground: true,
    ),
    _OnboardingSlide(
      title: 'Votre réussite\ncommence ici',
      subtitle: 'Rejoignez des milliers d\'élèves camerounais et boostez vos résultats dès aujourd\'hui.',
      imageUrl: 'assets/onboarding_3.png',
      backgroundColor: const Color(0xFF00d2ff).withOpacity(0.2),
      buttonBorderColor: const Color(0xFF00d2ff),
      hasFloatingIcons: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _slides.length,
            itemBuilder: (context, index) => _SlideContent(slide: _slides[index]),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 48,
            left: 0,
            right: 0,
            child: _ActionButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                if (_currentPage < _slides.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.of(context).pushReplacement(RouteTransition.fadeThrough(const RoleSelectScreen()));
                }
              },
              isLastSlide: _currentPage == _slides.length - 1,
              borderColor: _slides[_currentPage].buttonBorderColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '9:41',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Row(
          children: [
            Container(
              width: 16,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 16,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 24,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OnboardingSlide {
  final String title;
  final String subtitle;
  final String imageUrl;
  final Color backgroundColor;
  final Color buttonBorderColor;
  final bool hasCurvedBackground;
  final bool hasFloatingIcons;

  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.backgroundColor,
    required this.buttonBorderColor,
    this.hasCurvedBackground = false,
    this.hasFloatingIcons = false,
  });
}

class _SlideContent extends StatelessWidget {
  final _OnboardingSlide slide;

  const _SlideContent({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          if (slide.hasCurvedBackground)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.55,
              child: ClipPath(
                clipper: _CurvedBackgroundClipper(),
                child: Container(
                  color: slide.backgroundColor,
                ),
              ),
            )
          else if (slide.hasFloatingIcons)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.55,
              child: Container(
                decoration: BoxDecoration(
                  color: slide.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(200),
                    bottomRight: Radius.circular(200),
                  ),
                ),
              ),
            )
          else
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              left: -20,
              right: -20,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Transform.rotate(
                angle: -0.17,
                child: Container(
                  decoration: BoxDecoration(
                    color: slide.backgroundColor,
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
              ),
            ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    slide.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      height: 1.2,
                      letterSpacing: -0.02,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    slide.subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF45484a),
                      height: 1.5,
                    ),
                  ),
                ),
                const Spacer(),
                if (slide.hasFloatingIcons) ...[
                  _FloatingIcon(
                    icon: Icons.school,
                    color: const Color(0xFF00d2ff),
                    top: 0,
                    left: 32,
                    animationDuration: 3,
                  ),
                  _FloatingIcon(
                    icon: Icons.menu_book,
                    color: const Color(0xFF0099cc),
                    bottom: 40,
                    right: 16,
                    animationDuration: 4,
                    delay: 1,
                  ),
                  _FloatingIcon(
                    icon: Icons.star,
                    color: const Color(0xFFFACC15),
                    top: null,
                    left: null,
                    right: 8,
                    bottom: 120,
                    animationDuration: 2,
                    isPulse: true,
                  ),
                ],
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Image.asset(
                        slide.imageUrl,
                        width: 280,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            size: 100,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CurvedBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.15);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _FloatingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final int animationDuration;
  final int delay;
  final bool isPulse;

  const _FloatingIcon({
    required this.icon,
    required this.color,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.animationDuration = 3,
    this.delay = 0,
    this.isPulse = false,
  });

  @override
  State<_FloatingIcon> createState() => _FloatingIconState();
}

class _FloatingIconState extends State<_FloatingIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.animationDuration),
      vsync: this,
    );
    Future.delayed(Duration(seconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      bottom: widget.bottom,
      left: widget.left,
      right: widget.right,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, widget.isPulse ? 0 : _controller.value * 20),
            child: Opacity(
              opacity: widget.isPulse ? 0.6 + _controller.value * 0.4 : 0.8,
              child: Icon(
                widget.icon,
                color: widget.color,
                size: widget.isPulse ? 24 : (widget.icon == Icons.school ? 32 : 24),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLastSlide;
  final Color borderColor;

  const _ActionButton({
    required this.onPressed,
    required this.isLastSlide,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: isLastSlide ? null : 64,
          height: isLastSlide ? 56 : 64,
          decoration: BoxDecoration(
            color: isLastSlide ? borderColor : Colors.black,
            borderRadius: isLastSlide ? BorderRadius.circular(9999) : BorderRadius.circular(16),
          ),
          child: isLastSlide
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Commencer',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                )
              : const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 24,
                ),
        ),
      ),
    );
  }
}
