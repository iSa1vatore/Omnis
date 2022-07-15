import 'package:data/sources/local/db/entity/message_entity.dart';
import 'package:domain/model/message.dart';

extension MessageEntityToMessage on MessageEntity {
  Message toMessage() {
    return Message(
        id: id!,
        globalId: globalId,
        time: time,
        peerId: peerId,
        fromId: fromId,
        text: text,
        sendState: sendState);
  }
}
