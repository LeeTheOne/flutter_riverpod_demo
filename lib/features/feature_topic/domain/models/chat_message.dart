enum Sender { user, bot }

class ChatMessage {
  final String id;
  final String text;
  final DateTime time;
  final Sender sender;

  ChatMessage({
    required this.id,
    required this.text,
    required this.time,
    required this.sender,
  });
}
