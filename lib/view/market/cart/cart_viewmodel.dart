import 'package:flutter/material.dart';
import 'package:lenat_mobile/models/cart_model.dart';
import 'package:lenat_mobile/services/cart_service.dart';

class CartViewModel extends ChangeNotifier {
  final CartService _cartService = CartService();
  
  List<CartItemModel> _cartItems = [];
  bool _isLoading = false;
  String? _error;
  CartTotals _totals = CartTotals(subtotal: 0, deliveryFee: 0, total: 0);

  // Getters
  List<CartItemModel> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get error => _error;
  CartTotals get totals => _totals;
  bool get isEmpty => _cartItems.isEmpty;

  // Initialize cart
  Future<void> loadCart() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _cartItems = await _cartService.getCartItems();
      await _calculateTotals();
      
    } catch (e) {
      _error = 'Failed to load cart: $e';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Increase item quantity
  Future<void> increaseQuantity(int index) async {
    if (index < 0 || index >= _cartItems.length) return;
    
    final item = _cartItems[index];
    await _cartService.updateQuantity(
      item.productId, 
      item.size, 
      item.color, 
      item.quantity + 1
    );
    
    _cartItems[index] = item.copyWith(quantity: item.quantity + 1);
    await _calculateTotals();
    notifyListeners();
  }

  // Decrease item quantity
  Future<void> decreaseQuantity(int index) async {
    if (index < 0 || index >= _cartItems.length) return;
    
    final item = _cartItems[index];
    if (item.quantity <= 1) return;
    
    await _cartService.updateQuantity(
      item.productId, 
      item.size, 
      item.color, 
      item.quantity - 1
    );
    
    _cartItems[index] = item.copyWith(quantity: item.quantity - 1);
    await _calculateTotals();
    notifyListeners();
  }

  // Remove item from cart
  Future<void> removeItem(int index) async {
    if (index < 0 || index >= _cartItems.length) return;
    
    final item = _cartItems[index];
    await _cartService.removeFromCart(
      item.productId, 
      item.size, 
      item.color
    );
    
    _cartItems.removeAt(index);
    await _calculateTotals();
    notifyListeners();
  }

  // Clear cart
  Future<void> clearCart() async {
    await _cartService.clearCart();
    _cartItems = [];
    await _calculateTotals();
    notifyListeners();
  }

  // Calculate totals
  Future<void> _calculateTotals() async {
    _totals = await _cartService.calculateTotals();
  }

  // Format price with currency
  String formatPrice(int price) {
    return '$price ብር';
  }
}
