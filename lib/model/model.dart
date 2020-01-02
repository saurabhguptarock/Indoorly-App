class User {
  final String uid;
  final String email;
  final String photoUrl;
  final String name;

  User({
    this.uid,
    this.email,
    this.photoUrl,
    this.name,
  });
  factory User.fromMap(Map data) {
    return User(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
    );
  }
}

class Product {
  final String name;
  final String price;
  final String amount;
  final String quantity;

  Product({this.name, this.price, this.amount, this.quantity});
  factory Product.fromMap(Map data) {
    return Product(
      price: data['price'] ?? '',
      name: data['name'] ?? '',
      amount: data['amount'] ?? '',
      quantity: data['quantity'] ?? '',
    );
  }
}
