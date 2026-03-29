import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/home/home_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/onboarding/splash_screen.dart';
import '../screens/fire_planner/fire_planner_screen.dart';
import '../screens/money_health/money_health_screen.dart';
import '../screens/life_events/life_events_screen.dart';
import '../screens/tax_wizard/tax_wizard_screen.dart';
import '../screens/couples_planner/couples_planner_screen.dart';
import '../screens/mf_xray/mf_xray_screen.dart';
import '../screens/chat/ai_chat_screen.dart';
import '../screens/auth/login_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/fire-planner',
            builder: (context, state) => const FirePlannerScreen(),
          ),
          GoRoute(
            path: '/money-health',
            builder: (context, state) => const MoneyHealthScreen(),
          ),
          GoRoute(
            path: '/life-events',
            builder: (context, state) => const LifeEventsScreen(),
          ),
          GoRoute(
            path: '/tax-wizard',
            builder: (context, state) => const TaxWizardScreen(),
          ),
          GoRoute(
            path: '/couples-planner',
            builder: (context, state) => const CouplesPlannerScreen(),
          ),
          GoRoute(
            path: '/mf-xray',
            builder: (context, state) => const MfXrayScreen(),
          ),
          GoRoute(
            path: '/ai-chat',
            builder: (context, state) => const AiChatScreen(),
          ),
        ],
      ),
    ],
  );
});

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', path: '/home'),
    _NavItem(icon: Icons.local_fire_department_outlined, activeIcon: Icons.local_fire_department, label: 'FIRE', path: '/fire-planner'),
    _NavItem(icon: Icons.favorite_outline, activeIcon: Icons.favorite, label: 'Health', path: '/money-health'),
    _NavItem(icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, label: 'AI Chat', path: '/ai-chat'),
    _NavItem(icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet, label: 'Tools', path: '/tax-wizard'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            context.go(_navItems[index].path);
          },
          items: _navItems.map((item) => BottomNavigationBarItem(
            icon: Icon(item.icon),
            activeIcon: Icon(item.activeIcon),
            label: item.label,
          )).toList(),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String path;
  const _NavItem({required this.icon, required this.activeIcon, required this.label, required this.path});
}
