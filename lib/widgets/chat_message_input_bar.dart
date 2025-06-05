import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class ChatMessageInputBar extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onSendMessage;
  final VoidCallback? onAttachFile; // Made optional
  final VoidCallback? onInsertImage; // Made optional
  final FocusNode? focusNode;

  const ChatMessageInputBar({
    super.key,
    required this.messageController,
    required this.onSendMessage,
    this.onAttachFile,
    this.onInsertImage,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8.0,
      color: Colors.white, // Background of the bar's container
      child: Padding(
        padding: EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top: 8.0,
          bottom:
              8.0 +
              MediaQuery.of(context).padding.bottom, // Safe area for bottom
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.searchBarBg, // Background of the text field area
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const SizedBox(width: 8), // Padding for text field start
              Expanded(
                child: TextField(
                  controller: messageController,
                  focusNode: focusNode,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    hintText: 'اكتب رسالة...',
                    hintStyle: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      color: AppColors.lightGrey, // Hint text color
                    ),
                    border:
                        InputBorder.none, // No border for the text field itself
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                    ), // Vertical padding
                  ),
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    color: AppColors.darkGreyText, // Input text color
                  ),
                  minLines: 1,
                  maxLines: 4, // Allow multi-line input
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSendMessage(),
                ),
              ),
              const SizedBox(width: 4),
              if (onAttachFile != null)
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/Insert_File.svg', // Ensure asset exists
                    width: 26,
                    height: 26,
                    colorFilter: const ColorFilter.mode(
                      AppColors.darkGreyText70, // Using AppColor
                      BlendMode.srcIn,
                    ),
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.attach_file,
                      color: AppColors.darkGreyText70,
                    ),
                  ),
                  onPressed: onAttachFile,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (onInsertImage != null)
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/Insert_Image.svg', // Ensure asset exists
                    width: 26,
                    height: 26,
                    colorFilter: const ColorFilter.mode(
                      AppColors.darkGreyText70, // Using AppColor
                      BlendMode.srcIn,
                    ),
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_outlined,
                      color: AppColors.darkGreyText70,
                    ),
                  ),
                  onPressed: onInsertImage,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/Send_message.svg', // Ensure asset exists
                  // No colorFilter needed if the SVG is already the desired color (e.g., AppColors.primaryRed)
                  // If it needs to be colored, apply a ColorFilter:
                  // colorFilter: const ColorFilter.mode(AppColors.primaryRed, BlendMode.srcIn),
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.send, color: AppColors.primaryRed),
                ),
                onPressed: onSendMessage,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
