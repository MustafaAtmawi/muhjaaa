import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Ensure this is imported
import 'package:muhjaaa/cubits/chat/conversation_cubit.dart';
import 'package:muhjaaa/models/message_model.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/message_bubble.dart';

class AiMamaChatScreen extends StatefulWidget {
  const AiMamaChatScreen({super.key});

  @override
  State<AiMamaChatScreen> createState() => _AiMamaChatScreenState();
}

class _AiMamaChatScreenState extends State<AiMamaChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scrollToBottom(animate: false);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animate = true}) {
    if (!_scrollController.hasClients) return;
    if (!_scrollController.position.hasContentDimensions ||
        _scrollController.position.maxScrollExtent == 0.0) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          _scrollController.hasClients &&
          _scrollController.position.hasContentDimensions) {
        if (animate) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    context.read<ConversationCubit>().sendMessage(
      _messageController.text.trim(),
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        // AppBar remains the same as your last version of AiMamaChatScreen
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0.5,
          leadingWidth: 40,
          leading: IconButton(
            padding: const EdgeInsets.only(right: 8.0),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.darkGreyText,
              size: 22,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "ماما مهجة",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.darkGreyText,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: SvgPicture.asset(
                    'assets/images/Ai_Mama.svg', //
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    placeholderBuilder: (BuildContext context) => const Icon(
                      Icons.person,
                      size: 16,
                      color: AppColors.lightGrey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                _isSpeaking
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded,
                color: AppColors.darkGreyText,
                size: 24,
              ),
              onPressed: () {
                setState(() => _isSpeaking = !_isSpeaking);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _isSpeaking ? "تم تشغيل الصوت" : "تم إيقاف الصوت",
                      textAlign: TextAlign.right,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.share_outlined,
                color: AppColors.darkGreyText,
                size: 24,
              ),
              onPressed: () {
                print("Share/Upload button tapped");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "سيتم تنفيذ المشاركة هنا.",
                      textAlign: TextAlign.right,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
      body: Column(
        // Wrapped body content in a Column to place input bar at bottom
        children: [
          Expanded(
            child: BlocConsumer<ConversationCubit, ConversationState>(
              listener: (context, state) {
                if (state is ConversationError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message, textAlign: TextAlign.right),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                if (state is ConversationLoaded ||
                    state is ConversationSending) {
                  if ((state is ConversationLoaded &&
                          state.messages.isNotEmpty) ||
                      (state is ConversationSending &&
                          state.messages.isNotEmpty)) {
                    _scrollToBottom();
                  }
                }
              },
              builder: (context, state) {
                List<MessageModel> messages = [];
                if (state is ConversationLoaded) {
                  messages = state.messages;
                } else if (state is ConversationSending) {
                  messages = state.messages;
                } else if (state is ConversationError) {
                  messages = state.previousMessages;
                }

                if (state is ConversationLoading && messages.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryRed,
                    ),
                  );
                }

                return messages.isEmpty && state is! ConversationLoading
                    ? const Center(
                        child: Text(
                          "ابدئي المحادثة مع ماما مهجة!",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            color: AppColors.lightGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16.0),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return MessageBubble(
                            text: message.text,
                            senderType: message.senderType,
                            avatarInitial: message.avatarInitial,
                            avatarAssetPath: message.avatarAssetPath,
                          );
                        },
                      );
              },
            ),
          ),
          if (context.watch<ConversationCubit>().state is ConversationSending &&
              (context.watch<ConversationCubit>().state as ConversationSending)
                  .messages
                  .isNotEmpty &&
              (context.watch<ConversationCubit>().state as ConversationSending)
                      .messages
                      .last
                      .senderType ==
                  SenderType.me) // Condition for "ماما مهجة تكتب..."
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "ماما مهجة تكتب...",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.lightGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          // Copied Text Input Section from ConversationScreen.dart
          Material(
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
                  color: AppColors.searchBarBg, //
                  borderRadius: BorderRadius.circular(30.0), //
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0), //
                child: Row(
                  children: [
                    const SizedBox(width: 8), //
                    Expanded(
                      child: TextField(
                        controller:
                            _messageController, // References _messageController from _AiMamaChatScreenState
                        textAlign: TextAlign.right, //
                        decoration: const InputDecoration(
                          hintText:
                              'اكتب رسالة...', // Hint text from ConversationScreen
                          hintStyle: TextStyle(
                            fontFamily: 'Cairo', //
                            fontSize: 15, //
                            color: AppColors.lightGrey, //
                          ),
                          border: InputBorder.none, //
                          contentPadding: EdgeInsets.symmetric(vertical: 10), //
                        ),
                        style: const TextStyle(
                          fontFamily: 'Cairo', //
                          fontSize: 15, //
                          color: AppColors.darkGreyText, //
                        ),
                        minLines: 1, //
                        maxLines: 4, //
                        textInputAction: TextInputAction.send, //
                        onSubmitted: (_) =>
                            _sendMessage(), // References _sendMessage from _AiMamaChatScreenState
                      ),
                    ),
                    const SizedBox(width: 4), //
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/Insert_File.svg', // Path from ConversationScreen - WARNING: This asset is missing
                        width: 26,
                        height: 26,
                        colorFilter: ColorFilter.mode(
                          AppColors.darkGreyText.withOpacity(0.7),
                          BlendMode.srcIn,
                        ),
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              // Fallback from ConversationScreen
                              Icons.attach_file,
                              color: AppColors.darkGreyText,
                            ),
                      ),
                      onPressed: () {
                        /* TODO: Implement attachment logic */ //
                        print("Attach file tapped"); //
                      },
                      padding: EdgeInsets.zero, //
                      constraints: const BoxConstraints(), //
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/Insert_Image.svg', // Path from ConversationScreen - WARNING: This asset is missing
                        width: 26,
                        height: 26,
                        colorFilter: ColorFilter.mode(
                          AppColors.darkGreyText.withOpacity(0.7),
                          BlendMode.srcIn,
                        ),
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              // Fallback from ConversationScreen
                              Icons.image_outlined,
                              color: AppColors.darkGreyText,
                            ),
                      ),
                      onPressed: () {
                        /* TODO: Implement image insertion logic */ //
                        print("Insert image tapped"); //
                      },
                      padding: EdgeInsets.zero, //
                      constraints: const BoxConstraints(), //
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/Send_message.svg', // Path from ConversationScreen, this asset exists
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.send,
                              color: AppColors.primaryRed,
                            ), // Fallback from ConversationScreen
                      ),
                      onPressed:
                          _sendMessage, // References _sendMessage from _AiMamaChatScreenState
                      padding: EdgeInsets.zero, //
                      constraints: const BoxConstraints(), //
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
