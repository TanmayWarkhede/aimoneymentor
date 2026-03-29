import 'dart:math' as math;
// User Profile Model
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int age;
  final double monthlyIncome;
  final double monthlyExpenses;
  final double existingInvestments;
  final String riskProfile; // conservative, moderate, aggressive
  final String taxRegime; // old, new
  final List<FinancialGoal> goals;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.existingInvestments,
    required this.riskProfile,
    required this.taxRegime,
    required this.goals,
    required this.createdAt,
  });

  double get monthlyInvestable => monthlyIncome - monthlyExpenses;
  double get savingsRate => (monthlyInvestable / monthlyIncome) * 100;

  UserProfile copyWith({
    String? name,
    double? monthlyIncome,
    double? monthlyExpenses,
    String? riskProfile,
    String? taxRegime,
    List<FinancialGoal>? goals,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email,
      phone: phone,
      age: age,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      existingInvestments: existingInvestments,
      riskProfile: riskProfile ?? this.riskProfile,
      taxRegime: taxRegime ?? this.taxRegime,
      goals: goals ?? this.goals,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'age': age,
    'monthlyIncome': monthlyIncome,
    'monthlyExpenses': monthlyExpenses,
    'existingInvestments': existingInvestments,
    'riskProfile': riskProfile,
    'taxRegime': taxRegime,
    'goals': goals.map((g) => g.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
  };
}

// Financial Goal Model
class FinancialGoal {
  final String id;
  final String name;
  final String category; // retirement, house, education, emergency, travel, wedding
  final double targetAmount;
  final DateTime targetDate;
  final double currentSavings;
  final double monthlySIP;
  final String priority; // high, medium, low

  const FinancialGoal({
    required this.id,
    required this.name,
    required this.category,
    required this.targetAmount,
    required this.targetDate,
    required this.currentSavings,
    required this.monthlySIP,
    required this.priority,
  });

  int get monthsRemaining {
    final now = DateTime.now();
    return ((targetDate.year - now.year) * 12 + (targetDate.month - now.month));
  }

  double get progressPercent {
    return (currentSavings / targetAmount * 100).clamp(0, 100);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'targetAmount': targetAmount,
    'targetDate': targetDate.toIso8601String(),
    'currentSavings': currentSavings,
    'monthlySIP': monthlySIP,
    'priority': priority,
  };
}

// Money Health Score Model
class MoneyHealthScore {
  final double emergencyScore;
  final double insuranceScore;
  final double investmentScore;
  final double debtScore;
  final double taxScore;
  final double retirementScore;
  final DateTime calculatedAt;

  const MoneyHealthScore({
    required this.emergencyScore,
    required this.insuranceScore,
    required this.investmentScore,
    required this.debtScore,
    required this.taxScore,
    required this.retirementScore,
    required this.calculatedAt,
  });

  double get overallScore {
    return (emergencyScore + insuranceScore + investmentScore +
        debtScore + taxScore + retirementScore) / 6;
  }

  String get scoreGrade {
    final score = overallScore;
    if (score >= 80) return 'Excellent';
    if (score >= 65) return 'Good';
    if (score >= 45) return 'Fair';
    return 'Poor';
  }

  String get scoreEmoji {
    final score = overallScore;
    if (score >= 80) return '🌟';
    if (score >= 65) return '😊';
    if (score >= 45) return '😐';
    return '😟';
  }
}

// FIRE Plan Model
class FirePlan {
  final int currentAge;
  final int targetRetirementAge;
  final double currentMonthlyExpenses;
  final double existingCorpus;
  final double monthlyInvestment;
  final double expectedReturns;
  final double inflationRate;
  final List<FireMilestone> milestones;
  final double targetCorpus;
  final double fireNumber;

  const FirePlan({
    required this.currentAge,
    required this.targetRetirementAge,
    required this.currentMonthlyExpenses,
    required this.existingCorpus,
    required this.monthlyInvestment,
    required this.expectedReturns,
    required this.inflationRate,
    required this.milestones,
    required this.targetCorpus,
    required this.fireNumber,
  });

  int get yearsToFire => targetRetirementAge - currentAge;

  double get progressPercent {
    return (existingCorpus / targetCorpus * 100).clamp(0, 100);
  }
}

class FireMilestone {
  final int year;
  final int age;
  final double projectedCorpus;
  final double monthlySip;
  final String milestone;

  const FireMilestone({
    required this.year,
    required this.age,
    required this.projectedCorpus,
    required this.monthlySip,
    required this.milestone,
  });
}

// Mutual Fund Model
class MutualFund {
  final String schemeCode;
  final String schemeName;
  final String fundHouse;
  final String category; // equity, debt, hybrid, etc.
  final String subCategory;
  final double nav;
  final double aum; // in crores
  final double expenseRatio;
  final double oneYearReturn;
  final double threeYearReturn;
  final double fiveYearReturn;
  final String riskLevel; // low, moderate, high
  final double sharpeRatio;
  final double beta;
  final String exitLoad;

  const MutualFund({
    required this.schemeCode,
    required this.schemeName,
    required this.fundHouse,
    required this.category,
    required this.subCategory,
    required this.nav,
    required this.aum,
    required this.expenseRatio,
    required this.oneYearReturn,
    required this.threeYearReturn,
    required this.fiveYearReturn,
    required this.riskLevel,
    required this.sharpeRatio,
    required this.beta,
    required this.exitLoad,
  });
}

// Tax Calculation Model
class TaxCalculation {
  final double grossSalary;
  final double basicSalary;
  final double hra;
  final double hra80GG;
  final double sec80C;
  final double sec80D;
  final double sec80CCD1B; // NPS
  final double sec80E; // Education loan
  final double sec80G; // Donations
  final double homeLoanInterest; // 24b
  final double standardDeduction;
  final String regime; // old, new

  const TaxCalculation({
    required this.grossSalary,
    required this.basicSalary,
    required this.hra,
    required this.hra80GG,
    required this.sec80C,
    required this.sec80D,
    required this.sec80CCD1B,
    required this.sec80E,
    required this.sec80G,
    required this.homeLoanInterest,
    required this.standardDeduction,
    required this.regime,
  });

  // Old Regime Tax Slabs FY 2024-25
  double get oldRegimeTax {
    double taxable = grossSalary - standardDeduction - sec80C - sec80D -
        sec80CCD1B - homeLoanInterest - hra80GG - sec80E;
    taxable = taxable.clamp(0, double.infinity);

    double tax = 0;
    if (taxable <= 250000) {
      tax = 0;
    } else if (taxable <= 500000) {
      tax = (taxable - 250000) * 0.05;
    } else if (taxable <= 750000) {
      tax = 12500 + (taxable - 500000) * 0.10;
    } else if (taxable <= 1000000) {
      tax = 37500 + (taxable - 750000) * 0.15;
    } else if (taxable <= 1250000) {
      tax = 75000 + (taxable - 1000000) * 0.20;
    } else if (taxable <= 1500000) {
      tax = 125000 + (taxable - 1250000) * 0.25;
    } else {
      tax = 187500 + (taxable - 1500000) * 0.30;
    }

    // Rebate 87A - if taxable income <= 5L, no tax
    if (taxable <= 500000) tax = 0;

    // Cess 4%
    return tax * 1.04;
  }

  // New Regime Tax Slabs FY 2024-25
  double get newRegimeTax {
    double taxable = grossSalary - 75000; // Standard deduction in new regime
    taxable = taxable.clamp(0, double.infinity);

    double tax = 0;
    if (taxable <= 300000) {
      tax = 0;
    } else if (taxable <= 700000) {
      tax = (taxable - 300000) * 0.05;
    } else if (taxable <= 1000000) {
      tax = 20000 + (taxable - 700000) * 0.10;
    } else if (taxable <= 1200000) {
      tax = 50000 + (taxable - 1000000) * 0.15;
    } else if (taxable <= 1500000) {
      tax = 80000 + (taxable - 1200000) * 0.20;
    } else {
      tax = 140000 + (taxable - 1500000) * 0.30;
    }

    // Rebate 87A - if taxable income <= 7L, no tax in new regime
    if (taxable <= 700000) tax = 0;

    // Cess 4%
    return tax * 1.04;
  }

  double get savings => oldRegimeTax - newRegimeTax;
  bool get newRegimeBetter => newRegimeTax < oldRegimeTax;
}

// Stock/Market Data Model
class MarketData {
  final String symbol;
  final String name;
  final double price;
  final double change;
  final double changePercent;
  final double dayHigh;
  final double dayLow;
  final String exchange;
  final DateTime timestamp;

  const MarketData({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.dayHigh,
    required this.dayLow,
    required this.exchange,
    required this.timestamp,
  });

  bool get isPositive => change >= 0;
}

// Portfolio Holding Model
class PortfolioHolding {
  final String fundName;
  final String folioNumber;
  final double units;
  final double currentNav;
  final double purchaseNav;
  final DateTime purchaseDate;
  final double investedAmount;

  const PortfolioHolding({
    required this.fundName,
    required this.folioNumber,
    required this.units,
    required this.currentNav,
    required this.purchaseNav,
    required this.purchaseDate,
    required this.investedAmount,
  });

  double get currentValue => units * currentNav;
  double get gainLoss => currentValue - investedAmount;
  double get gainLossPercent => (gainLoss / investedAmount) * 100;
  double get xirr => _calculateXIRR();

  double _calculateXIRR() {
    // Simplified XIRR approximation
    final days = DateTime.now().difference(purchaseDate).inDays;
    final years = days / 365.0;
    if (years <= 0) return 0;
    return (math.pow((currentValue / investedAmount), (1 / years)) - 1) * 100;
  }
}

// Chat Message Model
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final List<ChatAction>? actions;
  final MessageType type;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.actions,
    this.type = MessageType.text,
  });
}

enum MessageType { text, chart, calculator, recommendation }

class ChatAction {
  final String label;
  final String action;

  const ChatAction({required this.label, required this.action});
}

// Life Event Model
class LifeEvent {
  final String id;
  final String type; // bonus, marriage, baby, inheritance, job_change, home_purchase
  final String title;
  final String description;
  final double amount;
  final DateTime eventDate;
  final Map<String, dynamic> details;

  const LifeEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.amount,
    required this.eventDate,
    required this.details,
  });
}

