import 'package:json_annotation/json_annotation.dart';

part 'superModel.g.dart';

@JsonSerializable()
class SuperModel {
  String coverImage;
  int count;
  int share;
  int comment;
  String id;
  String username;
  String title;
  String body;
  SuperModel({
    required this.coverImage,
    required this.count,
    required this.share,
    required this.comment,
    required this.id,
    required this.username,
    required this.title,
    required this.body,
  });

  factory SuperModel.fromJson(Map<String, dynamic> json) =>
      _$SuperModelFromJson(json);
  Map<String, dynamic> toJson() => _$SuperModelToJson(this);
}
