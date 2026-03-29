import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      emoji: '🤖',
      title: 'Your AI Financial\nAdvisor',
      subtitle: 'Get personalized financial advice powered by AI. No more expensive advisors charging ₹25,000/year.',
      color: AppTheme.primaryGreen,
    ),
    _OnboardingPage(
      emoji: '🔥',
      title: 'Plan Your\nFIRE Journey',
      subtitle: 'Set your retirement date and let AI build a month-by-month roadmap to financial independence.',
      color: AppTheme.accentOrange,
    ),
    _OnboardingPage(
      emoji: '💰',
      title: 'Save More Tax\nEvery Year',
      subtitle: 'Upload Form 16 and AI finds every deduction you\'re missing. Average Indian saves ₹18,000 extra.',
      color: AppTheme.accentBlue,
    ),
    _OnboardingPage(
      emoji: '📊',
      title: 'X-Ray Your\nMutual Fund Portfolio',
      subtitle: 'Upload CAMS statement. Get XIRR, overlap analysis, and AI-powered rebalancing recommendations.',
      color: AppTheme.goldAccent,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_onboarded', true);
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: const Text('Skip', style: TextStyle(color: AppTheme.textSecondary)),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Dots and CTA
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Page dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? _pages[_currentPage].color
                              : AppTheme.divider,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _pages[_currentPage].color,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'Get Started Free 🚀'
                            : 'Next →',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Free forever · No hidden charges',
                    style: TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji in circle
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(page.emoji, style: const TextStyle(fontSize: 64)),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1.2,
              fontFamily: 'Sora',
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
              height: 1.6,
              fontFamily: 'DMSans',
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
