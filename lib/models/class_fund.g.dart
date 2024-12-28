// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_fund.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassFundAdapter extends TypeAdapter<ClassFund> {
  @override
  final int typeId = 3;

  @override
  ClassFund read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassFund(
      totalBalance: fields[0] as double,
      lastUpdated: fields[1] as DateTime,
      targetAmount: fields[2] as double,
      description: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClassFund obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.totalBalance)
      ..writeByte(1)
      ..write(obj.lastUpdated)
      ..writeByte(2)
      ..write(obj.targetAmount)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassFundAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
