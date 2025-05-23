class CategoryModel {
  Data? data;
  String? message;
  List<String>? error;  
  int? status;

  CategoryModel({this.data, this.message, this.error, this.status});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    if (json['error'] != null) {
      error = List<String>.from(json['error']);
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    if (this.error != null) {
      data['error'] = this.error;
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
  List<Categories> categories;
  Meta? meta;
  Links? links;

  Data({this.categories = const [], this.meta, this.links});

  Data.fromJson(Map<String, dynamic> json)
      : categories = (json['categories'] as List? ?? [])
            .map((v) => Categories.fromJson(v))
            .toList(),
        meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null,
        links = json['links'] != null ? Links.fromJson(json['links']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['categories'] = categories.map((v) => v.toJson()).toList();
    if (meta != null) data['meta'] = meta!.toJson();
    if (links != null) data['links'] = links!.toJson();
    return data;
  }
}

class Categories {
  int id;
  String title;
  String image;

  Categories({this.id = 0, this.title = '', this.image = ''});

  factory Categories.fromJson(Map<String, dynamic> json)
      { final _id = json['id'] ?? 0;
        final _title = json['title'] ?? '';
       final String _image = json['image'].replaceAll("127.0.0.1","192.168.1.24" ) ??"";
        
            return Categories(
              id:_id,
              title:_title,
              image: _image,
            );
      }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
    };
  }
}


class Meta {
  int total;
  int perPage;
  int currentPage;  
  int lastPage;

  Meta({
    this.total = 0,
    this.perPage = 0,
    this.currentPage = 0,
    this.lastPage = 0,
  });

  Meta.fromJson(Map<String, dynamic> json)
      : total = json['total'] ?? 0,
        perPage = json['per_page'] ?? 0,
        currentPage = json['current_page'] ?? 0,
        lastPage = json['last_page'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'per_page': perPage,
      'current_page': currentPage,
      'last_page': lastPage,
    };
  }
}

class Links {
  String first;
  String last;
  String? prev;  
  String? next;  

  Links({
    this.first = '',
    this.last = '',
    this.prev,
    this.next,
  });

  Links.fromJson(Map<String, dynamic> json)
      : first = json['first'] ?? '',
        last = json['last'] ?? '',
        prev = json['prev'],
        next = json['next'];

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'last': last,
      'prev': prev,
      'next': next,
    };
  }
}
