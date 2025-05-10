
class CartItemModel {
  final String imageUrl;
  final String title;
  final String size;
  final int price;
  int quantity;

  CartItemModel({
    required this.imageUrl,
    required this.title,
    required this.size,
    required this.price,
    required this.quantity,
  });
}
