import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class ChatListItem extends StatelessWidget {
  final String senderName;
  final String senderRole;
  final String lastMessage;
  final String timestamp;
  final int unreadCount;
  final String placeholderLetter;
  final VoidCallback? onTap;

  const ChatListItem({
    super.key,
    required this.senderName,
    required this.senderRole,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.placeholderLetter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
            color: AppColors.doctorChatItemBg,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.mutedBlueGrey.withAlpha(
                  (0.7 * 255).round(),
                ), // CORRECTED
                child: Text(
                  placeholderLetter,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.white,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$senderName - $senderRole',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.darkGreyText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        color: AppColors.mutedBlueGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    timestamp,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: AppColors.lightGrey,
                    ),
                  ),
                  if (unreadCount > 0) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryRed,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 6 + 12 + 6 - 2),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
