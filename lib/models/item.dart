class Item {
  final int id;
  final String sku;
  final String name;
  final String? imageUrl;
  final int stock;

  Item({
    required this.id,
    required this.sku,
    required this.name,
    required this.imageUrl,
    required this.stock,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      sku: json['sku'],
      name: json['name'],
      imageUrl: json['image_url'] as String?,
      stock: json['stock'],
    );
  }
}
