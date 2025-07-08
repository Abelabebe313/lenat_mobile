
class CartItemModel {
  final String productId;
  final String imageUrl;
  final String title;
  final String? size;
  final String? color;
  final int price;
  int quantity;

  CartItemModel({
    required this.productId,
    required this.imageUrl,
    required this.title,
    this.size,
    this.color,
    required this.price,
    required this.quantity,
  });

  // Calculate total price for this item
  int get totalPrice => price * quantity;

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'imageUrl': imageUrl,
      'title': title,
      'size': size,
      'color': color,
      'price': price,
      'quantity': quantity,
    };
  }

  // Create from JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as String,
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      size: json['size'] as String?,
      color: json['color'] as String?,
      price: json['price'] as int,
      quantity: json['quantity'] as int,
    );
  }

  // Create a copy with updated quantity
  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      productId: productId,
      imageUrl: imageUrl,
      title: title,
      size: size,
      color: color,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }
}
