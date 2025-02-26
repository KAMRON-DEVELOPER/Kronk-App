import 'package:hive_flutter/hive_flutter.dart';

/*
first_name
last_name
username
email
password
avatar
banner
banner_color
birthdate
bio
country
is_admin
is_blocked
*/

class UserModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String createdAt;
  @HiveField(2)
  String updatedAt;
  @HiveField(3)
  String? firstName;
  @HiveField(4)
  String? lastName;
  @HiveField(5)
  String username;
  @HiveField(6)
  String email;
  @HiveField(7)
  String? avatar;
  @HiveField(8)
  String? banner;
  @HiveField(9)
  String? bannerColor;
  @HiveField(10)
  DateTime? birthdate;
  @HiveField(11)
  String? bio;
  @HiveField(12)
  String? country;
  @HiveField(13)
  bool isAdmin;
  @HiveField(14)
  bool isBlocked;
  @HiveField(15)
  int followersCount;
  @HiveField(16)
  int followingsCount;

  UserModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.firstName,
    this.lastName,
    required this.username,
    required this.email,
    this.avatar,
    this.banner,
    this.bannerColor,
    this.birthdate,
    this.bio,
    this.country,
    required this.isAdmin,
    required this.isBlocked,
    required this.followersCount,
    required this.followingsCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      email: json['email'],
      avatar: json['avatar'],
      banner: json['banner'],
      bannerColor: json['banner_color'],
      birthdate: json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
      bio: json['bio'],
      country: json['country'],
      isAdmin: json['is_admin'] ?? false,
      isBlocked: json['is_blocked'] ?? false,
      followersCount: json['followers_count'] ?? 0,
      followingsCount: json['followings_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'avatar': avatar,
      'banner': banner,
      'birthdate': birthdate?.toIso8601String(),
      'bio': bio,
      'country': country,
      'is_admin': isAdmin,
      'is_blocked': isBlocked,
    };
  }

  UserModel forUpdate(UserModel? updateData) {
    return UserModel(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      firstName: updateData?.firstName ?? firstName,
      lastName: updateData?.lastName ?? lastName,
      username: updateData?.username ?? username,
      email: updateData?.email ?? email,
      avatar: updateData?.avatar ?? avatar,
      banner: updateData?.banner ?? banner,
      bannerColor: updateData?.bannerColor ?? bannerColor,
      birthdate: updateData?.birthdate ?? birthdate,
      bio: updateData?.bio ?? bio,
      country: updateData?.country ?? country,
      isAdmin: updateData?.isAdmin ?? isAdmin,
      isBlocked: updateData?.isBlocked ?? isBlocked,
      followersCount: followersCount,
      followingsCount: followingsCount,
    );
  }
}
