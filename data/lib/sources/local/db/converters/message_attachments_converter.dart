import 'dart:convert';

import 'package:data/mapper/attachment_mapper.dart';
import 'package:data/sources/remote/dto/attachment_dto.dart';
import 'package:domain/model/message_attachment/message_attachment.dart';
import 'package:floor/floor.dart';

class MessageAttachmentsConverter
    extends TypeConverter<List<MessageAttachment>?, String?> {
  @override
  List<MessageAttachment>? decode(String? databaseValue) {
    if (databaseValue == null) return null;

    List<dynamic> json = jsonDecode(databaseValue);

    return json
        .map((e) => MessageAttachmentDto.fromJson(e).toAttachment())
        .toList();
  }

  @override
  String? encode(List<MessageAttachment>? value) {
    if (value == null) return null;

    return jsonEncode(value.map((e) => e.toDto().toJson()).toList());
  }
}
