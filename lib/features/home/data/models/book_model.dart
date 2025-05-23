import 'package:bookstore_app/core/services/dio_helper.dart';

class Books {
  final int id;
  final String isbnCode;
  final String title;
  final String image;
  final String author;
  final String description;
  final String price;
  final String? priceAfterDiscount;
  final String? discount;
  final int stockQuantity;
  final int categoryId;
  final int publisherId;

  Books({
     required this.id,
    required this.isbnCode,
    required this.title,
    required this.image,
    required this.author,
    required this.description,
    required this.price,
    this.discount,
    required this.stockQuantity,
    required this.categoryId,
    required this.publisherId,
    this.priceAfterDiscount,
  });

  factory Books.fromJson(Map<String, dynamic> json) {
        final String _image= json['image'].replaceAll("127.0.0.1",DioHelper.activeHost  ) ?? "";
  
    return Books(
      id: json['id'],
      isbnCode: json['isbn_code'] ?? '',
      title: json['title'] ?? '',
      image: _image ,
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      priceAfterDiscount: json['price_after_discount'],
      discount: json['discount'],
      stockQuantity: json['stock_quantity'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      publisherId: json['publisher_id'] ?? 0,
    );
  }
}



class BookModel {
  final int id;
  final String isbnCode;
  final String title;
  final String image;
  final String author;
  final String description;
  final String price;
  final String? priceAfterDiscount;
  final String? discount;
  final int stockQuantity;
  final int categoryId;
  final int publisherId;

  BookModel({
    required this.id,
    required this.isbnCode,
    required this.title,
    required this.image,
    required this.author,
    required this.description,
    required this.price,
    this.priceAfterDiscount,
    this.discount,
    required this.stockQuantity,
    required this.categoryId,
    required this.publisherId,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
        final String _image= json['image'].replaceAll("127.0.0.1",DioHelper.activeHost  ) ?? "";
  
    return BookModel(
      id: json['id'],
      isbnCode: json['isbn_code'] ?? '',
      title: json['title'] ?? '',
      image: _image ,
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      priceAfterDiscount: json['price_after_discount'],
      discount: json['discount'],
      stockQuantity: json['stock_quantity'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      publisherId: json['publisher_id'] ?? 0,
    );
  }
}
class WishlistModel {
  final List<BookModel> books;
  final String message;
  final int status;

  WishlistModel({
    required this.books,
    required this.message,
    required this.status,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      books: (json['data']['books'] as List)
          .map((book) => BookModel.fromJson(book))
          .toList(),
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}


class BookDetails {
  Data? data;
  String? message;
  List<String>? error; // تغيير نوع error من List<Null> إلى List<String>
  int? status;

  BookDetails({this.data, this.message, this.error, this.status});

  BookDetails.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    if (json['error'] != null) {
      error = List<String>.from(json['error']);
    }
    status = json['status'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   if (this.data != null) {
  //     data['data'] = this.data!.toJson();
  //   }
  //   data['message'] = this.message;
  //   if (this.error != null) {
  //     data['error'] = this.error;
  //   }
  //   data['status'] = this.status;
  //   return data;
  // }
}

class Data {
  Books? book;

  Data({this.book});

  Data.fromJson(Map<String, dynamic> json) {
    book = json['book'] != null ? Books.fromJson(json['book']) : null;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   if (this.book != null) {
  //     data['book'] = this.book!.toJson();
  //   }
  //   return data;
  // }
}
