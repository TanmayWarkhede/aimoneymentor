import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../services/financial_data_service.dart';

class MfXrayScreen extends StatefulWidget {
  const MfXrayScreen({super.key});

  @override
  State<MfXrayScreen> createState() => _MfXrayScreenState();
}

class _MfXrayScreenState extends State<MfXrayScreen> {
  bool _showResults = false;
  bool _isLoading = false;
  String _searchQuery = '';
  List<Map<String, dynamic>> _searchResults = [];
  List<_PortfolioEntry> _portfolio = [];

  // Demo portfolio
  final List<_PortfolioEntry> _demoPortfolio = [
    _PortfolioEntry('Axis Bluechip Fund - Direct Growth', 'Large Cap', 50000, 72340, 12.5, 0.54, 119551),
    _PortfolioEntry('Parag Parikh Flexi Cap - Direct', 'Flexi Cap', 100000, 158920, 18.2, 0.63, 125354),
    _PortfolioEntry('Mirae Asset Large Cap - Direct', 'Large Cap', 75000, 102450, 14.6, 0.51, 120503),
    _PortfolioEntry('HDFC Mid-Cap Opp - Direct', 'Mid Cap', 30000, 52100, 22.1, 0.82, 119598),
    _PortfolioEntry('Canara Robeco Small Cap - Direct', 'Small Cap', 20000, 38900, 25.8, 0.75, 120828),
  ];

  Future<void> _searchFunds(String query) async {
    if (query.isEmpty) return;
    setState(() => _isLoading = true);
    final results = await FinancialDataService.searchMutualFunds(query);
    setState(() {
      _searchResults = results.take(8).toList();
      _isLoading = false;
    });
  }

  void _loadDemoPortfolio() {
    setState(() {
      _portfolio = List.from(_demoPortfolio);
      _showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: const Text('📊 MF Portfolio X-Ray'),
        backgroundColor: AppTheme.bgWhite,
        actions: [
          if (_showResults)
            TextButton(onPressed: () => setState(() => _showResults = false), child: const Text('Edit')),
        ],
      ),
      body: _showResults ? _buildResults() : _buildPortfolioBuilder(),
    );
  }

  Widget _buildPortfolioBuilder() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHero(),
          const SizedBox(height: 16),
          _buildUploadOptions(),
          const SizedBox(height: 16),
          _buildManualSearch(),
          if (_portfolio.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildPortfolioList(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() => _showResults = true),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text('Analyze ${_portfolio.length} Funds 🔍', style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.greenGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📊 Portfolio X-Ray', style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'DMSans')),
          SizedBox(height: 4),
          Text('Deep dive into\nyour MF portfolio', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, height: 1.2)),
          SizedBox(height: 8),
          Text('Get XIRR, overlap analysis, expense ratio drag, and AI rebalancing plan in seconds.',
              style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'DMSans', height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildUploadOptions() {
    return Row(
      children: [
        Expanded(child: _buildUploadCard('📄', 'Upload CAMS\nStatement', 'Auto-import all funds', () {})),
        const SizedBox(width: 12),
        Expanded(child: _buildUploadCard('📁', 'Upload KFintech\nStatement', 'Auto-import all funds', () {})),
        const SizedBox(width: 12),
        Expanded(child: _buildUploadCard('🎭', 'Try Demo\nPortfolio', 'See sample X-Ray', _loadDemoPortfolio)),
      ],
    );
  }

  Widget _buildUploadCard(String emoji, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.bgWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11, height: 1.3)),
            const SizedBox(height: 2),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 9, fontFamily: 'DMSans')),
          ],
        ),
      ),
    );
  }

  Widget _buildManualSearch() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🔍 Search & Add Funds Manually', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TextField(
            onChanged: (v) {
              _searchQuery = v;
              if (v.length >= 3) _searchFunds(v);
            },
            decoration: InputDecoration(
              hintText: 'Search fund name (e.g. Axis Bluechip)',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _isLoading ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
              ) : null,
            ),
          ),
          if (_searchResults.isNotEmpty) ...[
            const SizedBox(height: 8),
            ..._searchResults.map((fund) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(fund['schemeName'] ?? '', style: const TextStyle(fontSize: 13)),
              subtitle: Text('Code: ${fund['schemeCode'] ?? ''}', style: const TextStyle(fontSize: 11)),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle_outline, color: AppTheme.primaryGreen),
                onPressed: () {
                  setState(() {
                    _portfolio.add(_PortfolioEntry(
                      fund['schemeName'] ?? 'Unknown Fund',
                      'Equity',
                      50000,
                      65000,
                      12.5,
                      0.65,
                      int.tryParse(fund['schemeCode']?.toString() ?? '0') ?? 0,
                    ));
                    _searchResults.clear();
                  });
                },
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildPortfolioList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📋 Your Portfolio (${_portfolio.length} funds)', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ..._portfolio.map((fund) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text(fund.name.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primaryGreen))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fund.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('${fund.category} · ₹${_fmt(fund.invested)}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontFamily: 'DMSans')),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: AppTheme.error, size: 20),
                  onPressed: () => setState(() => _portfolio.remove(fund)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_portfolio.isEmpty) _portfolio = List.from(_demoPortfolio);

    final totalInvested = _portfolio.fold(0.0, (sum, f) => sum + f.invested);
    final totalCurrent = _portfolio.fold(0.0, (sum, f) => sum + f.currentValue);
    final overallGain = totalCurrent - totalInvested;
    final overallXIRR = _portfolio.fold(0.0, (sum, f) => sum + f.xirr) / _portfolio.length;
    final avgExpense = _portfolio.fold(0.0, (sum, f) => sum + f.expenseRatio) / _portfolio.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPortfolioSummary(totalInvested, totalCurrent, overallGain, overallXIRR, avgExpense),
          const SizedBox(height: 16),
          _buildCategoryChart(),
          const SizedBox(height: 16),
          _buildFundWiseBreakdown(),
          const SizedBox(height: 16),
          _buildOverlapAnalysis(),
          const SizedBox(height: 16),
          _buildExpenseRatioDrag(totalCurrent, avgExpense),
          const SizedBox(height: 16),
          _buildRebalancingPlan(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPortfolioSummary(double invested, double current, double gain, double xirr, double expense) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.greenGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📊 Portfolio Summary', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSumStat('Invested', '₹${_fmt(invested)}', Colors.white),
              _buildSumStat('Current Value', '₹${_fmt(current)}', Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildSumStat('Total Gain', '₹${_fmt(gain)} (${(gain / invested * 100).toStringAsFixed(1)}%)', gain >= 0 ? const Color(0xFF86EFAC) : Colors.red[200]!),
              _buildSumStat('XIRR', '${xirr.toStringAsFixed(1)}%/yr', const Color(0xFF86EFAC)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSumStat(String label, String value, Color valueColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11, fontFamily: 'DMSans')),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w700, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildCategoryChart() {
    // Calculate category allocation
    final Map<String, double> categories = {};
    for (final f in _portfolio) {
      categories[f.category] = (categories[f.category] ?? 0) + f.currentValue;
    }
    final total = categories.values.fold(0.0, (a, b) => a + b);

    final colors = [AppTheme.primaryGreen, AppTheme.accentBlue, AppTheme.accentOrange, AppTheme.goldAccent, Color(0xFF7C3AED)];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🥧 Asset Category Allocation', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: categories.entries.toList().asMap().entries.map((e) {
                  final pct = e.value.value / total * 100;
                  return PieChartSectionData(
                    value: e.value.value,
                    title: '${pct.toStringAsFixed(0)}%',
                    color: colors[e.key % colors.length],
                    radius: 80,
                    titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                  );
                }).toList(),
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: categories.entries.toList().asMap().entries.map((e) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: colors[e.key % colors.length], shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text('${e.value.key} (${(e.value.value / total * 100).toStringAsFixed(1)}%)', style: const TextStyle(fontSize: 11, fontFamily: 'DMSans')),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFundWiseBreakdown() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📋 Fund-wise Breakdown', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 12),
          ..._portfolio.map((fund) => _buildFundRow(fund)),
        ],
      ),
    );
  }

  Widget _buildFundRow(_PortfolioEntry fund) {
    final gain = fund.currentValue - fund.invested;
    final gainPct = gain / fund.invested * 100;
    final isGain = gain >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(fund.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(fund.category, style: const TextStyle(fontSize: 10, color: AppTheme.accentBlue, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMiniStat('Invested', '₹${_fmt(fund.invested)}'),
              _buildMiniStat('Current', '₹${_fmt(fund.currentValue)}'),
              _buildMiniStat('XIRR', '${fund.xirr.toStringAsFixed(1)}%'),
              _buildMiniStat('Expense', '${fund.expenseRatio}%'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(isGain ? Icons.trending_up : Icons.trending_down, size: 14, color: isGain ? AppTheme.success : AppTheme.error),
              const SizedBox(width: 4),
              Text(
                '${isGain ? '+' : ''}₹${_fmt(gain)} (${gainPct.toStringAsFixed(1)}%)',
                style: TextStyle(color: isGain ? AppTheme.success : AppTheme.error, fontWeight: FontWeight.w600, fontSize: 12),
              ),
              const Spacer(),
              _buildRating(fund.xirr),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary, fontFamily: 'DMSans')),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildRating(double xirr) {
    final stars = xirr >= 18 ? '⭐⭐⭐' : xirr >= 13 ? '⭐⭐' : '⭐';
    return Text(stars, style: const TextStyle(fontSize: 12));
  }

  Widget _buildOverlapAnalysis() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.warning.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🔗 Fund Overlap Analysis', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 8),
          const Text('Funds with similar holdings reduce diversification benefit:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'DMSans')),
          const SizedBox(height: 12),
          _buildOverlapPair('Axis Bluechip', 'Mirae Asset Large Cap', 68.0, 'HIGH overlap — consider removing one'),
          _buildOverlapPair('Parag Parikh Flexi Cap', 'Axis Bluechip', 32.0, 'MODERATE overlap — acceptable'),
          _buildOverlapPair('HDFC Mid-Cap', 'Canara Small Cap', 15.0, 'LOW overlap — good diversification'),
          const SizedBox(height: 8),
          const Text('⚡ Recommendation: Remove either Axis Bluechip or Mirae Asset Large Cap. Replace with Index Fund for lower cost.',
              style: TextStyle(color: AppTheme.warning, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'DMSans')),
        ],
      ),
    );
  }

  Widget _buildOverlapPair(String fund1, String fund2, double overlap, String advice) {
    final color = overlap >= 60 ? AppTheme.error : overlap >= 30 ? AppTheme.warning : AppTheme.success;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.bgWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('$fund1 ↔ $fund2', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                child: Text('${overlap.toStringAsFixed(0)}%', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(advice, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontFamily: 'DMSans')),
        ],
      ),
    );
  }

  Widget _buildExpenseRatioDrag(double currentValue, double avgExpense) {
    final dragAmount = currentValue * avgExpense / 100;
    final directSaving = dragAmount * 0.4; // Avg saving by switching to direct

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💸 Expense Ratio Drag', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 12),
          _buildDragRow('Average Expense Ratio', '${avgExpense.toStringAsFixed(2)}%/year'),
          _buildDragRow('Annual Cost Drag', '₹${_fmt(dragAmount)}'),
          _buildDragRow('10-Year Compound Drag', '₹${_fmt(dragAmount * 14.5)}'),
          _buildDragRow('Potential Saving (Direct Plans)', '₹${_fmt(directSaving)}/year', isHighlight: true),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('✅ All selected funds are already Direct Plans — you\'re saving ~0.5-1% vs Regular Plans. Great!',
                style: TextStyle(fontSize: 12, color: AppTheme.success, fontFamily: 'DMSans')),
          ),
        ],
      ),
    );
  }

  Widget _buildDragRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontFamily: 'DMSans', color: AppTheme.textSecondary)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: isHighlight ? AppTheme.primaryGreen : AppTheme.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildRebalancingPlan() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentBlue.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentBlue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🤖', style: TextStyle(fontSize: 22)),
              SizedBox(width: 8),
              Text('AI Rebalancing Plan', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Based on target 60% large cap, 25% mid-small, 15% international',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'DMSans')),
          const SizedBox(height: 12),
          _buildRebalanceAction('🔴 Reduce', 'Axis Bluechip Fund', 'Overlap with Mirae Asset. Move 50% to Nifty 50 Index Fund.'),
          _buildRebalanceAction('🟡 Hold', 'Parag Parikh Flexi Cap', 'Excellent fund with global diversification. Continue SIP.'),
          _buildRebalanceAction('🟢 Increase', 'HDFC Mid-Cap Opportunities', 'Good long-term performer. Increase SIP by ₹5,000/month.'),
          _buildRebalanceAction('🟢 Add New', 'Nifty 50 Index Fund', 'Replace overlap funds. Start ₹10,000 SIP for low-cost exposure.'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.accentBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('⚠️ Don\'t sell existing units if it triggers capital gains tax. Instead, redirect new SIPs to underweight categories.',
                style: TextStyle(fontSize: 12, color: AppTheme.accentBlue, fontFamily: 'DMSans')),
          ),
        ],
      ),
    );
  }

  Widget _buildRebalanceAction(String action, String fund, String advice) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.bgWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(action, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(width: 8),
            Text(fund, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppTheme.accentBlue)),
          ]),
          const SizedBox(height: 3),
          Text(advice, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontFamily: 'DMSans')),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 10000000) return '${(v / 10000000).toStringAsFixed(1)}Cr';
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}

class _PortfolioEntry {
  final String name, category;
  final double invested, currentValue, xirr, expenseRatio;
  final int schemeCode;

  const _PortfolioEntry(this.name, this.category, this.invested, this.currentValue, this.xirr, this.expenseRatio, this.schemeCode);
}
