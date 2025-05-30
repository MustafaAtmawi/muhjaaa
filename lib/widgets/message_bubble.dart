import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart';

// Define SenderType enum here
enum SenderType { me, otherParty, aiMama }

class MessageBubble extends StatelessWidget {
  final String text;
  final SenderType senderType;
  final String? avatarInitial;
  final String? avatarAssetPath;

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

    if (senderType == SenderType.me) {
      bubbleColor = AppColors.primaryRed;
      textColor = AppColors.white;
      rowMainAxisAlignment = MainAxisAlignment.end;
      if (avatarInitial != null) {
        currentAvatarWidget = Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primaryOrange.withAlpha(
              (0.7 * 255).round(),
            ),
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
      bubbleColor = AppColors.aiMessageBubbleBg;
      textColor = AppColors.darkGreyText;
      rowMainAxisAlignment = MainAxisAlignment.start;
      if (avatarAssetPath != null) {
        currentAvatarWidget = Padding(
          padding: const EdgeInsets.only(right: 8.0),
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
      // SenderType.otherParty
      bubbleColor = AppColors.userMessageBg;
      textColor = AppColors.darkGreyText;
      rowMainAxisAlignment = MainAxisAlignment.start;
      if (avatarInitial != null) {
        currentAvatarWidget = Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.mutedBlueGrey.withAlpha(
              (0.7 * 255).round(),
            ),
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

    List<String> lines = text.split('\n');
    List<Widget> textWidgets = [];
    for (String line in lines) {
      bool isBulletPoint = line.trim().startsWith('• ');
      textWidgets.add(
        Padding(
          padding: EdgeInsets.only(top: textWidgets.isEmpty ? 0 : 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isBulletPoint)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 4.0,
                    right: 0,
                    top: 4.0,
                  ), // For RTL, bullet is left of text line in bubble
                  child: Icon(
                    Icons.circle,
                    size: 6,
                    color: textColor.withAlpha((0.7 * 255).round()),
                  ),
                ),
              Flexible(
                child: Text(
                  isBulletPoint ? line.trim().substring(2).trim() : line.trim(),
                  textAlign: isSenderMe ? TextAlign.end : TextAlign.start,
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: rowMainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSenderMe && currentAvatarWidget != null) currentAvatarWidget,
          Flexible(
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: isSenderMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: textWidgets,
              ),
            ),
          ),
          if (isSenderMe && currentAvatarWidget != null) currentAvatarWidget,
        ],
      ),
    );
  }
}
