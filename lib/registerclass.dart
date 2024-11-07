
import 'package:json_annotation/json_annotation.dart';
// flutter pub run build_runner build
part 'registerclass.g.dart';
@JsonSerializable(explicitToJson: true)
class Person{

  @JsonKey(name: 'fullName' ,defaultValue: "")
  String FullName;

  @JsonKey(name: 'usergemail' ,defaultValue: "")
  String Usergemail;


  @JsonKey(name: 'password' ,defaultValue: "")
  String Password;


  Person({
    required this.FullName,
    required this.Usergemail,
    required this.Password,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return _$PersonFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PersonToJson(this);

}


