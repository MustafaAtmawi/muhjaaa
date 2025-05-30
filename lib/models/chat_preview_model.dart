import 'package:equatable/equatable.dart';
import 'package:muhjaaa/widgets/message_bubble.dart'; // Assuming SenderType is here

class MessageModel extends Equatable {
  final String id;
  final String text;
  final SenderType senderType; // Using the existing enum
  final String senderId; // ID of the user who sent the message
  final DateTime timestamp;
  final String? avatarInitial; // For user/doctor placeholder
  final String? avatarAssetPath; // For AI Mama image

  const MessageModel({
    required this.id,
    required this.text,
    required this.senderType,
    required this.senderId,
    required this.timestamp,
    this.avatarInitial,
    this.avatarAssetPath,
  });

  // Example: Factory constructor from JSON (you'll adapt this to your API)
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    // Determine SenderType based on API data (e.g., senderId or a dedicated field)
    SenderType determinedSenderType;
    if (json['senderType'] != null) {
      determinedSenderType = SenderType.values.firstWhere(
        (e) => e.toString() == 'SenderType.${json['senderType']}',
        orElse: () => SenderType.otherParty, // Default or error handling
      );
    } else if (json['senderId'] == 'ai_mama_id') {
      // Example logic
      determinedSenderType = SenderType.aiMama;
    } else if (json['senderId'] == 'current_user_id_placeholder') {
      // Example logic
      determinedSenderType = SenderType.me;
    } else {
      determinedSenderType = SenderType.otherParty;
    }

    return MessageModel(
      id: json['id'] as String,
      text: json['text'] as String,
      senderType: determinedSenderType,
      senderId: json['senderId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      avatarInitial: json['avatarInitial'] as String?,
      avatarAssetPath: json['avatarAssetPath'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    text,
    senderType,
    senderId,
    timestamp,
    avatarInitial,
    avatarAssetPath,
  ];
}
