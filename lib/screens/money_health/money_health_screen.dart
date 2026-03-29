import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../services/financial_data_service.dart';
import '../../models/models.dart';

class MoneyHealthScreen extends StatefulWidget {
  const MoneyHealthScreen({super.key});

  @override
  State<MoneyHealthScreen> createState() => _MoneyHealthScreenState();
}

class _MoneyHealthScreenState extends State<MoneyHealthScreen> {
  bool _showResults = false;
  MoneyHealthScore? _score;

  // Form values
  double _monthlyIncome = 100000;
  double _monthlyExpenses = 60000;
  double _emergencyFund = 120000;
  double _lifeInsurance = 5000000;
  double _healthInsurance = 500000;
  double _totalInvestments = 1000000;
  double _totalDebt = 500000;
  double _age = 30;
  double _retirementCorpus = 500000;
  double _taxSavings80C = 100000;

  void _calculateScore() {
    final score = FinancialDataService.calculateMoneyHealthScore(
      monthlyIncome: _monthlyIncome,
      monthlyExpenses: _monthlyExpenses,
      emergencyFund: _emergencyFund,
      totalInsuranceCover: _lifeInsurance + _healthInsurance,
      totalInvestments: _totalInvestments,
      totalDebt: _totalDebt,
      age: _age,
      retirementCorpus: _retirementCorpus,
      taxSavings: _taxSavings80C,
    );

    setState(() {
      _score = score;
      _showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: const Text('❤️ Money Health Score'),
        backgroundColor: AppTheme.bgWhite,
        actions: [
          if (_showResults)
            TextButton(
              onPressed: () => setState(() => _showResults = false),
              child: const Text('Retake'),
            ),
        ],
      ),
      body: _showResults && _score != null ? _buildResults() : _buildQuestionnaire(),
    );
  }

  Widget _buildQuestionnaire() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIntroCard(),
          const SizedBox(height: 16),
          _buildInputSection('💵 Income & Expenses', [
            _buildInput('Monthly Income', _monthlyIncome, (v) => setState(() => _monthlyIncome = v)),
            const SizedBox(height: 12),
            _buildInput('Monthly Expenses', _monthlyExpenses, (v) => setState(() => _monthlyExpenses = v)),
            const SizedBox(height: 12),
            _buildInput('Emergency Fund (savings)', _emergencyFund, (v) => setState(() => _emergencyFund = v)),
          ]),
          const SizedBox(height: 16),
          _buildInputSection('🛡️ Insurance Coverage', [
            _buildInput('Life Insurance Sum Assured', _lifeInsurance, (v) => setState(() => _lifeInsurance = v)),
            const SizedBox(height: 12),
            _buildInput('Health Insurance Cover', _healthInsurance, (v) => setState(() => _healthInsurance = v)),
          ]),
          const SizedBox(height: 16),
          _buildInputSection('📈 Investments & Debt', [
            _buildInput('Total Investments (MF, stocks, FD)', _totalInvestments,
                (v) => setState(() => _totalInvestments = v)),
            const SizedBox(height: 12),
            _buildInput('Total Outstanding Debt (loans, CC)', _totalDebt,
                (v) => setState(() => _totalDebt = v)),
            const SizedBox(height: 12),
            _buildInput('Retirement Corpus (PF, NPS, PPF)', _retirementCorpus,
                (v) => setState(() => _retirementCorpus = v)),
          ]),
          const SizedBox(height: 16),
          _buildInputSection('💰 Tax & Profile', [
            _buildInput('80C Investments This Year', _taxSavings80C, (v) => setState(() => _taxSavings80C = v)),
            const SizedBox(height: 12),
            _buildSlider('Your Age', _age, 20, 60, (v) => setState(() => _age = v)),
          ]),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calculateScore,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Calculate My Money Health Score', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFF97316)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('❤️', style: TextStyle(fontSize: 36)),
          SizedBox(height: 8),
          Text('Money Health Checkup', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('Answer 10 questions in 5 minutes. Get a score across 6 dimensions of financial health.',
              style: TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'DMSans', height: 1.5)),
          SizedBox(height: 12),
          Row(
            children: [
              _ScoreDimension('Emergency'),
              SizedBox(width: 6),
              _ScoreDimension('Insurance'),
              SizedBox(width: 6),
              _ScoreDimension('Investments'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(String title, List<Widget> children) {
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
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInput(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontFamily: 'DMSans')),
        const SizedBox(height: 6),
        TextField(
          controller: TextEditingController(text: value.toStringAsFixed(0)),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(prefixText: '₹ '),
          onChanged: (v) {
            final parsed = double.tryParse(v);
            if (parsed != null) onChanged(parsed);
          },
        ),
      ],
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            Text('${value.round()} yrs', style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primaryGreen)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildResults() {
    final score = _score!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildOverallScore(score),
          const SizedBox(height: 16),
          _buildScoreRadar(score),
          const SizedBox(height: 16),
          _buildDimensionBreakdown(score),
          const SizedBox(height: 16),
          _buildImprovementPlan(score),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOverallScore(MoneyHealthScore score) {
    final overall = score.overallScore;
    final color = overall >= 80 ? AppTheme.success : overall >= 65 ? AppTheme.primaryGreen : overall >= 45 ? AppTheme.warning : AppTheme.error;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.bgWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          Text(score.scoreEmoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('Your Money Health Score',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, fontFamily: 'DMSans')),
          const SizedBox(height: 8),
          Text('${overall.round()}/100',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: color)),
          Text(score.scoreGrade,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getScoreMessage(overall),
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontSize: 13, fontFamily: 'DMSans', height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRadar(MoneyHealthScore score) {
    final data = [
      score.emergencyScore,
      score.insuranceScore,
      score.investmentScore,
      score.debtScore,
      score.taxScore,
      score.retirementScore,
    ];

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
          const Text('📊 Score Breakdown', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 16),
          ...[ 
            _ScoreBar('🏦 Emergency Fund', score.emergencyScore, AppTheme.accentBlue),
            _ScoreBar('🛡️ Insurance', score.insuranceScore, AppTheme.error),
            _ScoreBar('📈 Investments', score.investmentScore, AppTheme.primaryGreen),
            _ScoreBar('💳 Debt Health', score.debtScore, AppTheme.accentOrange),
            _ScoreBar('💰 Tax Efficiency', score.taxScore, AppTheme.goldAccent),
            _ScoreBar('🏖️ Retirement', score.retirementScore, Color(0xFF7C3AED)),
          ].map((s) => _buildScoreBarWidget(s)),
        ],
      ),
    );
  }

  Widget _buildScoreBarWidget(_ScoreBar s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(s.label, style: const TextStyle(fontSize: 13, fontFamily: 'DMSans')),
              Row(
                children: [
                  Text('${s.score.round()}%',
                      style: TextStyle(fontWeight: FontWeight.w700, color: s.color, fontSize: 14)),
                  const SizedBox(width: 4),
                  Icon(
                    s.score >= 70 ? Icons.check_circle : s.score >= 40 ? Icons.warning_amber : Icons.cancel,
                    size: 16,
                    color: s.score >= 70 ? AppTheme.success : s.score >= 40 ? AppTheme.warning : AppTheme.error,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: s.score / 100,
              backgroundColor: s.color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(s.color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDimensionBreakdown(MoneyHealthScore score) {
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
          const Text('🔍 What Each Score Means', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 16),
          _buildDimension('Emergency Fund', score.emergencyScore,
              score.emergencyScore >= 70
                  ? 'Great! You have sufficient emergency coverage.'
                  : 'Need: 6 months expenses. Currently: ${(score.emergencyScore / 100 * 6).toStringAsFixed(1)} months'),
          _buildDimension('Life Insurance', score.insuranceScore,
              score.insuranceScore >= 70
                  ? 'Well covered. Your family is protected.'
                  : 'Need: 10x annual income. Increase your term cover.'),
          _buildDimension('Investment Health', score.investmentScore,
              score.investmentScore >= 70
                  ? 'Good savings rate! Keep increasing SIP annually.'
                  : 'Target: Save & invest 30%+ of income. Start SIP today.'),
          _buildDimension('Debt Health', score.debtScore,
              score.debtScore >= 70
                  ? 'Low debt burden. Keep it this way!'
                  : 'Debt exceeds 40% of income. Prioritize debt repayment.'),
          _buildDimension('Tax Efficiency', score.taxScore,
              score.taxScore >= 70
                  ? '80C fully utilized. Explore NPS for more savings.'
                  : 'Not maximizing 80C. Invest ₹${(150000 - _taxSavings80C).toStringAsFixed(0)} more in ELSS/PPF.'),
          _buildDimension('Retirement Readiness', score.retirementScore,
              score.retirementScore >= 70
                  ? 'On track for retirement. Review annually.'
                  : 'Retirement corpus needs boosting. Increase NPS/PPF contributions.'),
        ],
      ),
    );
  }

  Widget _buildDimension(String title, double score, String message) {
    final color = score >= 70 ? AppTheme.success : score >= 40 ? AppTheme.warning : AppTheme.error;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            score >= 70 ? Icons.check_circle : score >= 40 ? Icons.info : Icons.warning,
            color: color, size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 2),
                Text(message, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4, fontFamily: 'DMSans')),
              ],
            ),
          ),
          Text('${score.round()}', style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildImprovementPlan(MoneyHealthScore score) {
    final actions = <String>[];

    if (score.emergencyScore < 70) {
      final target = _monthlyExpenses * 6;
      final gap = target - _emergencyFund;
      actions.add('Build emergency fund: Invest ₹${(gap / 6).toStringAsFixed(0)}/month in liquid funds for 6 months');
    }
    if (score.insuranceScore < 70) {
      actions.add('Buy term insurance: ₹${(_monthlyIncome * 120 / 100000).toStringAsFixed(0)}L cover at ~₹800-1,200/month premium');
    }
    if (score.investmentScore < 70) {
      final needed = _monthlyIncome * 0.30;
      actions.add('Increase SIP: Invest ₹${needed.toStringAsFixed(0)}/month (30% of income) in diversified mutual funds');
    }
    if (score.debtScore < 70) {
      actions.add('Debt repayment: Use avalanche method — pay highest interest debt first (credit card > personal loan)');
    }
    if (score.taxScore < 70) {
      final gap = 150000 - _taxSavings80C;
      actions.add('Tax saving: Invest ₹${gap.toStringAsFixed(0)} in ELSS to complete 80C — saves up to ₹${(gap * 0.30).toStringAsFixed(0)} tax');
    }
    if (score.retirementScore < 70) {
      actions.add('Retirement boost: Open NPS account, invest ₹50,000/year for extra 80CCD(1B) deduction + long-term growth');
    }

    if (actions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            Text('🎉', style: TextStyle(fontSize: 28)),
            SizedBox(width: 12),
            Expanded(
              child: Text('Excellent financial health! Keep up the great work and review quarterly.',
                  style: TextStyle(fontSize: 14, fontFamily: 'DMSans', height: 1.4)),
            ),
          ],
        ),
      );
    }

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
          const Text('🚀 Your Improvement Plan', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 4),
          const Text('Do these in order for maximum impact',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'DMSans')),
          const SizedBox(height: 12),
          ...actions.asMap().entries.map((e) => _buildActionItem(e.key + 1, e.value)),
        ],
      ),
    );
  }

  Widget _buildActionItem(int num, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('$num', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(action, style: const TextStyle(fontSize: 13, fontFamily: 'DMSans', height: 1.4)),
          ),
        ],
      ),
    );
  }

  String _getScoreMessage(double score) {
    if (score >= 80) return 'Outstanding! Your finances are in excellent shape. You\'re well on track for a secure future.';
    if (score >= 65) return 'Good work! A few tweaks in insurance and emergency fund will make your finances rock-solid.';
    if (score >= 45) return 'Fair foundation. Focus on emergency fund and insurance first — these protect everything else.';
    return 'Needs urgent attention. Let\'s build your financial safety net step by step. Small steps make big differences!';
  }
}

class _ScoreDimension extends StatelessWidget {
  final String label;
  const _ScoreDimension(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'DMSans')),
    );
  }
}

class _ScoreBar {
  final String label;
  final double score;
  final Color color;
  const _ScoreBar(this.label, this.score, this.color);
}
