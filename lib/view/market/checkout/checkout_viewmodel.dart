import 'package:flutter/material.dart';
import 'package:lenat_mobile/models/cart_model.dart';
import 'package:lenat_mobile/services/cart_service.dart';
import 'package:lenat_mobile/services/market_service.dart';

class CheckoutViewModel extends ChangeNotifier {
  final CartService _cartService = CartService();
  final MarketPlaceService _marketService = MarketPlaceService();

  List<CartItemModel> _cartItems = [];
  CartTotals _totals = CartTotals(subtotal: 0, deliveryFee: 0, total: 0);

  String _selectedPaymentMethod = 'cash';
  String _phoneNumber = '';
  String _address = '';

  bool _isLoading = false;
  String? _error;
  String? _orderId;
  bool _orderSuccess = false;

  // Getters
  List<CartItemModel> get cartItems => _cartItems;
  CartTotals get totals => _totals;
  String get selectedPaymentMethod => _selectedPaymentMethod;
  String get phoneNumber => _phoneNumber;
  String get address => _address;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get orderId => _orderId;
  bool get orderSuccess => _orderSuccess;

  // Initialize checkout data
  Future<void> loadCheckoutData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _cartItems = await _cartService.getCartItems();
      await _calculateTotals();
    } catch (e) {
      _error = 'Failed to load checkout data: $e';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Set payment method
  void setPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  // Set phone number
  void setPhoneNumber(String phone) {
    _phoneNumber = phone;
    notifyListeners();
  }

  // Set address
  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  // Place order
  Future<bool> placeOrder() async {
    try {
      _isLoading = true;
      _error = null;
      _orderSuccess = false;
      notifyListeners();

      // Validate inputs
      if (_phoneNumber.isEmpty) {
        _error = 'Phone number is required';
        return false;
      }

      if (_address.isEmpty) {
        _error = 'Address is required';
        return false;
      }

      // Prepare order items
      List<Map<String, dynamic>> orderItems = _cartItems.map((item) {
        Map<String, dynamic> orderItem = {
          'product_id': item.productId,
          'quantity': item.quantity,
        };

        // Add variant information if available
        if (item.size != null || item.color != null) {
          Map<String, dynamic> variant = {};
          if (item.size != null) variant['size'] = item.size;
          if (item.color != null) variant['color'] = item.color;
          orderItem['variant'] = variant;
        }

        return orderItem;
      }).toList();

      // Debug the items being sent
      print('Order items: $orderItems');

      try {
        // Create order
        final result = await _marketService.createOrder(orderItems);

        print('Order result: $result');

        // Check if the result contains success flag
        if (result.containsKey('success') && result['success'] == true) {
          // Get the order ID if available
          _orderId = result.containsKey('order_id')
              ? result['order_id']?.toString()
              : 'unknown';
          _orderSuccess = true;

          // Clear cart after successful order
          await _cartService.clearCart();
          return true;
        } else {
          // Get error message if available
          _error = result.containsKey('message')
              ? result['message']?.toString()
              : 'Failed to create order';
          return false;
        }
      } catch (e) {
        print('Error during order creation: $e');
        _error = 'Error creating order: $e';
        return false;
      }
    } catch (e) {
      _error = 'Failed to place order: $e';
      print(_error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Calculate totals
  Future<void> _calculateTotals() async {
    _totals = await _cartService.calculateTotals();
  }
}
