import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment_dto.freezed.dart';
part 'attachment_dto.g.dart';

@freezed
class MessageAttachmentDto with _$MessageAttachmentDto {
  const factory MessageAttachmentDto({
    required int type,
    MessageAttachmentVoiceDto? voice,
    MessageAttachmentPhotoDto? photo,
  }) = _MessageAttachmentDto;

  factory MessageAttachmentDto.fromJson(Map<String, dynamic> json) =>
      _$MessageAttachmentDtoFromJson(json);
}

@freezed
class MessageAttachmentVoiceDto with _$MessageAttachmentVoiceDto {
  const factory MessageAttachmentVoiceDto({
    @JsonKey(name: 'file_id') required String fileId,
    required int duration,
    required List<double> waveform,
  }) = _MessageAttachmentVoiceDto;

  factory MessageAttachmentVoiceDto.fromJson(Map<String, dynamic> json) =>
      _$MessageAttachmentVoiceDtoFromJson(json);
}

@freezed
class MessageAttachmentPhotoDto with _$MessageAttachmentPhotoDto {
  const factory MessageAttachmentPhotoDto({
    @JsonKey(name: 'file_id') required String fileId,
    required String name,
    required int width,
    required int height,
  }) = _MessageAttachmentPhotoDto;

  factory MessageAttachmentPhotoDto.fromJson(Map<String, dynamic> json) =>
      _$MessageAttachmentPhotoDtoFromJson(json);
}
