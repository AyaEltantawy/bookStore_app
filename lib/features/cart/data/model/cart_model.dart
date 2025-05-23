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
      cartId: json['cart_id'] is int
          ? json['cart_id']
          : int.tryParse(json['cart_id'].toString()) ?? 0,
      total: json['total'].toString(),
      cartBooks: List<CartBook>.from(
        (json['cart_books'] as List<dynamic>)
            .map((book) => CartBook.fromJson(book)),
      ),
    );
  }
}

class CartBook {
  final int id;
  final String title;
  final String image;
  final String price;
  final String? discount;
  final int priceAfterDiscount;
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
      id: json['book_id'] is int
          ? json['book_id']
          : int.tryParse(json['book_id'].toString()) ?? 0,
      title: json['book_title'].toString(),
      image: json['book_image'].toString(),
      price: json['book_price'].toString(),
      discount: json['book_discount']?.toString(),
      priceAfterDiscount: json['book_price_after_discount'] is int
          ? json['book_price_after_discount']
          : int.tryParse(json['book_price_after_discount'].toString()) ?? 0,
      quantity: json['book_quantity'] is int
          ? json['book_quantity']
          : int.tryParse(json['book_quantity'].toString()) ?? 1,
      subAmount: json['book_sub_amount'].toString(),
    );
  }
}
