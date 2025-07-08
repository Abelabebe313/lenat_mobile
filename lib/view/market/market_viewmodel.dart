import 'package:flutter/material.dart';
import 'package:lenat_mobile/app/service_locator.dart';
import 'package:lenat_mobile/models/market_product_model.dart';
import 'package:lenat_mobile/services/market_service.dart';

class MarketViewModel extends ChangeNotifier {
  final _marketService = locator<MarketPlaceService>();
  List<MarketPlaceModel> _featuredProducts = [];
  List<String> _marketCatagory = [];

  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  List<MarketPlaceModel> get featuredProducts => _featuredProducts;
  List<String> get marketCatagory => _marketCatagory;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

  Future<void> loadFeaturedProducts() async {
    if (_isLoading) return;

    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      // Add a small delay to ensure any token refresh operations have completed
      await Future.delayed(const Duration(milliseconds: 300));
      final products = await _marketService.getFeaturedMarketPlaceProducts();
      _featuredProducts = products;
      _hasError = false;
    } catch (e) {
      print('Error in MarketViewModel.loadFeaturedProducts: $e');
      _hasError = true;
      _errorMessage = e.toString();

      // If this is a token-related error, we might want to handle it differently
      if (e.toString().toLowerCase().contains('token') ||
          e.toString().toLowerCase().contains('auth')) {
        _errorMessage = 'Authentication error. Please try again.';
      } else {
        _errorMessage =
            'Failed to load products. Please check your connection.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshFeaturedProducts() async {
    _featuredProducts = [];
    notifyListeners();
    await loadFeaturedProducts();
  }

  Future<void> loadMarketPlaceCatagory() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();
    try {
      final catagory = await _marketService.getMarketPlaceCatagory();
      _marketCatagory = catagory;
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
