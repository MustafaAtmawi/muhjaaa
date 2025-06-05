import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class ChatListItem extends StatelessWidget {
  final String senderName;
  final String senderRole;
  final String lastMessage;
  final String timestamp;
  final int unreadCount;
  final String placeholderLetter;
  final String? avatarUrl;
  final VoidCallback? onTap;

  const ChatListItem({
    super.key,
    required this.senderName,
    required this.senderRole,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.placeholderLetter,
    this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatarDisplay;
    final bool hasAvatarUrl = avatarUrl != null && avatarUrl!.isNotEmpty;

    if (hasAvatarUrl) {
      avatarDisplay = ClipOval(
        child: Image.network(
          avatarUrl!,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback for network image error
            return CircleAvatar(
              radius: 26,
              backgroundColor: const Color.fromRGBO(
                154,
                181,
                189,
                0.7,
              ), // mutedBlueGrey with 0.7 opacity
              child: Text(
                placeholderLetter.isNotEmpty
                    ? placeholderLetter[0].toUpperCase()
                    : 'S',
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.white,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          loadingBuilder:
              (
                BuildContext context,
                Widget child,
                ImageChunkEvent? loadingProgress,
              ) {
                if (loadingProgress == null) return child;
                return CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color.fromRGBO(
                    154,
                    181,
                    189,
                    0.3,
                  ), // mutedBlueGrey with 0.3 opacity (placeholder bg)
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2.0,
                      color: AppColors.primaryRed,
                    ),
                  ),
                );
              },
        ),
      );
    } else {
      avatarDisplay = CircleAvatar(
        radius: 26,
        backgroundColor: const Color.fromRGBO(
          154,
          181,
          189,
          0.7,
        ), // mutedBlueGrey with 0.7 opacity
        child: Text(
          placeholderLetter.isNotEmpty
              ? placeholderLetter[0].toUpperCase()
              : 'S',
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: AppColors.doctorChatItemBg,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          textDirection: TextDirection.rtl, // Ensure overall row layout is RTL
          children: [
            avatarDisplay,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Text aligns to start (right in RTL)
                children: [
                  Text(
                    '$senderName - $senderRole',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.darkGreyText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
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
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.end, // Align to end (left in RTL)
              children: [
                Text(
                  timestamp,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: AppColors.lightGrey,
                  ),
                ),
                const SizedBox(height: 6),
                if (unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(10.0),
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
                  )
                else
                  // Placeholder to maintain alignment if no unread count badge
                  const SizedBox(
                    height: (10 + 3 + 3),
                  ), // Approx height of badge
              ],
            ),
          ],
        ),
      ),
    );
  }
}
