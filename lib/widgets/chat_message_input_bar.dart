// lib/widgets/chat_message_input_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class ChatMessageInputBar extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onSendMessage;
  final VoidCallback? onAttachFile; // Optional: if you implement it
  final VoidCallback? onInsertImage; // Optional: if you implement it
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
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top: 8.0,
          bottom: 8.0 + MediaQuery.of(context).padding.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.searchBarBg, // Or AppColors.messageInputBg
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const SizedBox(width: 8),
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
                      color: AppColors
                          .lightGrey, // Or AppColors.messageInputHintText
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    color: AppColors.darkGreyText,
                  ),
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSendMessage(),
                ),
              ),
              const SizedBox(width: 4),
              if (onAttachFile != null)
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/Insert_File.svg',
                    width: 26,
                    height: 26,
                    colorFilter: ColorFilter.mode(
                      AppColors.darkGreyText.withOpacity(0.7),
                      BlendMode.srcIn,
                    ),
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.attach_file,
                      color: AppColors.darkGreyText,
                    ),
                  ),
                  onPressed: onAttachFile,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (onInsertImage != null)
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/Insert_Image.svg',
                    width: 26,
                    height: 26,
                    colorFilter: ColorFilter.mode(
                      AppColors.darkGreyText.withOpacity(0.7),
                      BlendMode.srcIn,
                    ),
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_outlined,
                      color: AppColors.darkGreyText,
                    ),
                  ),
                  onPressed: onInsertImage,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/Send_message.svg',
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
