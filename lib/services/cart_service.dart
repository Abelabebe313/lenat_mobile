import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lenat_mobile/models/cart_model.dart';
import 'package:lenat_mobile/models/market_product_model.dart';

class CartService {
  static const String _cartKey = 'user_cart';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Get all cart items
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final String? cartData = await _secureStorage.read(key: _cartKey);
      if (cartData == null || cartData.isEmpty) {
        return [];
      }

      final List<dynamic> decodedData = jsonDecode(cartData);
      return decodedData.map((item) => CartItemModel.fromJson(item)).toList();
    } catch (e) {
      print('Error getting cart items: $e');
      return [];
    }
  }

  // Save cart items
  Future<void> saveCartItems(List<CartItemModel> items) async {
    try {
      final String encodedData = jsonEncode(items.map((item) => item.toJson()).toList());
      await _secureStorage.write(key: _cartKey, value: encodedData);
    } catch (e) {
      print('Error saving cart items: $e');
    }
  }

  // Add product to cart
  Future<void> addToCart(MarketPlaceModel product, {String? selectedSize, String? selectedColor, int quantity = 1}) async {
    try {
      final List<CartItemModel> currentCart = await getCartItems();
      
      // Check if product already exists in cart with same size and color
      final int existingIndex = currentCart.indexWhere(
        (item) => item.productId == product.id && 
                  item.size == selectedSize && 
                  item.color == selectedColor
      );

      if (existingIndex >= 0) {
        // Update quantity if product already exists
        currentCart[existingIndex] = currentCart[existingIndex].copyWith(
          quantity: currentCart[existingIndex].quantity + quantity
        );
      } else {
        // Add new item if product doesn't exist
        currentCart.add(
          CartItemModel(
            productId: product.id,
            imageUrl: product.mainImageUrl,
            title: product.name,
            size: selectedSize,
            color: selectedColor,
            price: product.price,
            quantity: quantity,
          )
        );
      }

      await saveCartItems(currentCart);
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  // Update cart item quantity
  Future<void> updateQuantity(String productId, String? size, String? color, int quantity) async {
    try {
      final List<CartItemModel> currentCart = await getCartItems();
      
      final int index = currentCart.indexWhere(
        (item) => item.productId == productId && 
                  item.size == size && 
                  item.color == color
      );

      if (index >= 0) {
        currentCart[index] = currentCart[index].copyWith(quantity: quantity);
        await saveCartItems(currentCart);
      }
    } catch (e) {
      print('Error updating cart quantity: $e');
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String productId, String? size, String? color) async {
    try {
      final List<CartItemModel> currentCart = await getCartItems();
      
      final updatedCart = currentCart.where(
        (item) => !(item.productId == productId && 
                   item.size == size && 
                   item.color == color)
      ).toList();

      await saveCartItems(updatedCart);
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      await _secureStorage.delete(key: _cartKey);
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }

  // Calculate cart totals
  Future<CartTotals> calculateTotals({double deliveryFeePerKm = 200.0, double distanceInKm = 1.0}) async {
    try {
      final List<CartItemModel> items = await getCartItems();
      
      int subtotal = 0;
      for (var item in items) {
        subtotal += item.totalPrice;
      }

      final double deliveryFee = deliveryFeePerKm * distanceInKm;
      final double total = subtotal + deliveryFee;

      return CartTotals(
        subtotal: subtotal,
        deliveryFee: deliveryFee.toInt(),
        total: total.toInt(),
      );
    } catch (e) {
      print('Error calculating cart totals: $e');
      return CartTotals(subtotal: 0, deliveryFee: 0, total: 0);
    }
  }
}

class CartTotals {
  final int subtotal;
  final int deliveryFee;
  final int total;

  CartTotals({
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });
} 