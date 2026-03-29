import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class AiChatService {
  // Uses Claude API for AI-powered financial advice
  // API key should be stored securely in production
  static const String _apiEndpoint = 'https://api.anthropic.com/v1/messages';

  // In production, store this in secure storage / env vars
  // For demo: replace with your Anthropic API key
  static const String _apiKey = 'AIzaSyD21hG9I8gch2JHtRKeLSykJwU2eps1tp8';

  static const String _systemPrompt =
      '''You are ET Money Mentor, India's most trusted AI-powered personal finance advisor. You are an expert in:

1. Indian tax laws (Income Tax Act, 80C, 80D, HRA, NPS, etc.)
2. Mutual funds, SIPs, and Indian stock markets (NSE/BSE)
3. FIRE (Financial Independence, Retire Early) planning for Indians
4. Insurance (term, health, ULIP analysis)
5. Indian government schemes (PPF, NPS, SCSS, SSY, NSC)
6. Real estate investment in India
7. GST and tax filing
8. RBI guidelines and banking products

Rules:
- Always give advice specific to India (use ₹, INR)
- Be concise but comprehensive
- Use simple language that a common Indian can understand  
- Always mention tax implications
- Recommend low-cost index funds and direct plans when appropriate
- Never recommend specific stocks (only categories/indices)
- Always advise consulting a registered financial advisor for large decisions
- Be encouraging and positive
- Use Indian cultural context (e.g., mention festivals for insurance needs, school fee seasons for goal planning)
- Mention inflation rate of ~6% for long-term projections
- Reference SEBI guidelines where applicable

Format responses with:
- Clear headers using emojis
- Bullet points for lists
- Specific numbers and calculations when relevant
- Action items at the end''';

  static Future<String> sendMessage({
    required String userMessage,
    required List<ChatMessage> conversationHistory,
    UserProfile? userProfile,
  }) async {
    try {
      // Build messages array for context
      final messages = <Map<String, dynamic>>[];

      // Add user context if available
      if (userProfile != null) {
        messages.add({
          'role': 'user',
          'content': '''My financial profile:
- Age: ${userProfile.age} years
- Monthly Income: ₹${_formatNumber(userProfile.monthlyIncome)}
- Monthly Expenses: ₹${_formatNumber(userProfile.monthlyExpenses)}
- Existing Investments: ₹${_formatNumber(userProfile.existingInvestments)}
- Risk Profile: ${userProfile.riskProfile}
- Tax Regime: ${userProfile.taxRegime}
Please keep this in mind for all advice.''',
        });
        messages.add({
          'role': 'assistant',
          'content':
              'Understood! I have your financial profile loaded. I will personalize all my recommendations based on your income, expenses, risk tolerance, and existing investments. How can I help you today?',
        });
      }

      // Add conversation history (last 10 messages for context)
      final recentHistory = conversationHistory.length > 10
          ? conversationHistory.sublist(conversationHistory.length - 10)
          : conversationHistory;

      for (final msg in recentHistory) {
        messages.add({
          'role': msg.isUser ? 'user' : 'assistant',
          'content': msg.content,
        });
      }

      // Add current message
      messages.add({
        'role': 'user',
        'content': userMessage,
      });

      final response = await http
          .post(
            Uri.parse(_apiEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': _apiKey,
              'anthropic-version': '2023-06-01',
            },
            body: json.encode({
              'model': 'claude-3-5-haiku-20241022',
              'max_tokens': 1024,
              'system': _systemPrompt,
              'messages': messages,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['content'][0]['text'] as String;
      } else if (response.statusCode == 401) {
        return _getLocalResponse(userMessage, userProfile);
      } else {
        return _getLocalResponse(userMessage, userProfile);
      }
    } catch (e) {
      return _getLocalResponse(userMessage, userProfile);
    }
  }

  // Local fallback responses when API is unavailable
  static String _getLocalResponse(String message, UserProfile? profile) {
    final msg = message.toLowerCase();

    if (msg.contains('sip') || msg.contains('mutual fund')) {
      return '''## 📈 SIP & Mutual Fund Guidance

**Why SIP is India's best investment option:**
- Rupee cost averaging reduces market timing risk
- Start with as little as ₹500/month
- Direct plans save 0.5-1% expense ratio vs regular plans

**Recommended SIP allocation (for moderate risk):**
- 40% Large Cap / Index Fund (Nifty 50)
- 30% Flexi Cap Fund
- 20% Mid Cap Fund  
- 10% International Fund

**Top categories to consider:**
- 🏆 Index Funds: Lowest cost, market returns
- ⚡ ELSS: Tax saving under 80C + wealth creation
- 🌍 International: Diversification in USD

**Action Items:**
✅ Start with Index Fund SIP
✅ Use Direct plans on MF Central / Groww / Zerodha
✅ Increase SIP by 10% every year
✅ Never stop SIP during market falls''';
    }

    if (msg.contains('tax') || msg.contains('80c') || msg.contains('itr')) {
      return '''## 💰 Tax Saving Guide FY 2024-25

**Section 80C Deductions (Max ₹1.5 Lakh):**
- ELSS Mutual Funds (best for wealth + tax)
- PPF contributions
- EPF contributions (already deducted)
- Home loan principal repayment
- Life insurance premium

**Section 80D - Health Insurance:**
- Self & family: Up to ₹25,000
- Senior citizen parents: Up to ₹50,000
- Total: Up to ₹75,000

**Additional Deductions:**
- NPS 80CCD(1B): ₹50,000 extra
- HRA exemption: Based on city
- 80E Education loan interest
- 24B Home loan interest: Up to ₹2 Lakh

**Old vs New Regime:**
- New regime better if deductions < ₹3.75L
- Old regime better if you have home loan + NPS + HRA

**Action Items:**
✅ Maximize 80C by March 31st
✅ Buy health insurance for 80D benefit
✅ Consider NPS for extra ₹50,000 deduction
✅ Use HRA calculator if you pay rent''';
    }

    if (msg.contains('fire') ||
        msg.contains('retire') ||
        msg.contains('financial independence')) {
      return '''## 🔥 FIRE - Financial Independence Guide

**What is FIRE?**
Financial Independence = Building a corpus of 25x your annual expenses

**Calculate Your FIRE Number:**
Monthly expenses × 12 × 25 = Target corpus
Example: ₹50,000/month × 12 × 25 = **₹1.5 Crore**

**Indian FIRE Framework:**
1. **Lean FIRE**: 15-20x expenses (frugal lifestyle)
2. **Regular FIRE**: 25x expenses (current lifestyle)
3. **Fat FIRE**: 30-40x expenses (comfortable lifestyle)

**The 4% Withdrawal Rule:**
Withdraw 4% of corpus annually = never running out of money

**SIP to reach FIRE:**
- Start early (every 10 years doubles the corpus needed)
- Invest 30-40% of income
- Expected returns: 12% equity, 7% debt

**Action Items:**
✅ Calculate your FIRE number
✅ Start SIP today - even ₹5,000/month matters
✅ Track net worth monthly
✅ Increase income (skills, side income)
✅ Reduce lifestyle inflation''';
    }

    if (msg.contains('emergency fund') || msg.contains('savings')) {
      return '''## 🏦 Emergency Fund Strategy

**The Golden Rule: 6 months of expenses**

If monthly expenses = ₹40,000
Emergency Fund Target = ₹2,40,000

**Where to keep Emergency Fund:**
1. **High-yield Savings Account** (4-5% interest)
   - SBI/HDFC Savings Account
   
2. **Liquid Mutual Funds** (5-7% returns, T+1 redemption)
   - Parag Parikh Liquid Fund
   - HDFC Liquid Fund

3. **Sweep FDs** (6-7%, instant access)
   - Link FD to savings account

**Never keep emergency fund in:**
❌ Equity mutual funds (volatile)
❌ PPF (locked for 15 years)
❌ Stocks (unpredictable)

**Build it in 12 months:**
Save ₹20,000/month → ₹2.4L in 12 months

**Action Items:**
✅ Open liquid fund account today
✅ Set up auto-debit on salary day
✅ Don't touch it for non-emergencies''';
    }

    // Default response
    return '''## 🤖 ET Money Mentor

I'm your AI financial advisor specializing in Indian personal finance!

**I can help you with:**
- 📈 **SIP & Mutual Funds** - Best funds, allocation strategy
- 💰 **Tax Planning** - 80C, 80D, HRA, NPS optimization
- 🔥 **FIRE Planning** - Retire early roadmap
- 🏥 **Insurance** - Term life, health insurance
- 🏦 **Emergency Fund** - How much and where
- 💳 **Debt Management** - EMI optimization
- 🏠 **Real Estate vs Mutual Funds** - Honest comparison
- 👫 **Couple Planning** - Joint financial planning

**Quick Tips:**
✅ Start investing today, not tomorrow
✅ Index funds beat most active funds
✅ Insurance is protection, not investment
✅ Tax saving is a bonus, not primary goal

Ask me anything about your finances! 💚''';
  }

  static String _formatNumber(double number) {
    if (number >= 10000000)
      return '${(number / 10000000).toStringAsFixed(1)}Cr';
    if (number >= 100000) return '${(number / 100000).toStringAsFixed(1)}L';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
    return number.toStringAsFixed(0);
  }

  static List<Map<String, String>> getQuickQuestions() {
    return [
      {'question': 'How much SIP should I start with?', 'category': 'sip'},
      {'question': 'How to save tax under 80C?', 'category': 'tax'},
      {'question': 'What is my FIRE number?', 'category': 'fire'},
      {
        'question': 'How much life insurance do I need?',
        'category': 'insurance'
      },
      {'question': 'Old vs New tax regime for me?', 'category': 'tax'},
      {'question': 'Best ELSS funds to invest in?', 'category': 'mf'},
      {'question': 'How to build emergency fund?', 'category': 'savings'},
      {'question': 'PPF vs ELSS - which is better?', 'category': 'comparison'},
    ];
  }
}
