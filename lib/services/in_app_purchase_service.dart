import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'pro_access_service.dart';

class InAppPurchaseService extends ChangeNotifier {
  static final InAppPurchaseService _instance = InAppPurchaseService._internal();
  factory InAppPurchaseService() => _instance;
  InAppPurchaseService._internal();

  static const String proLifetimeId = 'pam_pro_lifetime';
  static const Set<String> _kProductIds = {proLifetimeId};

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isAvailable = false;
  bool _isLoading = false;
  bool _purchasePending = false;
  ProductDetails? _proProduct;
  String? _lastError;

  bool get isAvailable => _isAvailable;
  bool get isLoading => _isLoading;
  bool get purchasePending => _purchasePending;
  ProductDetails? get proProduct => _proProduct;
  String? get lastError => _lastError;

  String get formattedPrice => _proProduct?.price ?? 'R$ 19,90';

  Future<void> initialize() async {
    // Escuta a stream de compras da loja (obrigatório desde o arranque do app)
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        debugPrint('IAP: Erro na stream de compras: $error');
      },
    );

    await queryProductDetails();
  }

  Future<void> queryProductDetails() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isAvailable = await _iap.isAvailable();
      if (!_isAvailable) {
        debugPrint('IAP: Loja não disponível neste dispositivo/plataforma.');
        _isLoading = false;
        notifyListeners();
        return;
      }

      final ProductDetailsResponse response =
          await _iap.queryProductDetails(_kProductIds);

      if (response.error != null) {
        _lastError = response.error!.message;
        debugPrint('IAP: Erro ao consultar produtos: ${response.error}');
      }

      if (response.productDetails.isNotEmpty) {
        _proProduct = response.productDetails.firstWhere(
          (p) => p.id == proLifetimeId,
          orElse: () => response.productDetails.first,
        );
      }
    } catch (e) {
      debugPrint('IAP: Exceção ao consultar produto: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> buyPro() async {
    _lastError = null;

    if (!_isAvailable || _proProduct == null) {
      // Se a loja não estiver disponível no ambiente (ex: Chrome Web ou Emulador sem Play Store)
      debugPrint('IAP: Compra nativa indisponível no ambiente atual.');
      return false;
    }

    _purchasePending = true;
    notifyListeners();

    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: _proProduct!,
      );

      final bool success = await _iap.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      return success;
    } catch (e) {
      _purchasePending = false;
      _lastError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> restorePurchases() async {
    _lastError = null;
    _isLoading = true;
    notifyListeners();

    try {
      if (_isAvailable) {
        await _iap.restorePurchases();
      } else {
        // Fallback para persistência local
        await ProAccessService().restorePurchase();
      }
    } catch (e) {
      _lastError = e.toString();
      debugPrint('IAP: Erro ao restaurar compras: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        _purchasePending = true;
        notifyListeners();
      } else {
        if (purchase.status == PurchaseStatus.error) {
          _purchasePending = false;
          _lastError = purchase.error?.message ?? 'Erro ao processar compra.';
          notifyListeners();
        } else if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          if (purchase.productID == proLifetimeId) {
            await ProAccessService().unlockProLifetime();
          }
          _purchasePending = false;
          notifyListeners();
        }

        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

