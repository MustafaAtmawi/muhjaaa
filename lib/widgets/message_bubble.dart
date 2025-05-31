import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/models/message_model.dart'; // Import SenderType from message_model

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

    if (avatarAssetPath != null && avatarAssetPath!.isNotEmpty) {
      Widget avatarImage;
      if (avatarAssetPath!.toLowerCase().endsWith('.svg')) {
        avatarImage = SvgPicture.asset(
          avatarAssetPath!,
          width: 32,
          height: 32,
          fit: BoxFit.cover,
          placeholderBuilder: (BuildContext context) =>
              const Icon(Icons.person, size: 16, color: AppColors.lightGrey),
        );
      } else {
        avatarImage = Image.asset(
          avatarAssetPath!,
          width: 32,
          height: 32,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person,
              size: 16,
              color: AppColors.lightGrey,
            );
          },
        );
      }
      currentAvatarWidget = Padding(
        padding: const EdgeInsets.all(
          20,
        ), // This padding seems large for an avatar in a bubble row
        child: CircleAvatar(
          radius: 16,
          backgroundColor: Colors.transparent,
          child: ClipOval(child: avatarImage),
        ),
      );
    } else if (avatarInitial != null && avatarInitial!.isNotEmpty) {
      Color avatarBgColor = AppColors.mutedBlueGrey.withAlpha(
        (0.7 * 255).round(),
      );
      if (senderType == SenderType.me) {
        avatarBgColor = AppColors.primaryOrange.withAlpha((0.7 * 255).round());
      }

      currentAvatarWidget = Padding(
        padding: EdgeInsets.only(
          left: isSenderMe ? 0 : 10,
          right: !isSenderMe ? 20 : 10, // Adjusted padding for consistency
          top:
              10, // Consider aligning with bubble or removing if bubble handles spacing
          bottom:
              10, // Consider aligning with bubble or removing if bubble handles spacing
        ),
        child: CircleAvatar(
          radius: 16,
          backgroundColor: avatarBgColor,
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

    if (senderType == SenderType.me) {
      bubbleColor = AppColors.primaryRed;
      textColor = AppColors.white;
      rowMainAxisAlignment = MainAxisAlignment.end;
    } else if (senderType == SenderType.aiMama) {
      bubbleColor = AppColors.aiMessageBubbleBg;
      textColor = AppColors.darkGreyText;
      rowMainAxisAlignment = MainAxisAlignment.start;
    } else {
      // SenderType.otherParty (Doctor)
      bubbleColor = AppColors.userMessageBg;
      textColor = AppColors.darkGreyText;
      rowMainAxisAlignment = MainAxisAlignment.start;
    }

    final BorderRadius borderRadius = isSenderMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(4), // Distinctive shape for sender
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(4), // Distinctive shape for receiver
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
            mainAxisSize: MainAxisSize.min, // Important for intrinsic width
            children: [
              if (isBulletPoint)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 0,
                    left: 4.0,
                    top: 4.5,
                  ), // Adjust for RTL if bullet should be on right
                  child: Icon(
                    Icons.circle,
                    size: 6,
                    color: textColor.withAlpha((0.7 * 255).round()),
                  ),
                ),
              Flexible(
                // Ensures text wraps within the bubble's constraints
                child: Text(
                  isBulletPoint ? line.trim().substring(2).trim() : line.trim(),
                  textAlign: isSenderMe
                      ? TextAlign.end
                      : TextAlign.start, // Correct for RTL
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
        crossAxisAlignment:
            CrossAxisAlignment.end, // Aligns avatar with bottom of bubble
        children: [
          if (!isSenderMe && currentAvatarWidget != null) currentAvatarWidget,
          Flexible(
            // Allow bubble to take available space but not overflow
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
                mainAxisSize: MainAxisSize.min, // Bubble fits content
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
