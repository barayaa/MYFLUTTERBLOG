import 'package:json_annotation/json_annotation.dart';

part 'addblogModel.g.dart';

@JsonSerializable(createToJson: true)
class AddblogModel {
  String coverImage;
  int count;
  int share;
  int comment;
  String id;
  String username;
  String title;
  String body;
  AddblogModel(
    this.coverImage,
    this.count,
    this.share,
    this.comment,
    this.id,
    this.username,
    this.title,
    this.body,
  );

  factory AddblogModel.fromJson(Map<String, dynamic> json) =>
      _$AddblogModelFromJson(json);
  Map<String, dynamic> toJson(String body) => _$AddblogModelToJson(this);
}
