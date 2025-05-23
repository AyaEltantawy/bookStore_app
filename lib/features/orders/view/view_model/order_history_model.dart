class OrderHistoryModel {
  final List<OrderData>? data;
  final String? message;
  final List<dynamic>? error;
  final int? status;

  OrderHistoryModel({
    this.data,
    this.message,
    this.error,
    this.status,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OrderData.fromJson(e))
          .toList(),
      message: json['message'] as String?,
      error: json['error'] as List<dynamic>?,
      status: json['status'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data?.map((e) => e.toJson()).toList(),
    'message': message,
    'error': error,
    'status': status,
  };
}

class OrderData {
  final int? id;
  final int? userId;
  final dynamic reviewId;
  final String? totalAmount;
  final String? status;
  final String? paymentMethod;
  final String? createdAt;
  final String? updatedAt;
  final List<Book>? books;

  OrderData({
    this.id,
    this.userId,
    this.reviewId,
    this.totalAmount,
    this.status,
    this.paymentMethod,
    this.createdAt,
    this.updatedAt,
    this.books,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      reviewId: json['review_id'],
      totalAmount: json['total_amount'] as String?,
      status: json['status'] as String?,
      paymentMethod: json['payment_method'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      books: (json['books'] as List<dynamic>?)
          ?.map((e) => Book.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'review_id': reviewId,
    'total_amount': totalAmount,
    'status': status,
    'payment_method': paymentMethod,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'books': books?.map((e) => e.toJson()).toList(),
  };
}

class Book {
  final int? id;
  final String? title;
  final String? isbnCode;
  final String? image;
  final String? description;
  final String? author;
  final String? price;
  final dynamic discount;
  final dynamic priceAfterDiscount;
  final int? stockQuantity;
  final int? categoryId;
  final int? publisherId;
  final String? createdAt;
  final String? updatedAt;
  final Pivot? pivot;

  Book({
    this.id,
    this.title,
    this.isbnCode,
    this.image,
    this.description,
    this.author,
    this.price,
    this.discount,
    this.priceAfterDiscount,
    this.stockQuantity,
    this.categoryId,
    this.publisherId,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int?,
      title: json['title'] as String?,
      isbnCode: json['isbn_code'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      author: json['author'] as String?,
      price: json['price'] as String?,
      discount: json['discount'],
      priceAfterDiscount: json['price_after_discount'],
      stockQuantity: json['stock_quantity'] as int?,
      categoryId: json['category_id'] as int?,
      publisherId: json['publisher_id'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      pivot: json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isbn_code': isbnCode,
    'image': image,
    'description': description,
    'author': author,
    'price': price,
    'discount': discount,
    'price_after_discount': priceAfterDiscount,
    'stock_quantity': stockQuantity,
    'category_id': categoryId,
    'publisher_id': publisherId,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'pivot': pivot?.toJson(),
  };
}

class Pivot {
  final int? orderId;
  final int? bookId;
  final int? quantity;
  final String? subTotal;
  final String? createdAt;
  final String? updatedAt;

  Pivot({
    this.orderId,
    this.bookId,
    this.quantity,
    this.subTotal,
    this.createdAt,
    this.updatedAt,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      orderId: json['order_id'] as int?,
      bookId: json['book_id'] as int?,
      quantity: json['quantity'] as int?,
      subTotal: json['sub_total'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'book_id': bookId,
    'quantity': quantity,
    'sub_total': subTotal,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}