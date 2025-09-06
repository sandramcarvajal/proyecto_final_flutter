class Products {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String category;

  Products({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json["id"] as int?,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      price: (json["price"] as num).toDouble(),
      category: json["category"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      "name": name,
      "description": description,
      "price": price,
      "category": category,
    };
  }
}
