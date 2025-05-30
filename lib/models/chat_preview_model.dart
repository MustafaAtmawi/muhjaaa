import 'package:equatable/equatable.dart';
// Removed import for SenderType as it's not used here.

class ChatPreviewModel extends Equatable {
  final String id; // Conversation ID
  final String senderName;
  final String senderRole;
  final String lastMessage;
  final String timestamp; // Could be DateTime, formatted as String for display
  final int unreadCount;
  final String placeholderLetter;
  final String? avatarUrl; // If you have avatar URLs from backend

  const ChatPreviewModel({
    required this.id,
    required this.senderName,
    required this.senderRole,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.placeholderLetter,
    this.avatarUrl,
  });

  // Example: Factory constructor from JSON
  factory ChatPreviewModel.fromJson(Map<String, dynamic> json) {
    return ChatPreviewModel(
      id: json['id'] as String,
      senderName: json['senderName'] as String,
      senderRole: json['senderRole'] as String,
      lastMessage: json['lastMessage'] as String,
      timestamp: json['timestamp'] as String, // Or parse if DateTime
      unreadCount: json['unreadCount'] as int,
      placeholderLetter: json['placeholderLetter'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    senderName,
    senderRole,
    lastMessage,
    timestamp,
    unreadCount,
    placeholderLetter,
    avatarUrl,
  ];
}
