import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart';

// Enum to define sender type for clarity
enum SenderType { me, otherParty, aiMama }

class MessageBubble extends StatelessWidget {
  final String text;
  final SenderType senderType;
  final String? avatarInitial; // For user/doctor placeholder
  final String? avatarAssetPath; // For AI Mama image

  const MessageBubble({
    super.key,
    required this.text,
    required this.senderType,
    this.avatarInitial,
    this.avatarAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    bool isSenderMe = senderType == SenderType.me;

    Color bubbleColor;
    Color textColor;
    MainAxisAlignment rowMainAxisAlignment;
    Widget? currentAvatarWidget;

    // Determine styling and avatar based on senderType
    if (senderType == SenderType.me) {
      // User's message
      bubbleColor = AppColors.primaryRed;
      textColor = AppColors.white;
      rowMainAxisAlignment = MainAxisAlignment.end;
      if (avatarInitial != null) {
        currentAvatarWidget = Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
          ), // Avatar appears to the left of the bubble (end of Row for RTL)
          child: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primaryOrange.withOpacity(
              0.7,
            ), // Example color for user avatar bg
            child: Text(
              avatarInitial!,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        );
      }
    } else if (senderType == SenderType.aiMama) {
      // AI Mama's message
      bubbleColor = AppColors.aiMessageBubbleBg;
      textColor = AppColors.darkGreyText;
      rowMainAxisAlignment = MainAxisAlignment.start;
      if (avatarAssetPath != null) {
        currentAvatarWidget = Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
          ), // Avatar appears to the right of the bubble (start of Row for RTL)
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.asset(
                avatarAssetPath!,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }
    } else {
      // SenderType.otherParty (e.g., Doctor in ConversationScreen)
      bubbleColor =
          AppColors.userMessageBg; // Greyish background for doctor/other
      textColor = AppColors.darkGreyText;
      rowMainAxisAlignment = MainAxisAlignment.start;
      if (avatarInitial != null) {
        currentAvatarWidget = Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
          ), // Avatar appears to the right of the bubble
          child: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.mutedBlueGrey.withOpacity(
              0.7,
            ), // Consistent placeholder color
            child: Text(
              avatarInitial!,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        );
      }
    }

    // Bubble border radius
    final BorderRadius borderRadius = isSenderMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(4),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(4),
            bottomLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          );

    // Handle bullet points in text
    List<String> lines = text.split('\n');
    List<Widget> textWidgets = [];
    for (String line in lines) {
      bool isBulletPoint = line.trim().startsWith('• ');
      textWidgets.add(
        Padding(
          padding: EdgeInsets.only(top: textWidgets.isEmpty ? 0 : 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Important for Row inside Flexible
            children: [
              if (isBulletPoint)
                Padding(
                  // For RTL, bullet should be on the right of the text line in the bubble
                  padding: const EdgeInsets.only(left: 4.0, right: 0, top: 4.0),
                  child: Icon(
                    Icons.circle,
                    size: 6,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              Flexible(
                // Allow text to wrap within the bubble
                child: Text(
                  isBulletPoint ? line.trim().substring(2).trim() : line.trim(),
                  textAlign: isSenderMe
                      ? TextAlign.end
                      : TextAlign.start, // Text alignment within the bubble
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: textColor,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ), // Reduced vertical padding between bubbles
      child: Row(
        mainAxisAlignment: rowMainAxisAlignment,
        crossAxisAlignment:
            CrossAxisAlignment.end, // Aligns avatar with bottom of bubble
        children: [
          // Avatar on the left for otherParty or aiMama (visual right in RTL)
          if (!isSenderMe && currentAvatarWidget != null) currentAvatarWidget,

          Flexible(
            // Ensures bubble takes appropriate width and constraints
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: borderRadius,
              ),
              child: Column(
                // Use Column for potentially multi-line bulleted text
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: isSenderMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: textWidgets,
              ),
            ),
          ),

          // Avatar on the right for user's messages (visual left in RTL)
          if (isSenderMe && currentAvatarWidget != null) currentAvatarWidget,
        ],
      ),
    );
  }
}
