import 'package:equatable/equatable.dart';

// SenderType enum moved here from message_bubble.dart
enum SenderType { me, otherParty, aiMama }

class MessageModel extends Equatable {
  final String id;
  final String text;
  final SenderType senderType;
  final String senderId;
  final DateTime timestamp;
  final String? avatarInitial;
  final String? avatarAssetPath;

  const MessageModel({
    required this.id,
    required this.text,
    required this.senderType,
    required this.senderId,
    required this.timestamp,
    this.avatarInitial,
    this.avatarAssetPath,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    SenderType determinedSenderType;
    if (json['senderType'] != null) {
      determinedSenderType = SenderType.values.firstWhere(
        (e) => e.toString() == 'SenderType.${json['senderType']}',
        orElse: () => SenderType.otherParty,
      );
    } else if (json['senderId'] == 'ai_mama_id') {
      determinedSenderType = SenderType.aiMama;
    } else if (json['senderId'] == 'current_user_id_placeholder') {
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
