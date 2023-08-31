import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veris_mobile/featues/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    final String? name,
    final String? profileUrl,
    final String? uid,
    final String? password,
    final String? email,
    final String? accountType,
    final String? deviceToken,
    final String? aboutMe,
    final String? phoneNumber,
    final bool? isDisable,
  }) : super(
            profileUrl: profileUrl,
            name: name,
            aboutMe: aboutMe,
            phoneNumber: phoneNumber,
            email: email,
            uid: uid,
            deviceToken: deviceToken,
            password: password,
            accountType: accountType,
            isDisable: isDisable,
  );

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      profileUrl: snapshot.get('profileUrl'),
      name: snapshot.get('name'),
      aboutMe: snapshot.get('aboutMe'),
      email: snapshot.get('email'),
      phoneNumber: snapshot.get('phoneNumber'),
      uid: snapshot.get('uid'),
      deviceToken: snapshot.get('deviceToken'),
      accountType: snapshot.get('accountType'),
      isDisable: snapshot.get('isDisable'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "profileUrl": profileUrl,
      "name": name,
      "aboutMe": aboutMe,
      "email": email,
      "phoneNumber": phoneNumber,
      "uid": uid,
      "deviceToken": deviceToken,
      "accountType": accountType,
      "isDisable": isDisable,
    };
  }
}
