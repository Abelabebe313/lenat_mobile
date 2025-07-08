class MarketPlaceModel {
  String id;
  String userId;
  bool isActive;
  bool isFeatured;
  String name;
  String description;
  int price;
  Variants variants;
  String state;
  List<ProductCategory> productCategories;
  List<ProductImage> productImages;

  MarketPlaceModel({
    required this.id,
    required this.userId,
    required this.isActive,
    required this.isFeatured,
    required this.name,
    required this.description,
    required this.price,
    required this.variants,
    required this.state,
    required this.productCategories,
    required this.productImages,
  });

  factory MarketPlaceModel.fromJson(Map<String, dynamic> json) {
    return MarketPlaceModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      isActive: json['is_active'] ?? false,
      isFeatured: json['is_featured'] ?? false,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      variants: Variants.fromJson(json['variants'] ?? {}),
      state: json['state'] ?? '',
      productCategories: (json['product_categories'] as List<dynamic>?)
              ?.map((e) => ProductCategory.fromJson(e))
              .toList() ??
          [],
      productImages: (json['product_images'] as List<dynamic>?)
              ?.map((e) => ProductImage.fromJson(e))
              .toList() ??
          [],
    );
  }

  String get mainImageUrl {
    if (productImages.isEmpty) {
      return '';
    }
    return productImages.first.medium.url;
  }

  String get mainImageBlurHash {
    if (productImages.isEmpty) {
      return '';
    }
    return productImages.first.medium.blurHash ?? '';
  }

  List<String> get categoryNames {
    return productCategories.map((e) => e.category.name).toList();
  }

  String get formattedPrice {
    return '$price ብር';
  }
}

class Variants {
  List<String>? size;
  List<String>? color;

  Variants({
    this.size,
    this.color,
  });

  factory Variants.fromJson(Map<String, dynamic> json) {
    return Variants(
      size: json['size'] != null ? List<String>.from(json['size']) : [],
      color: json['color'] != null ? List<String>.from(json['color']) : [],
    );
  }
}

class ProductCategory {
  Category category;

  ProductCategory({
    required this.category,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      category: Category.fromJson(json['category'] ?? {}),
    );
  }
}

class Category {
  String name;

  Category({
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] ?? '',
    );
  }
}

class ProductImage {
  String productId;
  String mediaId;
  Medium medium;

  ProductImage({
    required this.productId,
    required this.mediaId,
    required this.medium,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      productId: json['product_id'] ?? '',
      mediaId: json['media_id'] ?? '',
      medium: Medium.fromJson(json['medium'] ?? {}),
    );
  }
}

class Medium {
  String url;
  String? blurHash;

  Medium({
    required this.url,
    this.blurHash,
  });

  factory Medium.fromJson(Map<String, dynamic> json) {
    return Medium(
      url: json['url'] ?? '',
      blurHash: json['blur_hash'],
    );
  }
}
