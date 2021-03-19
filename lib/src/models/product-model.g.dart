// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product-model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductsAdapter extends TypeAdapter<Products> {
  @override
  final int typeId = 2;

  @override
  Products read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Products(
      id: fields[0] as String,
      likes: fields[1] as int,
      dbPrice: fields[2] as double,
      name: fields[4] as String,
      detail: fields[5] as String,
      disabled: fields[8] as bool,
      shopId: fields[6] as String,
      discount: fields[3] as double,
      images: (fields[7] as List)?.cast<ImageModel>(),
      ratings: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Products obj) {
    writer
      ..writeByte(10)
      ..writeByte(1)
      ..write(obj.likes)
      ..writeByte(2)
      ..write(obj.dbPrice)
      ..writeByte(3)
      ..write(obj.discount)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.detail)
      ..writeByte(6)
      ..write(obj.shopId)
      ..writeByte(7)
      ..write(obj.images)
      ..writeByte(8)
      ..write(obj.disabled)
      ..writeByte(9)
      ..write(obj.ratings)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
