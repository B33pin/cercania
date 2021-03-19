// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile-model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileAdapter extends TypeAdapter<Profile> {
  @override
  final int typeId = 0;

  @override
  Profile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Profile(
      id: fields[8] as String,
      name: fields[0] as String,
      imgUrl: fields[1] as String,
      username: fields[2] as String,
      password: fields[3] as String,
      likedProducts: (fields[7] as List)?.cast<String>(),
      token: fields[4] as String,
      platform: fields[5] as String,
      likedShops: (fields[6] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.imgUrl)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.token)
      ..writeByte(5)
      ..write(obj.platform)
      ..writeByte(6)
      ..write(obj.likedShops)
      ..writeByte(7)
      ..write(obj.likedProducts)
      ..writeByte(8)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
