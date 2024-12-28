// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentAdapter extends TypeAdapter<Payment> {
  @override
  final int typeId = 6;

  @override
  Payment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Payment(
      studentId: fields[0] as String,
      date: fields[1] as DateTime,
      amount: fields[2] as double,
      type: fields[3] as PaymentType,
      description: fields[4] as String,
      proofImagePath: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Payment obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.studentId)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.proofImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaymentTypeAdapter extends TypeAdapter<PaymentType> {
  @override
  final int typeId = 5;

  @override
  PaymentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PaymentType.cash;
      case 1:
        return PaymentType.transfer;
      default:
        return PaymentType.cash;
    }
  }

  @override
  void write(BinaryWriter writer, PaymentType obj) {
    switch (obj) {
      case PaymentType.cash:
        writer.writeByte(0);
        break;
      case PaymentType.transfer:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
