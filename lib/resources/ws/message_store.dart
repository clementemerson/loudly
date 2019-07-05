import 'message_models/general_message_format.dart';

class MessageStore {
  // Create a singleton
  MessageStore._();
  Map messages = new Map();

  static final MessageStore _store = MessageStore._();

  factory MessageStore() {
    return _store;
  }

  add(Message message) {
    messages[message.messageid] = message;
  }

  Message remove(int messageid) {
    return messages.remove(messageid);
  }

  take(int messageid) {
    return messages[messageid];
  }
}
