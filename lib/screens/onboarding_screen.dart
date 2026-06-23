import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/widgets/route_transition.dart';
import 'package:educam_ai/screens/main_shell.dart';

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
      icon: Icons.smart_toy_rounded,
      title: 'Ton professeur\nIA personnel',
      subtitle:
          'TutorBot comprend tes questions en Francais, Anglais, Fulfulde ou Ewondo. Revisions illimitees, meme sans connexion.',
      gradientColors: [EduCamColors.accent, const Color(0xFF7C3AED)],
    ),
    _OnboardingSlide(
      icon: Icons.camera_alt_rounded,
      title: 'Corrige tes devoirs\nen un clic',
      subtitle:
          'Photo de ton exercice de Maths, SVT ou Physique. Correction instantanee avec explications detaillees, comme un professeur 24h/24.',
      gradientColors: [EduCamColors.highlight, const Color(0xFFF97316)],
    ),
    _OnboardingSlide(
      icon: Icons.school_rounded,
      title: 'Pret pour le BAC\net le BEPC',
      subtitle:
          'Programme officiel camerounais, sujets d\'examen et suivi personnalise. Rejoins les 10 000+ eleves qui excellent avec EduCam.',
      gradientColors: [const Color(0xFF10B981), const Color(0xFF059669)],
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
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _slides.length,
            itemBuilder: (context, index) => _SlideContent(slide: _slides[index]),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 24,
            child: _currentPage < _slides.length - 1
                ? TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pushReplacement(RouteTransition.fadeThrough(const MainShell()));
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: EduCamColors.secondaryText,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 40,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (index) => _DotIndicator(
                      isActive: index == _currentPage,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      if (_currentPage < _slides.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.of(context).pushReplacement(RouteTransition.fadeThrough(const MainShell()));
                      }
                    },
                    child: Text(
                      _currentPage < _slides.length - 1
                          ? 'Suivant'
                          : 'Commencer',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;

  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
  });
}

class _SlideContent extends StatelessWidget {
  final _OnboardingSlide slide;

  const _SlideContent({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [EduCamColors.background, Color(0xFFF1F5F9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: slide.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: slide.gradientColors[0].withValues(alpha: 0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Icon(
                  slide.icon,
                  size: 52,
                  color: EduCamColors.surface,
                ),
              ),
              const Spacer(flex: 2),
              Text(
                slide.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: EduCamColors.primary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                slide.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: EduCamColors.secondaryText,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final bool isActive;

  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 28 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? EduCamColors.accent : EduCamColors.cardBorder,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
