import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/financial_data_service.dart';

// User Profile Provider
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  return UserProfileNotifier();
});

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(null);

  void setProfile(UserProfile profile) => state = profile;

  void updateIncome(double income) {
    if (state != null) {
      state = state!.copyWith(monthlyIncome: income);
    }
  }

  void updateExpenses(double expenses) {
    if (state != null) {
      state = state!.copyWith(monthlyExpenses: expenses);
    }
  }

  void addGoal(FinancialGoal goal) {
    if (state != null) {
      state = state!.copyWith(goals: [...state!.goals, goal]);
    }
  }
}

// Market Data Provider
final marketDataProvider = FutureProvider<List<MarketData>>((ref) async {
  return FinancialDataService.fetchMarketIndices();
});

// Money Health Score Provider
final moneyHealthProvider = StateProvider<MoneyHealthScore?>((ref) => null);

// FIRE Plan Provider
final firePlanProvider = StateProvider<FirePlan?>((ref) => null);

// Chat Messages Provider
final chatMessagesProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier() : super([]);

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  void clearMessages() {
    state = [];
  }
}

// Selected Life Event Provider
final selectedLifeEventProvider = StateProvider<String?>((ref) => null);

// Tax Calculation Provider  
final taxCalculationProvider = StateProvider<TaxCalculation?>((ref) => null);
