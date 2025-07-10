import 'package:flutter/material.dart';
import 'package:lenat_mobile/app/service_locator.dart';
import 'package:lenat_mobile/models/catagory_model.dart';
import 'package:lenat_mobile/models/market_product_model.dart';
import 'package:lenat_mobile/services/market_service.dart';

class MarketViewModel extends ChangeNotifier {
  final _marketService = locator<MarketPlaceService>();
  List<MarketPlaceModel> _featuredProducts = [];
  List<MarketPlaceModel> _productsByCategory = [];
  List<CategoryModel> _marketCatagory = [];
  List<MarketPlaceModel> _searchResults = [];
  String _searchQuery = '';

  TextEditingController searchController = TextEditingController();

  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  List<MarketPlaceModel> get featuredProducts => _featuredProducts;
  List<MarketPlaceModel> get productsByCategory => _productsByCategory;
  List<CategoryModel> get marketCatagory => _marketCatagory;
  List<MarketPlaceModel> get searchResults => _searchResults;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

  // Search products
  void searchProducts(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _searchResults = [];
    } else {
      _searchResults = _featuredProducts.where((product) {
        final name = product.name?.toLowerCase() ?? '';
        final description = product.description?.toLowerCase() ?? '';
        return name.contains(_searchQuery) ||
            description.contains(_searchQuery);
      }).toList();
    }
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  Future<void> loadProductsByCategory(CategoryModel category) async {
    if (_isLoading) return;
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      // Add a small delay to ensure any token refresh operations have completed
      await Future.delayed(const Duration(milliseconds: 300));
      final products =
          await _marketService.getProductsbyCategory(category.id ?? '');
      _productsByCategory = products;
      _hasError = false;
    } catch (e) {
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

  Future<void> refreshProductsByCategory(CategoryModel category) async {
    _productsByCategory = [];
    notifyListeners();
    await loadProductsByCategory(category);
  }

  Future<void> loadFeaturedProducts() async {
    if (_isLoading) return;

    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      // Add a small delay to ensure any token refresh operations have completed
      await Future.delayed(const Duration(milliseconds: 300));
      final products = await _marketService.getFeaturedProducts();
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

  // Load product
  Future<void> loadMarketPlaceCatagory() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();
    try {
      final catagory = await _marketService.getMarketPlaceCatagory();
      _marketCatagory = catagory;
    } catch (e) {
      print("==>${e.toString()}");
      _hasError = true;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
