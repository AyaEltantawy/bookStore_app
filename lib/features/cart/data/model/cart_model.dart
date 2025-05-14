class CartModel {
  final int cartId;
  final String total;
  final List<CartBook> cartBooks;

  CartModel({
    required this.cartId,
    required this.total,
    required this.cartBooks,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json['cart_id'],
      total: json['total'],
      cartBooks: List<CartBook>.from(
        json['cart_books'].map((book) => CartBook.fromJson(book)),
      ),
    );
  }
}

class CartBook {
  final int id;
  final String title;
  final String image;
  final String price;
  final String discount;
  final String priceAfterDiscount;
  final int quantity;
  final String subAmount;

  CartBook({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.discount,
    required this.priceAfterDiscount,
    required this.quantity,
    required this.subAmount,
  });

  factory CartBook.fromJson(Map<String, dynamic> json) {
    return CartBook(
      id: json['book_id'],
      title: json['book_title'],
      image: json['book_image'],
      price: json['book_price'],
      discount: json['book_discount'],
      priceAfterDiscount: json['book_price_after_discount'],
      quantity: json['book_quantity'],
      subAmount: json['book_sub_amount'],
    );
  }
}
