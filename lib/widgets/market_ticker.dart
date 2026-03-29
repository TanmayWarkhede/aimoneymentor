import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class MarketTicker extends StatelessWidget {
  final List<MarketData> marketData;
  const MarketTicker({super.key, required this.marketData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      color: AppTheme.textPrimary,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: marketData.length * 3,
        itemBuilder: (context, index) {
          final data = marketData[index % marketData.length];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Text(data.name, style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'DMSans')),
                const SizedBox(width: 6),
                Text(
                  data.price > 10000 ? data.price.toStringAsFixed(0) : data.price.toStringAsFixed(2),
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 4),
                Text(
                  '${data.isPositive ? '+' : ''}${data.changePercent.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: data.isPositive ? AppTheme.success : AppTheme.error,
                    fontSize: 11, fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Container(width: 1, height: 16, color: Colors.white24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class QuickStatsCard extends StatelessWidget {
  final String emoji, title, value, subtitle;
  final Color color;

  const QuickStatsCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
          Text(title, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
          Text(subtitle, style: const TextStyle(color: AppTheme.textLight, fontSize: 10)),
        ],
      ),
    );
  }
}

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class NewsFeed extends StatelessWidget {
  const NewsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
