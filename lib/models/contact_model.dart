import 'dart:convert';

class Contact {
  int? id;
  String? name;
  String? mobileNo;
  String? email;
  String? company;
  String? photo;
  Contact({
    this.id,
    this.name,
    this.mobileNo,
    this.email,
    this.company,
    this.photo,
  });

  Contact copyWith({
    int? id,
    String? name,
    String? mobileNo,
    String? email,
    String? company,
    String? photo,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      mobileNo: mobileNo ?? this.mobileNo,
      email: email ?? this.email,
      company: company ?? this.company,
      photo: photo ?? this.photo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mobileNo': mobileNo,
      'email': email,
      'company': company,
      'photo': photo,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id']?.toInt(),
      name: map['name'],
      mobileNo: map['mobileNo'],
      email: map['email'],
      company: map['company'],
      photo: map['photo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      mobileNo: json['mobileNo'],
      email: json['email'],
      company: json['company'],
      photo: json['photo'],
    );
  }

  @override
  String toString() {
    return 'Contact(id: $id, name: $name, mobileNo: $mobileNo, email: $email, company: $company, photo: $photo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Contact &&
        other.id == id &&
        other.name == name &&
        other.mobileNo == mobileNo &&
        other.email == email &&
        other.company == company &&
        other.photo == photo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        mobileNo.hashCode ^
        email.hashCode ^
        company.hashCode ^
        photo.hashCode;
  }
}
