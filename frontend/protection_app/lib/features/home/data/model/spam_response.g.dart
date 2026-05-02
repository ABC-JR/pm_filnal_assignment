// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spam_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpamResponseAdapter extends TypeAdapter<SpamResponse> {
  @override
  final int typeId = 0;

  @override
  SpamResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpamResponse(
      verdict: fields[0] as String,
      confidence: fields[1] as int,
      score: fields[2] as int,
      reasons: (fields[3] as List).cast<String>(),
      summary: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SpamResponse obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.verdict)
      ..writeByte(1)
      ..write(obj.confidence)
      ..writeByte(2)
      ..write(obj.score)
      ..writeByte(3)
      ..write(obj.reasons)
      ..writeByte(4)
      ..write(obj.summary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpamResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
