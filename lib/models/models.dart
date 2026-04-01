class ReasstaransList {
  final String id; // Уникальный идентификатор ресторана
  final String? name;
  final String? imageurl;
  final String? detal;
  final String? address;
  bool like;

  ReasstaransList({
    required this.id, // id обязательно при создании объекта
    this.name,
    this.imageurl,
    this.detal,
    this.address,
    this.like = false,
  });

  factory ReasstaransList.fromJson(Map<String, dynamic> json) {
    String? imageUrl = '';
    if (json['images'] != null && json['images'].isNotEmpty) {
      imageUrl = json['images'][0]['path'];
    }

    return ReasstaransList(
      id: json['id'].toString(), 
      name: json['name'] ?? 'Неизвестное название',
      imageurl: imageUrl ?? 'https://example.com/default_image_url.png',
      detal: json['description'] ?? 'Нет описания',
      address: json['address'] ?? 'Неизвестное Адрес',
      like: json['like'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageurl': imageurl,
      'detal': detal,
      'address': address,
      'like': like,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageurl': imageurl,
      'detal': detal,
      'address': address,
      'like': like,
    };
  }
  
  factory ReasstaransList.fromMap(Map<String, dynamic> map) {
    return ReasstaransList(
      id: map['id'] as String? ?? '',
      name: map['name'] as String?,
      imageurl: map['imageurl'] as String?,
      detal: map['detal'] as String?,
      address: map['address'] as String?,
      like: map['like'] as bool? ?? false,
    );
  }
}
