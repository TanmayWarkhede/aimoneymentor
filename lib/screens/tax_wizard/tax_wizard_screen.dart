import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

class TaxWizardScreen extends StatefulWidget {
  const TaxWizardScreen({super.key});

  @override
  State<TaxWizardScreen> createState() => _TaxWizardScreenState();
}

class _TaxWizardScreenState extends State<TaxWizardScreen> {
  bool _showResults = false;

  // Tax inputs
  double _grossSalary = 1200000;
  double _basicSalary = 600000;
  double _hra = 240000;
  double _rentPaid = 300000;
  bool _metroCity = true;
  double _sec80C = 100000;
  double _sec80D_self = 20000;
  double _sec80D_parents = 25000;
  bool _parentsAreSenior = true;
  double _sec80CCD1B = 50000; // NPS
  double _homeLoanInterest = 0;
  double _educationLoanInterest = 0;

  TaxCalculation? _taxCalc;

  void _calculate() {
    // HRA Exemption calculation
    final actualHRA = _hra;
    final rentMinus10 = _rentPaid - (_basicSalary * 0.10);
    final hraLimit = _metroCity ? _basicSalary * 0.50 : _basicSalary * 0.40;
    final hraExemption = [actualHRA, rentMinus10, hraLimit].reduce((a, b) => a < b ? a : b).clamp(0, double.infinity);

    final calc = TaxCalculation(
      grossSalary: _grossSalary,
      basicSalary: _basicSalary,
      hra: _hra,
      hra80GG: hraExemption.toDouble(),
      sec80C: _sec80C.clamp(0, 150000),
      sec80D: (_sec80D_self.clamp(0, 25000) + (_parentsAreSenior ? _sec80D_parents.clamp(0, 50000) : _sec80D_parents.clamp(0, 25000))),
      sec80CCD1B: _sec80CCD1B.clamp(0, 50000),
      sec80E: _educationLoanInterest,
      sec80G: 0,
      homeLoanInterest: _homeLoanInterest.clamp(0, 200000),
      standardDeduction: 50000,
      regime: 'old',
    );

    setState(() {
      _taxCalc = calc;
      _showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: const Text('💰 Tax Wizard FY 2024-25'),
        backgroundColor: AppTheme.bgWhite,
        actions: [
          if (_showResults)
            TextButton(onPressed: () => setState(() => _showResults = false), child: const Text('Edit')),
        ],
      ),
      body: _showResults && _taxCalc != null ? _buildResults() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTaxHeader(),
          const SizedBox(height: 16),
          _buildSection('💼 Salary Details', [
            _buildInput('Annual Gross Salary (CTC)', _grossSalary, (v) => setState(() => _grossSalary = v)),
            const SizedBox(height: 12),
            _buildInput('Annual Basic Salary', _basicSalary, (v) => setState(() => _basicSalary = v)),
            const SizedBox(height: 12),
            _buildInput('Annual HRA Component', _hra, (v) => setState(() => _hra = v)),
            const SizedBox(height: 12),
            _buildInput('Annual Rent Paid (if renting)', _rentPaid, (v) => setState(() => _rentPaid = v)),
            const SizedBox(height: 8),
            _buildSwitch('Living in Metro City (Mumbai/Delhi/Chennai/Kolkata)', _metroCity, (v) => setState(() => _metroCity = v)),
          ]),
          const SizedBox(height: 16),
          _buildSection('🏦 Section 80C (Max ₹1.5 Lakh)', [
            _buildInput('Total 80C Investments', _sec80C, (v) => setState(() => _sec80C = v)),
            const SizedBox(height: 8),
            _buildInfoCard('Includes: ELSS, PPF, EPF, LIC, Home Loan Principal, NSC, ULIP, SSY, NPS (employee)'),
          ]),
          const SizedBox(height: 16),
          _buildSection('🏥 Section 80D - Health Insurance', [
            _buildInput('Health Insurance for Self & Family', _sec80D_self, (v) => setState(() => _sec80D_self = v)),
            const SizedBox(height: 12),
            _buildInput('Health Insurance for Parents', _sec80D_parents, (v) => setState(() => _sec80D_parents = v)),
            const SizedBox(height: 8),
            _buildSwitch('Parents are Senior Citizens (60+)', _parentsAreSenior, (v) => setState(() => _parentsAreSenior = v)),
          ]),
          const SizedBox(height: 16),
          _buildSection('🏛️ Other Deductions', [
            _buildInput('NPS Contribution 80CCD(1B) — Extra ₹50K', _sec80CCD1B, (v) => setState(() => _sec80CCD1B = v)),
            const SizedBox(height: 12),
            _buildInput('Home Loan Interest Paid (Sec 24B)', _homeLoanInterest, (v) => setState(() => _homeLoanInterest = v)),
            const SizedBox(height: 12),
            _buildInput('Education Loan Interest (Sec 80E)', _educationLoanInterest, (v) => setState(() => _educationLoanInterest = v)),
          ]),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.goldAccent,
                foregroundColor: Colors.black,
              ),
              child: const Text('Calculate Tax & Compare Regimes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTaxHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB800), Color(0xFFFF8F00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('💰 Tax Wizard', style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'DMSans')),
          SizedBox(height: 4),
          Text('Old vs New Regime\nCalculator', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, height: 1.2)),
          SizedBox(height: 12),
          Text('We analyze all deductions and tell you exactly which regime saves more tax with your specific numbers.',
              style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'DMSans', height: 1.5)),
        ],
      ),
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

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13, fontFamily: 'DMSans'))),
        Switch(value: value, onChanged: onChanged, activeColor: AppTheme.primaryGreen),
      ],
    );
  }

  Widget _buildInfoCard(String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 16, color: AppTheme.textSecondary),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontFamily: 'DMSans'))),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final calc = _taxCalc!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildRegimeComparison(calc),
          const SizedBox(height: 16),
          _buildTaxBreakdown(calc),
          const SizedBox(height: 16),
          _buildMissedDeductions(calc),
          const SizedBox(height: 16),
          _buildTaxSavingTips(calc),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRegimeComparison(TaxCalculation calc) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: calc.newRegimeBetter ? AppGradients.blueGradient : AppGradients.greenGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            calc.newRegimeBetter ? '🔵 New Regime is Better!' : '🟢 Old Regime is Better!',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'You save ₹${_fmt(calc.savings.abs())} more in ${calc.newRegimeBetter ? "New" : "Old"} Regime',
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontFamily: 'DMSans'),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildRegimeCard('Old Regime', calc.oldRegimeTax, !calc.newRegimeBetter),
              const SizedBox(width: 12),
              _buildRegimeCard('New Regime', calc.newRegimeTax, calc.newRegimeBetter),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegimeCard(String label, double tax, bool isRecommended) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRecommended ? Colors.white : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: isRecommended ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Column(
          children: [
            if (isRecommended)
              const Text('✅ RECOMMENDED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.primaryGreen)),
            Text(label, style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isRecommended ? AppTheme.textPrimary : Colors.white,
              fontSize: 14,
            )),
            const SizedBox(height: 4),
            Text('₹${_fmt(tax)}', style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: isRecommended ? AppTheme.primaryGreen : Colors.white,
            )),
            Text('annual tax', style: TextStyle(
              fontSize: 11,
              color: isRecommended ? AppTheme.textSecondary : Colors.white70,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxBreakdown(TaxCalculation calc) {
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
          const Text('🔍 Old Regime Deduction Breakdown', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 16),
          _buildBreakRow('Gross Salary', calc.grossSalary, isTotal: true),
          _buildBreakRow('Standard Deduction (50,000)', -calc.standardDeduction),
          _buildBreakRow('HRA Exemption', -calc.hra80GG),
          _buildBreakRow('Section 80C', -calc.sec80C),
          _buildBreakRow('Section 80D (Health Insurance)', -calc.sec80D),
          _buildBreakRow('NPS 80CCD(1B)', -calc.sec80CCD1B),
          if (calc.homeLoanInterest > 0)
            _buildBreakRow('Home Loan Interest (24B)', -calc.homeLoanInterest),
          const Divider(),
          _buildBreakRow('Taxable Income', calc.grossSalary - calc.standardDeduction - calc.hra80GG -
              calc.sec80C - calc.sec80D - calc.sec80CCD1B - calc.homeLoanInterest, isTotal: true),
          const SizedBox(height: 4),
          _buildBreakRow('Income Tax + Cess (4%)', calc.oldRegimeTax, isHighlight: true),
          _buildBreakRow('Monthly Tax Deducted (TDS)', calc.oldRegimeTax / 12, isHighlight: true),
        ],
      ),
    );
  }

  Widget _buildBreakRow(String label, double amount, {bool isTotal = false, bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            fontSize: 13,
            fontWeight: isTotal || isHighlight ? FontWeight.w600 : FontWeight.normal,
            fontFamily: 'DMSans',
            color: isTotal ? AppTheme.textPrimary : AppTheme.textSecondary,
          )),
          Text(
            '${amount < 0 ? '-' : ''}₹${_fmt(amount.abs())}',
            style: TextStyle(
              fontWeight: isTotal || isHighlight ? FontWeight.w700 : FontWeight.w500,
              color: isHighlight ? AppTheme.error : amount < 0 ? AppTheme.primaryGreen : AppTheme.textPrimary,
              fontSize: isTotal ? 14 : 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissedDeductions(TaxCalculation calc) {
    final missed = <Map<String, String>>[];

    if (calc.sec80C < 150000) {
      final gap = 150000 - calc.sec80C;
      missed.add({
        'title': '80C Gap: ₹${_fmt(gap)} remaining',
        'action': 'Invest in ELSS — saves ₹${_fmt(gap * 0.30)} tax (30% slab)',
        'emoji': '📈',
      });
    }
    if (calc.sec80CCD1B < 50000) {
      final gap = 50000 - calc.sec80CCD1B;
      missed.add({
        'title': 'NPS 80CCD(1B): ₹${_fmt(gap)} unused',
        'action': 'Invest ₹${_fmt(gap)} in NPS — extra tax saving on top of 80C',
        'emoji': '🏛️',
      });
    }
    if (calc.sec80D < 25000) {
      missed.add({
        'title': 'Health Insurance: Underinsured',
        'action': 'Buy ₹5L floater plan — saves tax + protects health',
        'emoji': '🏥',
      });
    }

    if (missed.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            Text('🎉', style: TextStyle(fontSize: 24)),
            SizedBox(width: 12),
            Expanded(
              child: Text('All major deductions utilized! You\'re optimizing your taxes well.',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.warning.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('⚠️', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text('Missed Tax Savings', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          ...missed.map((m) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.bgWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(m['emoji']!, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(m['title']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ]),
                const SizedBox(height: 4),
                Text(m['action']!, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'DMSans')),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTaxSavingTips(TaxCalculation calc) {
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
          const Text('💡 Tax Saving Investment Rankings', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 4),
          const Text('Best options for your profile (lowest risk to highest)',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'DMSans')),
          const SizedBox(height: 12),
          _buildTaxOption('🥇', 'NPS Tier 1 (80CCD 1B)', '₹50K extra deduction', 'Market linked ~9-12%', 'Lock till 60'),
          _buildTaxOption('🥈', 'ELSS Mutual Funds', '₹1.5L under 80C', 'Market linked ~12-15%', '3 year lock'),
          _buildTaxOption('🥉', 'PPF (Public Provident Fund)', '₹1.5L under 80C', '7.1% guaranteed', '15 year lock'),
          _buildTaxOption('4️⃣', 'NSC (National Savings Certificate)', '₹1.5L under 80C', '7.7% guaranteed', '5 year lock'),
          _buildTaxOption('5️⃣', 'Tax Saving FD', '₹1.5L under 80C', '6.5-7.5%', '5 year lock'),
        ],
      ),
    );
  }

  Widget _buildTaxOption(String rank, String name, String limit, String returns, String lockIn) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(rank, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text('$limit · $returns · $lockIn',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontFamily: 'DMSans')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double value) {
    if (value >= 10000000) return '${(value / 10000000).toStringAsFixed(1)}Cr';
    if (value >= 100000) return '${(value / 100000).toStringAsFixed(1)}L';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
    return value.toStringAsFixed(0);
  }
}
