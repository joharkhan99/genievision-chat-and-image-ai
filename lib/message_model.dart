class Message {
  late String sender;
  late String time;
  late String text;

  Message() {
    sender = '';
    time = '';
    text = '';
  }

  Message.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    time = json['time'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender'] = sender;
    data['time'] = time;
    data['text'] = text;
    return data;
  }

  // getters and setters
  String getSender() {
    return sender;
  }

  void setSender(String sender) {
    this.sender = sender;
  }

  String getTime() {
    return time;
  }

  void setTime(String time) {
    this.time = time;
  }

  String getText() {
    return text;
  }

  void setText(String text) {
    this.text = text;
  }
}
