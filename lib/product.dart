class Product {
  int id;
  String title;
  double price;
  String description;
  String category;
  List<String> images;
  String vendor;
  String returnGuarentee;
  String itemDetail;
  Rating rating;

  Product(this.id, this.title, this.price, this.description, this.category, this.images, this.vendor, this.returnGuarentee, this.itemDetail, this.rating);
}

class Rating {
  double rate;
  int count;
  Rating(this.rate, this.count);
}
