import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../services/financial_data_service.dart';
import '../../models/models.dart';

class FirePlannerScreen extends StatefulWidget {
  const FirePlannerScreen({super.key});

  @override
  State<FirePlannerScreen> createState() => _FirePlannerScreenState();
}

class _FirePlannerScreenState extends State<FirePlannerScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form values
  double _currentAge = 28;
  double _targetRetirementAge = 45;
  double _monthlyIncome = 150000;
  double _monthlyExpenses = 80000;
  double _existingCorpus = 1000000;
  double _monthlySIP = 30000;
  double _expectedReturn = 12.0;
  double _inflationRate = 6.0;
  String _riskProfile = 'moderate';

  FirePlan? _firePlan;
  bool _showResults = false;

  void _calculateFIRE() {
    final plan = FinancialDataService.calculateFirePlan(
      currentAge: _currentAge.round(),
      targetRetirementAge: _targetRetirementAge.round(),
      monthlyExpenses: _monthlyExpenses,
      existingCorpus: _existingCorpus,
      monthlyInvestment: _monthlySIP,
      expectedReturns: _expectedReturn,
      inflationRate: _inflationRate,
    );

    setState(() {
      _firePlan = plan;
      _showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: const Text('🔥 FIRE Path Planner'),
        backgroundColor: AppTheme.bgWhite,
        actions: [
          if (_showResults)
            TextButton(
              onPressed: () => setState(() => _showResults = false),
              child: const Text('Edit'),
            ),
        ],
      ),
      body: _showResults && _firePlan != null
          ? _buildResults()
          : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroCard(),
            const SizedBox(height: 20),
            _buildSection('👤 Your Profile', [
              _buildSliderField('Current Age', _currentAge, 20, 60, 1, (v) => setState(() => _currentAge = v), suffix: ' yrs'),
              _buildSliderField('Target Retirement Age', _targetRetirementAge, 30, 70, 1,
                  (v) => setState(() => _targetRetirementAge = v.clamp(_currentAge + 1, 70)), suffix: ' yrs'),
            ]),
            const SizedBox(height: 16),
            _buildSection('💵 Income & Expenses', [
              _buildAmountField('Monthly Income', _monthlyIncome, (v) => setState(() => _monthlyIncome = v)),
              const SizedBox(height: 12),
              _buildAmountField('Monthly Expenses', _monthlyExpenses, (v) => setState(() => _monthlyExpenses = v)),
            ]),
            const SizedBox(height: 16),
            _buildSection('📈 Investment Details', [
              _buildAmountField('Existing Corpus/Investments', _existingCorpus, (v) => setState(() => _existingCorpus = v)),
              const SizedBox(height: 12),
              _buildAmountField('Monthly SIP Amount', _monthlySIP, (v) => setState(() => _monthlySIP = v)),
              const SizedBox(height: 12),
              _buildSliderField('Expected Annual Returns', _expectedReturn, 8, 18, 0.5,
                  (v) => setState(() => _expectedReturn = v), suffix: '%'),
              _buildSliderField('Inflation Rate', _inflationRate, 4, 9, 0.5,
                  (v) => setState(() => _inflationRate = v), suffix: '%'),
            ]),
            const SizedBox(height: 16),
            _buildRiskSection(),
            const SizedBox(height: 24),
            _buildSummaryPreview(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _calculateFIRE,
                icon: const Text('🔥', style: TextStyle(fontSize: 18)),
                label: const Text('Calculate My FIRE Plan'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B2B), Color(0xFFFF3D00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🔥 FIRE Calculator', style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'DMSans')),
          const SizedBox(height: 4),
          const Text('Financial Independence,\nRetire Early',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, height: 1.2)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildFireBadge('${(_targetRetirementAge - _currentAge).round()} years to FIRE'),
              const SizedBox(width: 8),
              _buildFireBadge('4% withdrawal rule'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFireBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'DMSans')),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
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
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSliderField(String label, double value, double min, double max, double step,
      ValueChanged<double> onChanged, {String suffix = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontFamily: 'DMSans')),
            Text('${value.toStringAsFixed(step < 1 ? 1 : 0)}$suffix',
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primaryGreen, fontSize: 15)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbColor: AppTheme.primaryGreen,
            activeTrackColor: AppTheme.primaryGreen,
            inactiveTrackColor: AppTheme.divider,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) / step).round(),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildAmountField(String label, double value, ValueChanged<double> onChanged) {
    final controller = TextEditingController(text: value.toStringAsFixed(0));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontFamily: 'DMSans')),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixText: '₹ ',
            prefixStyle: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primaryGreen),
            hintText: '0',
            suffixText: _formatLakh(value),
            suffixStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          onChanged: (v) {
            final parsed = double.tryParse(v.replaceAll(',', ''));
            if (parsed != null) onChanged(parsed);
          },
        ),
      ],
    );
  }

  Widget _buildRiskSection() {
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
          const Text('🎯 Risk Profile', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: ['conservative', 'moderate', 'aggressive'].map((risk) {
              final selected = _riskProfile == risk;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _riskProfile = risk),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.primaryGreen : AppTheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected ? AppTheme.primaryGreen : AppTheme.divider,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          risk == 'conservative' ? '🛡️' : risk == 'moderate' ? '⚖️' : '🚀',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          risk.substring(0, 1).toUpperCase() + risk.substring(1),
                          style: TextStyle(
                            fontSize: 11,
                            color: selected ? Colors.white : AppTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPreview() {
    final investable = _monthlyIncome - _monthlyExpenses;
    final sipRatio = investable > 0 ? (_monthlySIP / investable * 100) : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('📊', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text('Quick Preview', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          _buildPreviewRow('Investable Amount', '₹${_formatLakh(investable - _monthlySIP)} left after SIP'),
          _buildPreviewRow('Savings Rate', '${sipRatio.toStringAsFixed(1)}% of investable income'),
          _buildPreviewRow('Years to FIRE', '${(_targetRetirementAge - _currentAge).round()} years'),
          _buildPreviewRow('FIRE Age Target', '${_targetRetirementAge.round()} years old'),
        ],
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontFamily: 'DMSans')),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final plan = _firePlan!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFireResult(plan),
          const SizedBox(height: 16),
          _buildCorpusChart(plan),
          const SizedBox(height: 16),
          _buildAssetAllocation(),
          const SizedBox(height: 16),
          _buildMilestones(plan),
          const SizedBox(height: 16),
          _buildActionPlan(plan),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFireResult(FirePlan plan) {
    final achievesfire = plan.milestones.last.projectedCorpus >= plan.fireNumber;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: achievesfire
            ? AppGradients.greenGradient
            : AppGradients.orangeGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(achievesfire ? '🎉' : '⚡', style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievesfire ? 'You CAN achieve FIRE!' : 'Increase SIP to reach FIRE',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    Text(
                      achievesfire
                          ? 'At age ${plan.targetRetirementAge}, corpus: ${_formatCrore(plan.milestones.last.projectedCorpus)}'
                          : 'Need ${_formatCrore(plan.fireNumber)} but will have ${_formatCrore(plan.milestones.last.projectedCorpus)}',
                      style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13, fontFamily: 'DMSans'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildResultBadge('FIRE Number', _formatCrore(plan.fireNumber)),
              const SizedBox(width: 12),
              _buildResultBadge('Monthly Withdrawal', '₹${_formatLakh(plan.fireNumber * 0.04 / 12)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultBadge(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11, fontFamily: 'DMSans')),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildCorpusChart(FirePlan plan) {
    final spotData = plan.milestones
        .where((m) => m.year % 2 == 0 || plan.milestones.indexOf(m) == plan.milestones.length - 1)
        .take(15)
        .toList();

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
          const Text('📈 Corpus Growth Projection', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 4),
          Text('Expected ${plan.expectedReturns}% annual returns',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'DMSans')),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: plan.fireNumber / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppTheme.divider,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 55,
                      getTitlesWidget: (value, meta) => Text(
                        _formatCrore(value),
                        style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      getTitlesWidget: (value, meta) {
                        final index = value.round();
                        if (index < spotData.length) {
                          return Text('${spotData[index].age}', style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Corpus line
                  LineChartBarData(
                    spots: spotData.asMap().entries.map((e) =>
                      FlSpot(e.key.toDouble(), e.value.projectedCorpus)).toList(),
                    isCurved: true,
                    color: AppTheme.primaryGreen,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                    ),
                  ),
                  // FIRE target line
                  LineChartBarData(
                    spots: List.generate(spotData.length, (i) => FlSpot(i.toDouble(), plan.fireNumber)),
                    isCurved: false,
                    color: AppTheme.accentOrange,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    dashArray: [5, 5],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLegend(AppTheme.primaryGreen, 'Your Corpus'),
              const SizedBox(width: 16),
              _buildLegend(AppTheme.accentOrange, 'FIRE Target'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 16, height: 3, color: color, margin: const EdgeInsets.only(right: 6)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontFamily: 'DMSans')),
      ],
    );
  }

  Widget _buildAssetAllocation() {
    final allocation = FinancialDataService.recommendAssetAllocation(
      riskProfile: _riskProfile,
      age: _currentAge.round(),
    );

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
          const Text('🎯 Recommended Asset Allocation', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 4),
          Text('Based on your age (${_currentAge.round()}) & ${'$_riskProfile risk profile'}',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'DMSans')),
          const SizedBox(height: 16),
          ...allocation.entries.map((e) => _buildAllocationBar(e.key, e.value)),
        ],
      ),
    );
  }

  Widget _buildAllocationBar(String label, double percent) {
    final colors = {
      'Large Cap Equity': AppTheme.primaryGreen,
      'Mid Cap Equity': AppTheme.accentBlue,
      'Small Cap Equity': AppTheme.accentOrange,
      'International Equity': AppColors.purple,
      'Debt/Bonds': AppTheme.goldAccent,
      'Gold': Color(0xFFDAA520),
      'Cash/Liquid': AppTheme.textSecondary,
    };

    final color = colors[label] ?? AppTheme.primaryGreen;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, fontFamily: 'DMSans')),
              Text('${percent.toStringAsFixed(1)}%',
                  style: TextStyle(fontWeight: FontWeight.w600, color: color, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestones(FirePlan plan) {
    final keyMilestones = plan.milestones.where((m) => m.milestone.isNotEmpty).toList();

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
          const Text('🗺️ Your FIRE Milestones', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 16),
          ...keyMilestones.take(6).map((m) => _buildMilestoneRow(m)),
          if (keyMilestones.isEmpty)
            const Text('Keep going! Milestone markers will appear as you progress.',
                style: TextStyle(color: AppTheme.textSecondary, fontFamily: 'DMSans')),
        ],
      ),
    );
  }

  Widget _buildMilestoneRow(FireMilestone m) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('${m.age}', style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primaryGreen)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.milestone, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text('Corpus: ${_formatCrore(m.projectedCorpus)} · Year ${m.year}',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'DMSans')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionPlan(FirePlan plan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('✅ Your Action Plan', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 12),
          _buildAction('Start ₹${_formatLakh(_monthlySIP)} SIP today in diversified equity mutual funds'),
          _buildAction('Open PPF account: Invest ₹1.5L/year for Section 80C + 7.1% guaranteed returns'),
          _buildAction('Get term insurance: ₹${_formatCrore(_monthlyIncome * 120)} cover for family protection'),
          _buildAction('Build 6-month emergency fund: ₹${_formatLakh(_monthlyExpenses * 6)} in liquid funds'),
          _buildAction('Review portfolio every 6 months and rebalance if allocation drifts >5%'),
          _buildAction('Increase SIP by 10% every year to beat lifestyle inflation'),
          if (_riskProfile == 'aggressive')
            _buildAction('Consider NPS Tier 1 for additional 80CCD(1B) tax deduction of ₹50,000'),
        ],
      ),
    );
  }

  Widget _buildAction(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('→', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w700)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, fontFamily: 'DMSans', height: 1.4))),
        ],
      ),
    );
  }

  String _formatLakh(double value) {
    if (value >= 10000000) return '₹${(value / 10000000).toStringAsFixed(1)}Cr';
    if (value >= 100000) return '₹${(value / 100000).toStringAsFixed(1)}L';
    if (value >= 1000) return '₹${(value / 1000).toStringAsFixed(0)}K';
    return '₹${value.toStringAsFixed(0)}';
  }

  String _formatCrore(double value) {
    if (value >= 10000000) return '₹${(value / 10000000).toStringAsFixed(2)}Cr';
    if (value >= 100000) return '₹${(value / 100000).toStringAsFixed(1)}L';
    return '₹${value.toStringAsFixed(0)}';
  }
}

class AppColors {
  static const Color purple = Color(0xFF7C3AED);
}
