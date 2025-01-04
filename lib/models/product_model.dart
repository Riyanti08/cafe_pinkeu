class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String image;
  final String description;
  final double? rating;
  final int? totalRatings;

  Product({
    required this.id,
    this.name = '',
    this.category = '',
    this.price = 0,
    this.image = '',
    this.description = '',
    this.rating,
    this.totalRatings,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'image': image,
      'description': description,
      'rating': rating,
      'totalRatings': totalRatings,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      price: (map['price'] ?? 0).toDouble(),
      image: map['image']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      totalRatings: map['totalRatings'] ?? 0,
    );
  }
}
