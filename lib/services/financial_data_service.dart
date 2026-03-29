import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../models/models.dart';

class FinancialDataService {
  static const String _mfApiBase = 'https://api.mfapi.in/mf';
  static const String _nseBase = 'https://query1.finance.yahoo.com/v8/finance/chart';
  static const String _rbiBase = 'https://rbidocs.rbi.org.in/rdocs/PressRelease/PDFs';
  
  // MF API - Free, no key needed - api.mfapi.in
  static const String _mfSearchBase = 'https://api.mfapi.in/mf/search';

  // ========== MUTUAL FUND DATA ==========

  /// Fetch all mutual funds list from MF API (free, open source)
  static Future<List<Map<String, dynamic>>> fetchAllMutualFunds() async {
    try {
      final response = await http.get(
        Uri.parse(_mfApiBase),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return _getMockMFList();
    } catch (e) {
      return _getMockMFList();
    }
  }

  /// Search mutual funds by name
  static Future<List<Map<String, dynamic>>> searchMutualFunds(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_mfSearchBase?q=${Uri.encodeComponent(query)}'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      return _getMockMFSearchResults(query);
    }
  }

  /// Fetch NAV history for a specific scheme
  static Future<Map<String, dynamic>> fetchMFNAVHistory(String schemeCode) async {
    try {
      final response = await http.get(
        Uri.parse('$_mfApiBase/$schemeCode'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return _getMockNAVHistory(schemeCode);
    } catch (e) {
      return _getMockNAVHistory(schemeCode);
    }
  }

  /// Calculate XIRR from transaction history
  static double calculateXIRR(List<Map<String, dynamic>> transactions) {
    // Newton-Raphson method for XIRR
    if (transactions.isEmpty) return 0;

    double rate = 0.1; // Initial guess 10%
    for (int iter = 0; iter < 100; iter++) {
      double npv = 0;
      double dnpv = 0;

      for (final txn in transactions) {
        final amount = (txn['amount'] as num).toDouble();
        final date = DateTime.parse(txn['date'] as String);
        final days = date.difference(DateTime.now()).inDays.toDouble();
        final t = days / 365.0;

        npv += amount / math.pow(1 + rate, t);
        dnpv += -t * amount / math.pow(1 + rate, t + 1);
      }

      if (dnpv.abs() < 1e-10) break;
      final newRate = rate - npv / dnpv;
      if ((newRate - rate).abs() < 1e-8) {
        rate = newRate;
        break;
      }
      rate = newRate;
    }

    return rate * 100;
  }

  // ========== MARKET DATA ==========

  /// Fetch market indices (Sensex, Nifty) from Yahoo Finance
  static Future<List<MarketData>> fetchMarketIndices() async {
    try {
      final symbols = ['^BSESN', '^NSEI', 'GOLDBEES.NS', 'NIFTYBEES.NS'];
      final List<MarketData> results = [];

      for (final symbol in symbols) {
        try {
          final response = await http.get(
            Uri.parse('$_nseBase/$symbol?interval=1d&range=1d'),
            headers: {
              'User-Agent': 'Mozilla/5.0',
              'Accept': 'application/json',
            },
          ).timeout(const Duration(seconds: 8));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final result = data['chart']['result'][0];
            final meta = result['meta'];
            final price = (meta['regularMarketPrice'] as num?)?.toDouble() ?? 0;
            final prevClose = (meta['previousClose'] as num?)?.toDouble() ?? price;
            final change = price - prevClose;

            results.add(MarketData(
              symbol: symbol,
              name: _getIndexName(symbol),
              price: price,
              change: change,
              changePercent: prevClose > 0 ? (change / prevClose) * 100 : 0,
              dayHigh: (meta['regularMarketDayHigh'] as num?)?.toDouble() ?? price,
              dayLow: (meta['regularMarketDayLow'] as num?)?.toDouble() ?? price,
              exchange: symbol.contains('BSESN') ? 'BSE' : 'NSE',
              timestamp: DateTime.now(),
            ));
          }
        } catch (_) {}
      }

      return results.isEmpty ? _getMockMarketData() : results;
    } catch (e) {
      return _getMockMarketData();
    }
  }

  static String _getIndexName(String symbol) {
    switch (symbol) {
      case '^BSESN': return 'SENSEX';
      case '^NSEI': return 'NIFTY 50';
      case 'GOLDBEES.NS': return 'GOLD';
      case 'NIFTYBEES.NS': return 'NIFTY ETF';
      default: return symbol;
    }
  }

  // ========== FD RATES ==========

  /// Fetch latest FD rates (from public data)
  static Future<List<Map<String, dynamic>>> fetchFDRates() async {
    // Returns curated FD rates - in production would scrape bank websites
    return [
      {'bank': 'SBI', 'rate_1yr': 6.80, 'rate_3yr': 6.50, 'rate_5yr': 6.50, 'senior_benefit': 0.50},
      {'bank': 'HDFC Bank', 'rate_1yr': 7.10, 'rate_3yr': 7.00, 'rate_5yr': 7.00, 'senior_benefit': 0.50},
      {'bank': 'ICICI Bank', 'rate_1yr': 7.10, 'rate_3yr': 7.00, 'rate_5yr': 7.00, 'senior_benefit': 0.50},
      {'bank': 'Axis Bank', 'rate_1yr': 7.10, 'rate_3yr': 7.10, 'rate_5yr': 7.00, 'senior_benefit': 0.50},
      {'bank': 'Kotak Mahindra', 'rate_1yr': 7.10, 'rate_3yr': 6.90, 'rate_5yr': 6.90, 'senior_benefit': 0.50},
      {'bank': 'Post Office SCSS', 'rate_1yr': 8.20, 'rate_3yr': 8.20, 'rate_5yr': 8.20, 'senior_benefit': 0.00},
      {'bank': 'Bajaj Finance FD', 'rate_1yr': 7.90, 'rate_3yr': 8.05, 'rate_5yr': 8.05, 'senior_benefit': 0.25},
      {'bank': 'Small Finance Banks', 'rate_1yr': 8.50, 'rate_3yr': 8.75, 'rate_5yr': 8.50, 'senior_benefit': 0.50},
    ];
  }

  // ========== PPF / NPS / GOVT SCHEMES ==========

  static Map<String, dynamic> getGovernmentSchemeRates() {
    return {
      'PPF': {
        'rate': 7.1,
        'lock_in': '15 years',
        'tax_benefit': '80C',
        'tax_on_returns': 'EEE - Fully Tax Free',
        'min_investment': 500,
        'max_investment': 150000,
      },
      'ELSS': {
        'rate': '12-15% (market linked)',
        'lock_in': '3 years',
        'tax_benefit': '80C',
        'tax_on_returns': 'LTCG 10% above 1L',
        'min_investment': 500,
        'max_investment': 150000,
      },
      'NPS_TIER1': {
        'rate': '9-12% (market linked)',
        'lock_in': 'Till 60 years',
        'tax_benefit': '80CCD(1B) - Additional 50,000',
        'tax_on_returns': '60% tax free on maturity',
        'min_investment': 1000,
        'max_investment': 'No limit',
      },
      'SSY': {
        'rate': 8.2,
        'lock_in': '21 years',
        'tax_benefit': '80C',
        'tax_on_returns': 'EEE - Fully Tax Free',
        'min_investment': 250,
        'max_investment': 150000,
        'eligibility': 'For girl child below 10 years',
      },
      'NSC': {
        'rate': 7.7,
        'lock_in': '5 years',
        'tax_benefit': '80C',
        'tax_on_returns': 'Taxable',
        'min_investment': 1000,
        'max_investment': 'No limit',
      },
      'SCSS': {
        'rate': 8.2,
        'lock_in': '5 years',
        'tax_benefit': '80C',
        'tax_on_returns': 'Taxable',
        'eligibility': '60+ years',
        'max_investment': 3000000,
      },
    };
  }

  // ========== INFLATION DATA ==========

  static Future<double> fetchCurrentInflationRate() async {
    // India CPI - using fallback data aligned with RBI data
    // In production: scrape from mospi.gov.in or RBI website
    try {
      final response = await http.get(
        Uri.parse('https://api.worldbank.org/v2/country/IN/indicator/FP.CPI.TOTL.ZG?format=json&mrv=1'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final value = data[1]?[0]?['value'];
        if (value != null) return (value as num).toDouble();
      }
    } catch (_) {}
    return 5.5; // Fallback: India's avg inflation
  }

  // ========== FIRE CALCULATOR ==========

  static FirePlan calculateFirePlan({
    required int currentAge,
    required int targetRetirementAge,
    required double monthlyExpenses,
    required double existingCorpus,
    required double monthlyInvestment,
    double expectedReturns = 12.0,
    double inflationRate = 6.0,
    double withdrawalRate = 4.0, // 4% rule
  }) {
    // Calculate FIRE number (25x annual expenses adjusted for inflation)
    final yearsToRetirement = targetRetirementAge - currentAge;
    final inflatedMonthlyExpenses = monthlyExpenses *
        math.pow(1 + inflationRate / 100, yearsToRetirement);
    final annualExpensesAtRetirement = inflatedMonthlyExpenses * 12;
    final fireNumber = annualExpensesAtRetirement / (withdrawalRate / 100);

    // Project corpus growth
    final List<FireMilestone> milestones = [];
    double corpus = existingCorpus;
    final monthlyRate = expectedReturns / 100 / 12;

    for (int year = 1; year <= yearsToRetirement; year++) {
      for (int month = 0; month < 12; month++) {
        corpus = corpus * (1 + monthlyRate) + monthlyInvestment;
      }

      String milestone = '';
      if (year == 1) milestone = '🌱 Journey begins';
      else if (corpus >= fireNumber * 0.25) milestone = '25% of FIRE 🎯';
      else if (corpus >= fireNumber * 0.50) milestone = '50% of FIRE 🔥';
      else if (corpus >= fireNumber * 0.75) milestone = '75% of FIRE ⚡';
      else if (corpus >= fireNumber) milestone = '🎉 FIRE ACHIEVED!';

      milestones.add(FireMilestone(
        year: DateTime.now().year + year,
        age: currentAge + year,
        projectedCorpus: corpus,
        monthlySip: monthlyInvestment,
        milestone: milestone,
      ));
    }

    return FirePlan(
      currentAge: currentAge,
      targetRetirementAge: targetRetirementAge,
      currentMonthlyExpenses: monthlyExpenses,
      existingCorpus: existingCorpus,
      monthlyInvestment: monthlyInvestment,
      expectedReturns: expectedReturns,
      inflationRate: inflationRate,
      milestones: milestones,
      targetCorpus: fireNumber,
      fireNumber: fireNumber,
    );
  }

  // ========== SIP CALCULATOR ==========

  static double calculateSIPReturns({
    required double monthlyAmount,
    required double annualRate,
    required int years,
  }) {
    final months = years * 12;
    final monthlyRate = annualRate / 100 / 12;
    if (monthlyRate == 0) return monthlyAmount * months;
    return monthlyAmount * ((math.pow(1 + monthlyRate, months) - 1) / monthlyRate) * (1 + monthlyRate);
  }

  static double calculateLumpSumReturns({
    required double amount,
    required double annualRate,
    required int years,
  }) {
    return amount * math.pow(1 + annualRate / 100, years);
  }

  // ========== EMI CALCULATOR ==========

  static double calculateEMI({
    required double principal,
    required double annualRate,
    required int months,
  }) {
    final monthlyRate = annualRate / 100 / 12;
    if (monthlyRate == 0) return principal / months;
    return principal * monthlyRate * math.pow(1 + monthlyRate, months) /
        (math.pow(1 + monthlyRate, months) - 1);
  }

  // ========== MONEY HEALTH SCORE ==========

  static MoneyHealthScore calculateMoneyHealthScore({
    required double monthlyIncome,
    required double monthlyExpenses,
    required double emergencyFund,
    required double totalInsuranceCover,
    required double totalInvestments,
    required double totalDebt,
    required double age,
    required double retirementCorpus,
    required double taxSavings,
  }) {
    // Emergency Fund Score (6 months expenses = 100)
    final emergencyMonths = emergencyFund / monthlyExpenses;
    final emergencyScore = (emergencyMonths / 6 * 100).clamp(0, 100).toDouble();

    // Insurance Score (10x annual income = 100)
    final annualIncome = monthlyIncome * 12;
    final insuranceRatio = totalInsuranceCover / annualIncome;
    final insuranceScore = (insuranceRatio / 10 * 100).clamp(0, 100).toDouble();

    // Investment Score (30%+ savings rate = 100)
    final savingsRate = ((monthlyIncome - monthlyExpenses) / monthlyIncome) * 100;
    final investmentScore = (savingsRate / 30 * 100).clamp(0, 100).toDouble();

    // Debt Score (debt < 40% income = 100, debt-free = 100)
    final debtToIncome = totalDebt / annualIncome;
    final debtScore = totalDebt == 0 ? 100.0 : (math.max(0, 1 - debtToIncome / 0.4) * 100).clamp(0, 100).toDouble();

    // Tax Score
    final taxEfficiency = (taxSavings / 150000 * 100).clamp(0, 100).toDouble();

    // Retirement Score (target: 25x annual expenses at 60)
    final yearsToRetirement = math.max(1, 60 - age);
    final targetCorpus = monthlyExpenses * 12 * 25 * math.pow(1.06, yearsToRetirement);
    final retirementScore = (retirementCorpus / targetCorpus * 100).clamp(0, 100).toDouble();

    return MoneyHealthScore(
      emergencyScore: emergencyScore,
      insuranceScore: insuranceScore,
      investmentScore: investmentScore,
      debtScore: debtScore,
      taxScore: taxEfficiency,
      retirementScore: retirementScore,
      calculatedAt: DateTime.now(),
    );
  }

  // ========== MOCK DATA FALLBACKS ==========

  static List<Map<String, dynamic>> _getMockMFList() {
    return [
      {'schemeCode': '119551', 'schemeName': 'Axis Bluechip Fund - Direct Plan Growth'},
      {'schemeCode': '120503', 'schemeName': 'Mirae Asset Large Cap Fund - Direct Plan Growth'},
      {'schemeCode': '125354', 'schemeName': 'Parag Parikh Flexi Cap Fund - Direct Growth'},
      {'schemeCode': '119598', 'schemeName': 'HDFC Mid-Cap Opportunities Fund - Direct Growth'},
      {'schemeCode': '120828', 'schemeName': 'Canara Robeco Small Cap Fund - Direct Growth'},
      {'schemeCode': '122639', 'schemeName': 'Axis Long Term Equity Fund (ELSS) - Direct Growth'},
      {'schemeCode': '119533', 'schemeName': 'SBI Bluechip Fund - Direct Plan Growth'},
      {'schemeCode': '125497', 'schemeName': 'Kotak Flexi Cap Fund - Direct Growth'},
    ];
  }

  static List<Map<String, dynamic>> _getMockMFSearchResults(String query) {
    return _getMockMFList()
        .where((f) => f['schemeName'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static Map<String, dynamic> _getMockNAVHistory(String schemeCode) {
    final navData = <Map<String, dynamic>>[];
    double nav = 100.0;
    final now = DateTime.now();

    for (int i = 365; i >= 0; i--) {
      nav += (math.Random().nextDouble() - 0.48) * 2;
      nav = nav.clamp(50, 500);
      final date = now.subtract(Duration(days: i));
      navData.add({
        'date': '${date.day.toString().padLeft(2,'0')}-${date.month.toString().padLeft(2,'0')}-${date.year}',
        'nav': nav.toStringAsFixed(4),
      });
    }

    return {
      'meta': {
        'fund_house': 'Sample Fund House',
        'scheme_type': 'Open Ended Schemes',
        'scheme_category': 'Equity Scheme - Large Cap Fund',
        'scheme_code': schemeCode,
        'scheme_name': 'Sample Equity Fund - Direct Growth',
      },
      'data': navData,
      'status': 'SUCCESS',
    };
  }

  static List<MarketData> _getMockMarketData() {
    return [
      MarketData(symbol: '^BSESN', name: 'SENSEX', price: 73847.25, change: 234.50, changePercent: 0.32, dayHigh: 74100.0, dayLow: 73500.0, exchange: 'BSE', timestamp: DateTime.now()),
      MarketData(symbol: '^NSEI', name: 'NIFTY 50', price: 22405.60, change: 68.30, changePercent: 0.31, dayHigh: 22500.0, dayLow: 22300.0, exchange: 'NSE', timestamp: DateTime.now()),
      MarketData(symbol: 'GOLD', name: 'GOLD (MCX)', price: 72450.0, change: -120.0, changePercent: -0.17, dayHigh: 72800.0, dayLow: 72300.0, exchange: 'MCX', timestamp: DateTime.now()),
    ];
  }

  // ========== ASSET ALLOCATION RECOMMENDATION ==========

  static Map<String, double> recommendAssetAllocation({
    required String riskProfile,
    required int age,
  }) {
    // Rule of thumb: 100 - age = equity %
    final equityPercent = (100 - age).clamp(20, 80).toDouble();

    switch (riskProfile) {
      case 'aggressive':
        return {
          'Large Cap Equity': equityPercent * 0.40,
          'Mid Cap Equity': equityPercent * 0.30,
          'Small Cap Equity': equityPercent * 0.20,
          'International Equity': equityPercent * 0.10,
          'Debt/Bonds': (100 - equityPercent) * 0.70,
          'Gold': (100 - equityPercent) * 0.20,
          'Cash/Liquid': (100 - equityPercent) * 0.10,
        };
      case 'moderate':
        return {
          'Large Cap Equity': equityPercent * 0.50,
          'Mid Cap Equity': equityPercent * 0.30,
          'Small Cap Equity': equityPercent * 0.10,
          'International Equity': equityPercent * 0.10,
          'Debt/Bonds': (100 - equityPercent) * 0.60,
          'Gold': (100 - equityPercent) * 0.25,
          'Cash/Liquid': (100 - equityPercent) * 0.15,
        };
      default: // conservative
        return {
          'Large Cap Equity': equityPercent * 0.60,
          'Mid Cap Equity': equityPercent * 0.20,
          'Small Cap Equity': equityPercent * 0.05,
          'International Equity': equityPercent * 0.15,
          'Debt/Bonds': (100 - equityPercent) * 0.55,
          'Gold': (100 - equityPercent) * 0.25,
          'Cash/Liquid': (100 - equityPercent) * 0.20,
        };
    }
  }
}
