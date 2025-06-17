// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class InfoModel {
  final int? count;
  final int? pages;
  final String? next;
  final String? prev;
  InfoModel({this.count, this.pages, this.next, this.prev});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': count,
      'pages': pages,
      'next': next,
      'prev': prev,
    };
  }

  factory InfoModel.fromMap(Map<String, dynamic> map) {
    return InfoModel(
      count: map['count'] != null ? map['count'] as int : null,
      pages: map['pages'] != null ? map['pages'] as int : null,
      next: map['next'] != null ? map['next'] as String : null,
      prev: map['prev'] != null ? map['prev'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory InfoModel.fromJson(String source) =>
      InfoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
