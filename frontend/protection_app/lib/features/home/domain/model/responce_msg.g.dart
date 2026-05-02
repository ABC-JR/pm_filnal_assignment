// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responce_msg.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResponceMsgAdapter extends TypeAdapter<ResponceMsg> {
  @override
  final int typeId = 1;

  @override
  ResponceMsg read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResponceMsg(
      spamResponse: fields[0] as SpamResponse,
      message: fields[1] as String,
      userFeedback: fields[2] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, ResponceMsg obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.spamResponse)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.userFeedback);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponceMsgAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
