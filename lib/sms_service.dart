/// An SMS library for flutter
library sms_maintained;

const METHOD_CHANNEL_REMOVE_SMS = "geordyvc.sms.remove.channel";

typedef OnError(Object error);

enum SmsMessageState {
  None,
  Sending,
  Sent,
  Delivered,
  Fail,
}

enum SmsMessageKind {
  Sent,
  Received,
  Draft,
}

enum SmsMessageType {
  HAM,
  UNDECIDABLE,
  SPAM,
}