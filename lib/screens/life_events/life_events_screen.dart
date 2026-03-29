import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class LifeEventsScreen extends StatefulWidget {
  const LifeEventsScreen({super.key});

  @override
  State<LifeEventsScreen> createState() => _LifeEventsScreenState();
}

class _LifeEventsScreenState extends State<LifeEventsScreen> {
  String? _selectedEvent;

  final List<_LifeEvent> _events = [
    _LifeEvent('bonus', '💰', 'Got a Bonus', 'Best ways to deploy a windfall', AppTheme.goldAccent),
    _LifeEvent('marriage', '💍', 'Getting Married', 'Joint finances & insurance planning', Color(0xFFEC4899)),
    _LifeEvent('baby', '👶', 'New Baby', 'Child\'s education fund & insurance', AppTheme.accentBlue),
    _LifeEvent('inheritance', '🏠', 'Received Inheritance', 'Smart wealth deployment strategy', AppTheme.primaryGreen),
    _LifeEvent('job_change', '💼', 'Changed Jobs', 'EPF transfer, ESOP, new salary', AppTheme.accentOrange),
    _LifeEvent('home_buy', '🏡', 'Buying a Home', 'Loan optimization, tax benefits', Color(0xFF7C3AED)),
    _LifeEvent('business', '🚀', 'Starting Business', 'Tax planning for entrepreneurs', AppTheme.textPrimary),
    _LifeEvent('retirement', '🏖️', 'Near Retirement', 'Corpus withdrawal & tax planning', AppTheme.primaryGreen),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: const Text('🎯 Life Event Advisor'),
        backgroundColor: AppTheme.bgWhite,
        actions: [
          if (_selectedEvent != null)
            TextButton(onPressed: () => setState(() => _selectedEvent = null), child: const Text('Back')),
        ],
      ),
      body: _selectedEvent != null ? _buildEventDetail() : _buildEventGrid(),
    );
  }

  Widget _buildEventGrid() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppGradients.blueGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🎯 Life Events', style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'DMSans')),
                SizedBox(height: 4),
                Text('AI advice for\nbig life moments', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, height: 1.2)),
                SizedBox(height: 8),
                Text('Personalized financial guidance for major life changes — tailored to your tax bracket & goals.',
                    style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'DMSans', height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('What happened in your life?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: _events.map((e) => _buildEventCard(e)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(_LifeEvent event) {
    return GestureDetector(
      onTap: () => setState(() => _selectedEvent = event.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.bgWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.emoji, style: const TextStyle(fontSize: 28)),
            const Spacer(),
            Text(event.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 2),
            Text(event.subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontFamily: 'DMSans')),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetail() {
    final event = _events.firstWhere((e) => e.id == _selectedEvent);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEventHero(event),
          const SizedBox(height: 16),
          ..._getEventContent(event),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEventHero(_LifeEvent event) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: event.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: event.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(event.emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Personalized financial advice for this milestone',
                    style: TextStyle(color: event.color, fontSize: 13, fontFamily: 'DMSans')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getEventContent(_LifeEvent event) {
    switch (event.id) {
      case 'bonus':
        return _bonusContent();
      case 'marriage':
        return _marriageContent();
      case 'baby':
        return _babyContent();
      case 'inheritance':
        return _inheritanceContent();
      case 'job_change':
        return _jobChangeContent();
      case 'home_buy':
        return _homeBuyContent();
      default:
        return _genericContent(event);
    }
  }

  List<Widget> _bonusContent() {
    return [
      _buildAmountInput('Bonus Amount Received'),
      const SizedBox(height: 16),
      _buildAdviceCard('🎯 Smart Bonus Deployment Strategy', [
        _Advice('1st', 'Emergency Fund (if < 6 months)', '20%', 'Liquid Fund / High-yield savings'),
        _Advice('2nd', 'High-interest debt repayment', '30%', 'Credit card → Personal loan first'),
        _Advice('3rd', 'Tax saving investments by March', '20%', 'ELSS, NPS, PPF top-up'),
        _Advice('4th', 'Long-term wealth creation', '25%', 'Lumpsum in index fund + STP'),
        _Advice('5th', 'Guilt-free splurge 🎉', '5%', 'You earned it!'),
      ]),
      const SizedBox(height: 12),
      _buildTaxNote('⚠️ Tax Note', 'Bonus is fully taxable as salary income. If it pushes you to a higher slab, consider investing in NPS/ELSS before end of financial year to reduce tax.'),
      const SizedBox(height: 12),
      _buildTipCard('💡 Pro Tip: Lumpsum vs STP', 'For equity MF investment, use STP (Systematic Transfer Plan) — park in liquid fund and auto-transfer ₹X monthly to equity. Reduces timing risk.'),
    ];
  }

  List<Widget> _marriageContent() {
    return [
      _buildAdviceCard('👫 Joint Financial Planning Checklist', [
        _Advice('1', 'Discuss money openly', 'Day 1', 'Income, debts, goals, spending style'),
        _Advice('2', 'HRA optimization', 'Month 1', 'Higher salary spouse claims HRA if renting'),
        _Advice('3', 'Joint health insurance', 'Month 1', 'Family floater plan saves premium'),
        _Advice('4', 'Update life insurance nominees', 'Month 1', 'Add spouse as nominee in all policies'),
        _Advice('5', 'Joint home loan', 'If buying home', 'Both can claim ₹2L interest + ₹1.5L principal'),
        _Advice('6', 'Sukanya Samriddhi for girl child', 'If planning baby', '8.2% tax-free returns'),
      ]),
      const SizedBox(height: 12),
      _buildTaxNote('💰 HRA Hack for Married Couples',
          'If you pay rent to your spouse, NEITHER can claim HRA exemption (IT department disallows related-party rent). Better: both claim from common address if both are salaried.'),
      const SizedBox(height: 12),
      _buildTipCard('📋 Wedding Expense Planning',
          'Wedding expenses are NOT tax deductible. If taking a personal loan for wedding, pay it off fast — at 12-15% interest, it destroys wealth. Consider using FD/MF redemption instead.'),
    ];
  }

  List<Widget> _babyContent() {
    return [
      _buildAdviceCard('👶 New Baby Financial Checklist', [
        _Advice('Week 1', 'Increase life insurance', 'Urgent', '15-20x annual income now with dependents'),
        _Advice('Month 1', 'Add baby to health insurance', 'Urgent', 'Within 30-90 days of birth (check policy)'),
        _Advice('Month 3', 'Start Child Education SIP', 'Important', '₹5,000-10,000/month in equity for 18 years'),
        _Advice('Month 3', 'Open SSY if girl child', 'Important', '8.2% tax-free, ₹250-1.5L/year'),
        _Advice('Year 1', 'Will & guardian clause', 'Important', 'Update will naming guardian for child'),
        _Advice('Year 1', 'Review emergency fund', 'Normal', 'Increase to 9 months with new expense'),
      ]),
      const SizedBox(height: 12),
      _buildCalculatorCard('📚 Education Corpus Calculator',
          'SIP of ₹10,000/month for 18 years at 12% returns = ₹1.09 Crore\nEngineeringcost in 2042 (6% inflation) = ~₹60-80L\n→ Start ₹5,000 SIP TODAY'),
      const SizedBox(height: 12),
      _buildTipCard('🏫 Best Funds for Child Education', 'Use large cap or hybrid funds for first 10 years, then shift to debt funds 3 years before goal. Never invest in child ULIPs — 3% charges destroy returns.'),
    ];
  }

  List<Widget> _inheritanceContent() {
    return [
      _buildAdviceCard('🏠 Inheritance Deployment Strategy', [
        _Advice('Step 1', 'Don\'t rush — park in liquid fund', 'Week 1', 'FD or liquid fund while deciding'),
        _Advice('Step 2', 'Check for estate tax / legal', 'Month 1', 'No inheritance tax in India, but check legal clearance'),
        _Advice('Step 3', 'Assess existing portfolio gaps', 'Month 1', 'Emergency, insurance, debt first'),
        _Advice('Step 4', 'Real estate vs financial assets', 'Month 3', 'Liquidity comparison before property'),
        _Advice('Step 5', 'Staggered equity deployment', 'Month 3-6', 'STP to equity over 6-12 months'),
        _Advice('Step 6', 'Consult CA for tax implications', 'Before sale', 'Capital gains if selling inherited property'),
      ]),
      const SizedBox(height: 12),
      _buildTaxNote('🏡 Inherited Property Tax Rules',
          'If you sell inherited property: Cost of acquisition = original cost of the deceased (with indexation benefit). Holding period includes deceased\'s period. LTCG at 20% with indexation if held > 2 years.'),
    ];
  }

  List<Widget> _jobChangeContent() {
    return [
      _buildAdviceCard('💼 Job Change Financial Checklist', [
        _Advice('Before leaving', 'EPF Transfer / Withdrawal', 'Important', 'Transfer to new employer — don\'t withdraw (loses interest & tax benefit)'),
        _Advice('Before leaving', 'ESOP vesting schedule', 'Check', 'Unvested ESOPs are lost — factor in your decision'),
        _Advice('Day 1 at new job', 'Submit investment proofs', 'Important', 'For correct TDS deduction from salary'),
        _Advice('Month 1', 'Update insurance nominees', 'Important', 'Group insurance from old employer ends'),
        _Advice('Month 1', 'Buy personal health insurance', 'Urgent', 'Don\'t rely solely on employer health cover'),
        _Advice('Tax filing', 'File Form 12B at new employer', 'Required', 'Previous income declaration for correct tax'),
      ]),
      const SizedBox(height: 12),
      _buildTaxNote('💰 EPF Withdrawal Tax Rules',
          'EPF withdrawal is tax-free ONLY if employed for 5+ continuous years. Withdrawal before 5 years: taxable as income. ALWAYS transfer EPF — don\'t withdraw unless desperate.'),
      const SizedBox(height: 12),
      _buildTipCard('📈 Salary Hike Investment Rule', 'Invest 50% of every salary increment. Got ₹20,000 raise? Increase SIP by ₹10,000. This ensures wealth grows proportional to income.'),
    ];
  }

  List<Widget> _homeBuyContent() {
    return [
      _buildAdviceCard('🏡 Home Buying Financial Checklist', [
        _Advice('Before buying', 'EMI should be <40% of take-home', 'Rule', 'Don\'t stretch — leave room for savings'),
        _Advice('Down payment', 'Use FD/debt funds, not equity', 'Important', 'Equity can be 30% lower when you need funds'),
        _Advice('Tax benefits', 'Section 24B interest', '₹2L', 'Home loan interest deduction per year'),
        _Advice('Tax benefits', 'Section 80C principal', '₹1.5L', 'Principal repayment in 80C limit'),
        _Advice('Joint loan', 'Both spouses as co-borrowers', 'Smart', 'Both get ₹2L + ₹1.5L each if co-owners'),
        _Advice('Emergency', 'Keep 6-month EMI reserve', 'Important', 'Job loss protection for EMI continuity'),
      ]),
      const SizedBox(height: 12),
      _buildCalculatorCard('🔢 Rent vs Buy Calculator',
          'Buy ₹80L home: EMI ₹65,000/month @ 8.5% for 20 years\nTotal cost: ₹1.56 Crore (with interest)\n\nAlternative: Rent ₹20,000, invest ₹45,000 SIP for 20 years\n→ Creates ₹5.5Cr corpus at 12% returns\n\nDecision: Depends on your city, rent-to-buy ratio & goals'),
      const SizedBox(height: 12),
      _buildTipCard('💡 PMAY Subsidy', 'Under PMAY (Pradhan Mantri Awas Yojana), first-time home buyers can get 2.67L subsidy for loan up to ₹6L if income <₹6L/year. Check eligibility!'),
    ];
  }

  List<Widget> _genericContent(_LifeEvent event) {
    return [
      _buildTipCard('🤖 AI Advisor Coming Soon', 'Detailed advice for ${event.title} is being prepared. Talk to our AI chat for personalized guidance right now!'),
    ];
  }

  Widget _buildAmountInput(String label) {
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
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          const TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixText: '₹ ',
              hintText: 'Enter amount',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceCard(String title, List<_Advice> advices) {
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
          ...advices.map((a) => _buildAdviceRow(a)),
        ],
      ),
    );
  }

  Widget _buildAdviceRow(_Advice a) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(a.step, style: const TextStyle(fontSize: 9, color: AppTheme.primaryGreen, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.action, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text(a.detail, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'DMSans')),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(a.amount, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxNote(String title, String note) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.warning.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 6),
          Text(note, style: const TextStyle(fontSize: 13, fontFamily: 'DMSans', height: 1.5, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildTipCard(String title, String tip) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.primaryGreen)),
          const SizedBox(height: 6),
          Text(tip, style: const TextStyle(fontSize: 13, fontFamily: 'DMSans', height: 1.5, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildCalculatorCard(String title, String content) {
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
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.accentBlue)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 13, fontFamily: 'DMSans', height: 1.7, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

class _LifeEvent {
  final String id, emoji, title, subtitle;
  final Color color;
  const _LifeEvent(this.id, this.emoji, this.title, this.subtitle, this.color);
}

class _Advice {
  final String step, action, amount, detail;
  const _Advice(this.step, this.action, this.amount, this.detail);
}
