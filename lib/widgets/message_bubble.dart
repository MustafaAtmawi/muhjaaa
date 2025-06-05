import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/models/message_model.dart'; // Import SenderType

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
    bool isAiMama = senderType == SenderType.aiMama;

    Color bubbleColor;
    Color textColor;
    MainAxisAlignment rowMainAxisAlignment;
    CrossAxisAlignment bubbleCrossAxisAlignment;
    Widget? avatarWidget;

    // Avatar Logic
    if (!isSenderMe) {
      // Avatars for AI Mama and OtherParty
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
        avatarWidget = CircleAvatar(
          radius: 16,
          backgroundColor: Colors
              .transparent, // SVG/Image might have its own bg or be transparent
          child: ClipOval(child: avatarImage),
        );
      } else if (avatarInitial != null && avatarInitial!.isNotEmpty) {
        avatarWidget = CircleAvatar(
          radius: 16,
          backgroundColor: isAiMama
              ? AppColors
                    .aiMessageBubbleBg // Or a dedicated AI avatar bg color
              : const Color.fromRGBO(
                  154,
                  181,
                  189,
                  0.7,
                ), // mutedBlueGrey for otherParty
          child: Text(
            avatarInitial!,
            style: TextStyle(
              color: isAiMama
                  ? AppColors.primaryRed
                  : AppColors.white, // Contrasting color
              fontSize: 12,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    } else {
      // SenderType.me
      if (avatarInitial != null && avatarInitial!.isNotEmpty) {
        avatarWidget = CircleAvatar(
          radius: 16,
          backgroundColor: const Color.fromRGBO(
            245,
            176,
            71,
            0.7,
          ), // primaryOrange with 0.7 opacity
          child: Text(
            avatarInitial!,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    }

    // Bubble and Text Color Logic
    if (isSenderMe) {
      bubbleColor = AppColors.primaryRed;
      textColor = AppColors.white;
      rowMainAxisAlignment = MainAxisAlignment.end;
      bubbleCrossAxisAlignment = CrossAxisAlignment.end;
    } else if (isAiMama) {
      bubbleColor = AppColors.aiMessageBubbleBg;
      textColor = AppColors.darkGreyText;
      rowMainAxisAlignment = MainAxisAlignment.start;
      bubbleCrossAxisAlignment = CrossAxisAlignment.start;
    } else {
      // SenderType.otherParty (Doctor)
      bubbleColor = AppColors.userMessageBg;
      textColor = AppColors.darkGreyText;
      rowMainAxisAlignment = MainAxisAlignment.start;
      bubbleCrossAxisAlignment = CrossAxisAlignment.start;
    }

    final BorderRadius borderRadius = isSenderMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(4),
          );

    List<Widget> textLines = [];
    final lines = text.split('\n');
    for (String lineContent in lines) {
      bool isBulletPoint = lineContent.trim().startsWith('• ');
      textLines.add(
        Padding(
          padding: EdgeInsets.only(top: textLines.isEmpty ? 0 : 2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection
                .rtl, // Ensures bullet is on the right for RTL text
            children: [
              if (isBulletPoint)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 4.0,
                    right: 0,
                    top: 4.5,
                  ), // Adjusted for RTL bullet
                  child: Icon(
                    Icons.circle,
                    size: 6,
                    color: Color.fromRGBO(
                      textColor.red,
                      textColor.green,
                      textColor.blue,
                      0.7,
                    ),
                  ),
                ),
              Flexible(
                child: Text(
                  isBulletPoint
                      ? lineContent.trim().substring(2).trim()
                      : lineContent.trim(),
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
          if (!isSenderMe && avatarWidget != null) ...[
            avatarWidget,
            const SizedBox(width: 8),
          ],
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
                crossAxisAlignment: bubbleCrossAxisAlignment,
                children: textLines,
              ),
            ),
          ),
          if (isSenderMe && avatarWidget != null) ...[
            const SizedBox(width: 8),
            avatarWidget,
          ],
        ],
      ),
    );
  }
}
