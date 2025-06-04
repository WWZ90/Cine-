import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final offeringsProvider = FutureProvider<Offerings>((ref) async {
  return await Purchases.getOfferings();
});

final selectedPackageProvider = StateProvider<Package?>((ref) => null);

class PremiumStatusNotifier extends StateNotifier<bool> {
  PremiumStatusNotifier() : super(false) {
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      state = customerInfo.entitlements.active.containsKey('Pro');
    } catch (e) {
      state = false;
    }
  }

  Future<void> refreshStatus() async {
    await _loadStatus();
  }
}

final premiumStatusProvider =
    StateNotifierProvider<PremiumStatusNotifier, bool>(
      (ref) => PremiumStatusNotifier(),
    );
