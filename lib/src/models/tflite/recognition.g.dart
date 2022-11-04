// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recognition.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecognitionAdapter extends TypeAdapter<Recognition> {
  @override
  final int typeId = 0;

  @override
  Recognition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recognition(
      fields[0] as int,
      fields[1] as String,
      fields[2] as double,
      null,
      fields[3] as int?,
    )
      ..action = fields[4] as String?
      ..isSaved = fields[6] as bool?;
  }

  @override
  void write(BinaryWriter writer, Recognition obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._label)
      ..writeByte(2)
      ..write(obj._score)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.action)
      ..writeByte(6)
      ..write(obj.isSaved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RecognitionAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
