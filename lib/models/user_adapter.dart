import 'package:hive_flutter/hive_flutter.dart';

import '../models/user_model.dart';

class UserAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    return UserModel(
      id: reader.readString(),
      createdAt: reader.readString(),
      updatedAt: reader.readString(),
      firstName: reader.readString(),
      lastName: reader.readString(),
      username: reader.readString(),
      email: reader.readString(),
      avatar: reader.readString(),
      banner: reader.readString(),
      bannerColor: reader.readString(),
      birthdate: reader.readBool() ? DateTime.parse(reader.readString()) : null,
      bio: reader.readString(),
      country: reader.readString(),
      isAdmin: reader.readBool(),
      isBlocked: reader.readBool(),
      followersCount: reader.readInt(),
      followingsCount: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.createdAt);
    writer.writeString(obj.updatedAt);
    writer.writeString(obj.firstName ?? '');
    writer.writeString(obj.lastName ?? '');
    writer.writeString(obj.username);
    writer.writeString(obj.email);
    writer.writeString(obj.avatar ?? '');
    writer.writeString(obj.banner ?? '');
    writer.writeString(obj.bannerColor ?? '');
    writer.writeBool(obj.birthdate != null);
    if (obj.birthdate != null) writer.writeString(obj.birthdate!.toIso8601String());
    writer.writeString(obj.bio ?? '');
    writer.writeString(obj.country ?? '');
    writer.writeBool(obj.isAdmin);
    writer.writeBool(obj.isBlocked);
    writer.writeInt(obj.followersCount);
    writer.writeInt(obj.followingsCount);
  }
}
