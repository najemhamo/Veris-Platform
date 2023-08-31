

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final String? name;
  final String? profileUrl;
  final String? uid;
  final String? password;
  final String? email;
  final String? accountType;
  final String? deviceToken;
  final String? aboutMe;
  final String? phoneNumber;
  final bool? isDisable;

  UserEntity({
    this.name,
    this.profileUrl,
    this.uid,
    this.password,
    this.email,
    this.accountType,
    this.deviceToken,
    this.aboutMe,
    this.phoneNumber,
    this.isDisable,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    name,
    profileUrl,
    uid,
    password,
    email,
    accountType,
    deviceToken,
    aboutMe,
    phoneNumber,
    isDisable,
  ];


}
