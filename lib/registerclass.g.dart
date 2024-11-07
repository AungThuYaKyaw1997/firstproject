// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registerclass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
      FullName: json['fullName'] as String? ?? '',
      Usergemail: json['usergemail'] as String? ?? '',
      Password: json['password'] as String? ?? '',
    );

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'fullName': instance.FullName,
      'usergemail': instance.Usergemail,
      'password': instance.Password,
    };
