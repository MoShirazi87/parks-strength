import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../main.dart';

/// Service for handling subscriptions via RevenueCat
class SubscriptionService {
  static const String _apiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: 'YOUR_REVENUECAT_API_KEY',
  );

  static const String _entitlementId = 'premium';

  /// Initialize RevenueCat
  Future<void> initialize() async {
    final userId = supabase.auth.currentUser?.id;

    await Purchases.configure(
      PurchasesConfiguration(_apiKey)
        ..appUserID = userId,
    );
  }

  /// Check if user has premium access
  Future<bool> hasPremiumAccess() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey(_entitlementId);
    } catch (e) {
      return false;
    }
  }

  /// Get available offerings
  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      return null;
    }
  }

  /// Purchase a package
  Future<bool> purchase(Package package) async {
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      return customerInfo.entitlements.active.containsKey(_entitlementId);
    } catch (e) {
      return false;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      return customerInfo.entitlements.active.containsKey(_entitlementId);
    } catch (e) {
      return false;
    }
  }

  /// Get current subscription info
  Future<Map<String, dynamic>?> getSubscriptionInfo() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final entitlement = customerInfo.entitlements.active[_entitlementId];
      
      if (entitlement == null) return null;

      return {
        'is_active': entitlement.isActive,
        'will_renew': entitlement.willRenew,
        'expiration_date': entitlement.expirationDate,
        'product_id': entitlement.productIdentifier,
      };
    } catch (e) {
      return null;
    }
  }

  /// Update user ID for purchases
  Future<void> setUserId(String userId) async {
    await Purchases.logIn(userId);
  }

  /// Log out user from purchases
  Future<void> logout() async {
    await Purchases.logOut();
  }
}

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService();
});

/// Provider for premium status
final isPremiumProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(subscriptionServiceProvider);
  return await service.hasPremiumAccess();
});

/// Provider for available offerings
final offeringsProvider = FutureProvider<Offerings?>((ref) async {
  final service = ref.watch(subscriptionServiceProvider);
  return await service.getOfferings();
});

