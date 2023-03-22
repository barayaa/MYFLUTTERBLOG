// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addblogModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddblogModel _$AddblogModelFromJson(Map<String, dynamic> json) => AddblogModel(
      json['coverImage'] as String,
      json['count'] as int,
      json['share'] as int,
      json['comment'] as int,
      json['id'] as String,
      json['username'] as String,
      json['title'] as String,
      json['body'] as String,
    );

Map<String, dynamic> _$AddblogModelToJson(AddblogModel instance) =>
    <String, dynamic>{
      'coverImage': instance.coverImage,
      'count': instance.count,
      'share': instance.share,
      'comment': instance.comment,
      'id': instance.id,
      'username': instance.username,
      'title': instance.title,
      'body': instance.body,
    };
