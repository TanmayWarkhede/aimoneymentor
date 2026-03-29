import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../services/financial_data_service.dart';
import '../../models/models.dart';
import '../../widgets/market_ticker.dart';
import '../../widgets/quick_stats_card.dart';
import '../../widgets/feature_grid.dart';
import '../../widgets/news_feed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MarketData> _marketData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await FinancialDataService.fetchMarketIndices();
    if (mounted) {
      setState(() {
        _marketData = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppTheme.primaryGreen,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(child: _buildMarketTicker()),
            SliverToBoxAdapter(child: _buildWelcomeCard()),
            SliverToBoxAdapter(child: _buildMoneyHealthBanner()),
            SliverToBoxAdapter(child: _buildFeatureGrid()),
            SliverToBoxAdapter(child: _buildQuickStats()),
            SliverToBoxAdapter(child: _buildMarketSection()),
            SliverToBoxAdapter(child: _buildFinancialTipCard()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      snap: true,
      backgroundColor: AppTheme.bgWhite,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppGradients.greenGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('₹', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ET Money Mentor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              Text('AI Financial Advisor', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontFamily: 'DMSans')),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: AppTheme.textPrimary),
          onPressed: () {},
        ),
        IconButton(
          icon: const CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.primaryGreen,
            child: Text('R', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildMarketTicker() {
    if (_isLoading || _marketData.isEmpty) {
      return const SizedBox(height: 0);
    }
    return MarketTicker(marketData: _marketData);
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.greenGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Morning, Rahul! ☀️',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'DMSans')),
                  SizedBox(height: 4),
                  Text('Net Worth', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  Text('₹12,45,800',
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700, fontFamily: 'Sora')),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text('+12.4% YTD', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          Row(
            children: [
              const Text('FIRE Progress', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const Spacer(),
              const Text('34% to ₹3.6Cr target', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.34,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 4),
          Text('₹15.8L saved · ₹20,000/month SIP',
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontFamily: 'DMSans')),
        ],
      ),
    );
  }

  Widget _buildMoneyHealthBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgWhite,
        borderRadius: BorderRadius.circular(16),
        border: const Border(left: BorderSide(color: AppTheme.goldAccent, width: 4)),
      ),
      child: Row(
        children: [
          const Text('⚡', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Money Health Score: 68/100',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text('2 areas need attention — Insurance & Emergency Fund',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'DMSans')),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.go('/money-health'),
            child: const Text('Fix Now →', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      _Feature('🔥', 'FIRE Planner', 'Retire early roadmap', AppTheme.accentOrange, '/fire-planner'),
      _Feature('❤️', 'Money Health', 'Score & improve', AppTheme.error, '/money-health'),
      _Feature('🎯', 'Life Events', 'Bonus, baby, marriage', AppTheme.accentBlue, '/life-events'),
      _Feature('💰', 'Tax Wizard', 'Save max tax', AppTheme.goldAccent, '/tax-wizard'),
      _Feature('👫', 'Couples Plan', 'Joint finances', AppColors.purple, '/couples-planner'),
      _Feature('📊', 'MF X-Ray', 'Portfolio analysis', AppTheme.primaryGreen, '/mf-xray'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text('All Tools', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.95,
            children: features.map((f) => _buildFeatureCard(f)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(_Feature feature) {
    return GestureDetector(
      onTap: () => context.go(feature.route),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.bgWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: feature.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(feature.emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(height: 8),
            Text(feature.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.2)),
            const SizedBox(height: 2),
            Text(feature.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: AppTheme.textLight, fontFamily: 'DMSans'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text('This Month', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildStatCard('💰', 'Invested', '₹20,000', '+₹2,000 vs last month', AppTheme.primaryGreen),
              const SizedBox(width: 12),
              _buildStatCard('📈', 'Returns', '₹18,450', '+3.2% this month', AppTheme.accentBlue),
              const SizedBox(width: 12),
              _buildStatCard('💸', 'Tax Saved', '₹12,500', '₹37,500 left to save', AppTheme.goldAccent),
              const SizedBox(width: 12),
              _buildStatCard('🏦', 'Emergency', '₹1.8L', '3.6 months covered', AppTheme.accentOrange),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String emoji, String label, String value, String subtitle, Color color) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'DMSans')),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: AppTheme.textLight, fontSize: 10, fontFamily: 'DMSans')),
        ],
      ),
    );
  }

  Widget _buildMarketSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Markets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              TextButton(onPressed: () {}, child: const Text('See All →')),
            ],
          ),
        ),
        if (_isLoading)
          const Center(child: CircularProgressIndicator(strokeWidth: 2))
        else
          ..._marketData.take(3).map((data) => _buildMarketRow(data)),
      ],
    );
  }

  Widget _buildMarketRow(MarketData data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.bgWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (data.isPositive ? AppTheme.success : AppTheme.error).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                data.name.substring(0, 2),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: data.isPositive ? AppTheme.success : AppTheme.error,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(data.exchange, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.price > 1000
                    ? data.price.toStringAsFixed(2)
                    : '₹${data.price.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (data.isPositive ? AppTheme.success : AppTheme.error).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${data.isPositive ? '+' : ''}${data.changePercent.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: data.isPositive ? AppTheme.success : AppTheme.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialTipCard() {
    final tips = [
      _Tip('💡', 'Increase SIP by 10% this year', 'A 10% SIP step-up can increase your corpus by 35% over 20 years vs a flat SIP.', AppTheme.primaryGreen),
      _Tip('⚡', 'Direct plans save 1% yearly', 'Switch from regular to direct mutual funds. On ₹10L, that\'s ₹10,000 saved annually.', AppTheme.accentBlue),
      _Tip('🎯', 'NPS gives extra ₹50,000 deduction', 'Invest ₹50,000 in NPS Tier 1 under 80CCD(1B) for tax savings of ₹15,600 if in 30% slab.', AppTheme.goldAccent),
    ];

    final tip = tips[DateTime.now().day % tips.length];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: tip.color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tip.color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tip.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💚 Daily Tip', style: TextStyle(
                  color: AppTheme.textSecondary, fontSize: 11, fontFamily: 'DMSans',
                  fontWeight: FontWeight.w600,
                )),
                const SizedBox(height: 4),
                Text(tip.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                Text(tip.body, style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13, height: 1.5, fontFamily: 'DMSans',
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  final String emoji, name, subtitle, route;
  final Color color;
  const _Feature(this.emoji, this.name, this.subtitle, this.color, this.route);
}

class _Tip {
  final String emoji, title, body;
  final Color color;
  const _Tip(this.emoji, this.title, this.body, this.color);
}

class AppColors {
  static const Color purple = Color(0xFF7C3AED);
}
