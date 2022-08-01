import 'package:data/sources/remote/dto/attachment_dto.dart';
import 'package:domain/model/message_attachment/message_attachment.dart';
import 'package:domain/model/message_attachment/message_attachment_photo.dart';
import 'package:domain/model/message_attachment/message_attachment_voice.dart';

extension AttachmentToAttachmentDto on MessageAttachment {
  MessageAttachmentDto toDto() => MessageAttachmentDto(
        type: type,
        voice: voice?.toDto(),
        photo: photo?.toDto(),
      );
}

extension AttachmentDtoToAttachment on MessageAttachmentDto {
  MessageAttachment toAttachment() => MessageAttachment(
        type: type,
        voice: voice?.toVoice(),
        photo: photo?.toPhoto(),
      );
}

extension VoiceAttachmentToVoiceAttachmentDto on MessageAttachmentVoice {
  MessageAttachmentVoiceDto toDto() => MessageAttachmentVoiceDto(
        fileId: fileId,
        duration: duration,
        waveform: waveform,
      );
}

extension VoiceAttachmentDtoToVoiceAttachment on MessageAttachmentVoiceDto {
  MessageAttachmentVoice toVoice() => MessageAttachmentVoice(
        fileId: fileId,
        duration: duration,
        waveform: waveform,
      );
}

extension PhotoAttachmentDtoToPhotoAttachment on MessageAttachmentPhotoDto {
  MessageAttachmentPhoto toPhoto() => MessageAttachmentPhoto(
        fileId: fileId,
        name: name,
        width: width,
        height: height,
      );
}

extension PhotoAttachmentToPhotoAttachmentDto on MessageAttachmentPhoto {
  MessageAttachmentPhotoDto toDto() => MessageAttachmentPhotoDto(
        fileId: fileId,
        name: name,
        width: width,
        height: height,
      );
}
