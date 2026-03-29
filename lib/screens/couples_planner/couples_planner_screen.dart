import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CouplesPlannerScreen extends StatefulWidget {
  const CouplesPlannerScreen({super.key});

  @override
  State<CouplesPlannerScreen> createState() => _CouplesPlannerScreenState();
}

class _CouplesPlannerScreenState extends State<CouplesPlannerScreen> {
  bool _showResults = false;

  // Partner 1
  double _p1Income = 150000;
  double _p1Basic = 75000;
  double _p1HRA = 30000;
  double _p1Investments = 500000;
  bool _p1PayingRent = true;

  // Partner 2
  double _p2Income = 100000;
  double _p2Basic = 50000;
  double _p2HRA = 20000;
  double _p2Investments = 300000;
  bool _p2PayingRent = false;

  // Joint
  double _jointGoal = 10000000;
  double _jointExpenses = 120000;
  String _rentCity = 'metro';

  void _calculate() => setState(() => _showResults = true);

  double get _combinedIncome => _p1Income + _p2Income;
  double get _combinedInvestments => _p1Investments + _p2Investments;
  double get _monthlySavings => _combinedIncome - _jointExpenses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: const Text('👫 Couple\'s Money Planner'),
        backgroundColor: AppTheme.bgWhite,
        actions: [
          if (_showResults)
            TextButton(onPressed: () => setState(() => _showResults = false), child: const Text('Edit')),
        ],
      ),
      body: _showResults ? _buildResults() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHero(),
          const SizedBox(height: 16),
          _buildPartnerSection('Partner 1 💚', _p1Income, _p1Basic, _p1HRA, _p1Investments, _p1PayingRent,
            (v) => setState(() => _p1Income = v),
            (v) => setState(() => _p1Basic = v),
            (v) => setState(() => _p1HRA = v),
            (v) => setState(() => _p1Investments = v),
            (v) => setState(() => _p1PayingRent = v),
          ),
          const SizedBox(height: 12),
          _buildPartnerSection('Partner 2 💙', _p2Income, _p2Basic, _p2HRA, _p2Investments, _p2PayingRent,
            (v) => setState(() => _p2Income = v),
            (v) => setState(() => _p2Basic = v),
            (v) => setState(() => _p2HRA = v),
            (v) => setState(() => _p2Investments = v),
            (v) => setState(() => _p2PayingRent = v),
          ),
          const SizedBox(height: 12),
          _buildJointSection(),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFFEC4899),
              ),
              child: const Text('Optimize Our Finances 💑', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('👫 Couple\'s Planner', style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'DMSans')),
          SizedBox(height: 4),
          Text('India\'s first AI-powered\njoint financial planner', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700, height: 1.2)),
          SizedBox(height: 8),
          Text('Optimize HRA, SIP splits, tax saving, and insurance across both incomes.',
              style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'DMSans', height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildPartnerSection(String title, double income, double basic, double hra, double investments, bool payingRent,
      ValueChanged<double> onIncome, ValueChanged<double> onBasic, ValueChanged<double> onHRA,
      ValueChanged<double> onInvestments, ValueChanged<bool> onRent) {
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
          _buildInput('Monthly Gross Salary', income, onIncome),
          const SizedBox(height: 10),
          _buildInput('Monthly Basic Salary', basic, onBasic),
          const SizedBox(height: 10),
          _buildInput('Monthly HRA Component', hra, onHRA),
          const SizedBox(height: 10),
          _buildInput('Total Current Investments', investments, onInvestments),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(child: Text('Paying Rent?', style: TextStyle(fontSize: 13, fontFamily: 'DMSans'))),
              Switch(value: payingRent, onChanged: onRent, activeColor: const Color(0xFFEC4899)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJointSection() {
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
          const Text('🏠 Joint Details', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _buildInput('Combined Monthly Expenses', _jointExpenses, (v) => setState(() => _jointExpenses = v)),
          const SizedBox(height: 10),
          _buildInput('Joint Financial Goal Amount', _jointGoal, (v) => setState(() => _jointGoal = v)),
          const SizedBox(height: 10),
          const Text('City Type', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontFamily: 'DMSans')),
          const SizedBox(height: 6),
          Row(
            children: ['metro', 'non-metro'].map((city) {
              final selected = _rentCity == city;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _rentCity = city),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFFEC4899) : AppTheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: selected ? const Color(0xFFEC4899) : AppTheme.divider),
                    ),
                    child: Text(
                      city == 'metro' ? '🏙️ Metro City' : '🏘️ Non-Metro',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: selected ? Colors.white : AppTheme.textSecondary, fontWeight: FontWeight.w500),
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

  Widget _buildInput(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'DMSans')),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value.toStringAsFixed(0)),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(prefixText: '₹ '),
          onChanged: (v) { final p = double.tryParse(v); if (p != null) onChanged(p); },
        ),
      ],
    );
  }

  Widget _buildResults() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCombinedOverview(),
          const SizedBox(height: 16),
          _buildHRAOptimization(),
          const SizedBox(height: 16),
          _buildSIPSplit(),
          const SizedBox(height: 16),
          _buildInsuranceStrategy(),
          const SizedBox(height: 16),
          _buildGoalTimeline(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCombinedOverview() {
    final totalTaxSaved = (_p1Income * 12 * 0.05 + _p2Income * 12 * 0.05);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💑 Combined Financial Picture', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStat('Combined Income', '₹${_fmt(_combinedIncome)}/mo', Colors.white),
              _buildStat('Joint Investments', '₹${_fmt(_combinedInvestments)}', Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildStat('Monthly Savings', '₹${_fmt(_monthlySavings)}', Colors.white),
              _buildStat('Savings Rate', '${(_monthlySavings / _combinedIncome * 100).toStringAsFixed(1)}%', Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: color.withOpacity(0.75), fontSize: 11, fontFamily: 'DMSans')),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildHRAOptimization() {
    final p1HRAExemption = _p1PayingRent ? (_p1HRA * 12).clamp(0, _p1Basic * 12 * (_rentCity == 'metro' ? 0.50 : 0.40)).toDouble() : 0.0;
    final p2HRAExemption = _p2PayingRent ? (_p2HRA * 12).clamp(0, _p2Basic * 12 * (_rentCity == 'metro' ? 0.50 : 0.40)).toDouble() : 0.0;
    final totalHRA = p1HRAExemption + p2HRAExemption;

    return _buildCard('🏠 HRA Optimization', [
      _buildResultRow('Partner 1 HRA Exemption', '₹${_fmt(p1HRAExemption)}/year', AppTheme.primaryGreen),
      _buildResultRow('Partner 2 HRA Exemption', '₹${_fmt(p2HRAExemption)}/year', AppTheme.accentBlue),
      _buildResultRow('Total HRA Tax Benefit', '₹${_fmt(totalHRA)}/year', AppTheme.goldAccent, isHighlight: true),
      const SizedBox(height: 8),
      _buildNote('💡 Tip: The higher income partner paying rent gets more HRA benefit (50% vs 40% for metro). If both are salaried & renting, both can claim independently.'),
    ]);
  }

  Widget _buildSIPSplit() {
    final totalSavings = _monthlySavings;
    final p1Share = (_p1Income / _combinedIncome * totalSavings * 0.7);
    final p2Share = (_p2Income / _combinedIncome * totalSavings * 0.3);
    final emergency = totalSavings * 0.15;

    return _buildCard('📈 Optimal SIP Split', [
      _buildResultRow('Partner 1 Monthly SIP', '₹${_fmt(p1Share)} (equity)', AppTheme.primaryGreen),
      _buildResultRow('Partner 2 Monthly SIP', '₹${_fmt(p2Share)} (ELSS/NPS)', AppTheme.accentBlue),
      _buildResultRow('Emergency Fund Building', '₹${_fmt(emergency)}/month', AppTheme.goldAccent),
      const Divider(height: 16),
      _buildResultRow('Total Monthly Investment', '₹${_fmt(p1Share + p2Share + emergency)}', AppTheme.textPrimary, isHighlight: true),
      const SizedBox(height: 8),
      _buildNote('💡 Partner with higher income invests in Equity; lower income partner maxes 80C (ELSS) first for tax efficiency.'),
    ]);
  }

  Widget _buildInsuranceStrategy() {
    final coverNeeded1 = _p1Income * 12 * 15;
    final coverNeeded2 = _p2Income * 12 * 15;

    return _buildCard('🛡️ Insurance Strategy', [
      _buildResultRow('Partner 1 Term Insurance Needed', '₹${_fmt(coverNeeded1)}', AppTheme.error),
      _buildResultRow('Partner 2 Term Insurance Needed', '₹${_fmt(coverNeeded2)}', AppTheme.error),
      _buildResultRow('Family Health Floater (Recommended)', '₹10-15 Lakh', AppTheme.accentBlue),
      _buildResultRow('Estimated Annual Premium', '₹${_fmt((_p1Income + _p2Income) * 0.01)}/year', AppTheme.goldAccent),
      const SizedBox(height: 8),
      _buildNote('💡 Use family floater health plan — cheaper than individual policies. Get term insurance separately for maximum cover at minimum cost. Avoid ULIPs.'),
    ]);
  }

  Widget _buildGoalTimeline() {
    final annualSavings = _monthlySavings * 12;
    final yearsToGoal = _jointGoal > 0 ? (_jointGoal / (annualSavings * 1.12)).ceil() : 0;

    return _buildCard('🎯 Joint Goal Timeline', [
      _buildResultRow('Combined Goal', '₹${_fmt(_jointGoal)}', AppTheme.textPrimary),
      _buildResultRow('Annual Savings Capacity', '₹${_fmt(annualSavings)}', AppTheme.primaryGreen),
      _buildResultRow('Estimated Years to Goal', '$yearsToGoal years (at 12% return)', AppTheme.accentBlue, isHighlight: true),
      const SizedBox(height: 8),
      _buildNote('⚡ Increase income, reduce expenses, or boost SIP to reach goal faster. Consider NPS matching — if one partner invests, reduce SIP for another by same amount.'),
    ]);
  }

  Widget _buildCard(String title, List<Widget> children) {
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

  Widget _buildResultRow(String label, String value, Color color, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 13, fontFamily: 'DMSans', fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal))),
          Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildNote(String note) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(note, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontFamily: 'DMSans', height: 1.4)),
    );
  }

  String _fmt(double v) {
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(1)}Cr';
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(0)}K';
    return '₹${v.toStringAsFixed(0)}';
  }
}
