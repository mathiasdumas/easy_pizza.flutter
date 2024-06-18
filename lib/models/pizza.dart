enum Category { rossa, bianca, veggie }

class Pizza {
  String id;
  String name;
  double price;
  String size;
  List<String> ingredients;
  Category category;

  Pizza({
    required this.id,
    required this.name,
    required this.price,
    required this.ingredients,
    required this.category,
    required this.size
  });
}