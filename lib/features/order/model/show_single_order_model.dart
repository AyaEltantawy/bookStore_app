class ShowSingleOrderModel {
  List<Data>? data;
  String? message;
  List<dynamic>? error;
  int? status;

  ShowSingleOrderModel({this.data, this.message, this.error, this.status});

  ShowSingleOrderModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? List<Data>.from(json['data'].map((v) => Data.fromJson(v)))
        : null;
    message = json['message'];
    error = json['error'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((v) => v.toJson()).toList(),
      'message': message,
      'error': error,
      'status': status,
    };
  }
}

class Data {
  int? id;
  int? userId;
  dynamic reviewId;
  String? totalAmount;
  String? status;
  String? paymentMethod;
  String? createdAt;
  String? updatedAt;
  List<Books>? books;

  Data({
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    reviewId = json['review_id'];
    totalAmount = json['total_amount'];
    status = json['status'];
    paymentMethod = json['payment_method'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    books = json['books'] != null
        ? List<Books>.from(json['books'].map((v) => Books.fromJson(v)))
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'review_id': reviewId,
      'total_amount': totalAmount,
      'status': status,
      'payment_method': paymentMethod,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'books': books?.map((v) => v.toJson()).toList(),
    };
  }
}

class Books {
  int? id;
  String? title;
  String? isbnCode;
  String? image;
  String? description;
  String? author;
  String? price;
  String? discount;
  String? priceAfterDiscount;
  int? stockQuantity;
  int? categoryId;
  int? publisherId;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Books({
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

  Books.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isbnCode = json['isbn_code'];
    image = json['image'];
    description = json['description'];
    author = json['author'];
    price = json['price'];
    discount = json['discount'];
    priceAfterDiscount = json['price_after_discount'];
    stockQuantity = json['stock_quantity'];
    categoryId = json['category_id'];
    publisherId = json['publisher_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
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
}

class Pivot {
  int? orderId;
  int? bookId;
  int? quantity;
  String? subTotal;
  String? createdAt;
  String? updatedAt;

  Pivot({
    this.orderId,
    this.bookId,
    this.quantity,
    this.subTotal,
    this.createdAt,
    this.updatedAt,
  });

  Pivot.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    bookId = json['book_id'];
    quantity = json['quantity'];
    subTotal = json['sub_total'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'book_id': bookId,
      'quantity': quantity,
      'sub_total': subTotal,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
