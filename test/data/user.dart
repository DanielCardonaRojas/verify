import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? phone;
  final String? mail;
  final int? age;

  const User(this.phone, this.mail, this.age);

  @override
  List<Object> get props => [phone ?? '', mail ?? '', age ?? ''];
}
