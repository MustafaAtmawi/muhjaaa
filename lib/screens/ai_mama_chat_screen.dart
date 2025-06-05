import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/cubits/chat/conversation_cubit.dart';
import 'package:muhjaaa/models/message_model.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/message_bubble.dart';
import 'package:muhjaaa/widgets/chat_message_input_bar.dart'; // Import the shared widget

class AiMamaChatScreen extends StatefulWidget {
  const AiMamaChatScreen({super.key});

  @override
  State<AiMamaChatScreen> createState() => _AiMamaChatScreenState();
}

class _AiMamaChatScreenState extends State<AiMamaChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode(); // Optional: for managing focus
  bool _isSpeaking = false; // Local UI state for the speaker icon

  @override
  void initState() {
    super.initState();
    // Fetch messages if not already loaded by cubit (e.g., if screen can be pushed directly)
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (mounted) { // Check if cubit needs initial fetch if not handled by route generation
    //      final cubit = context.read<ConversationCubit>();
    //      if (cubit.state is ConversationInitial) { // Or some other suitable check
    //          cubit.fetchMessages();
    //      }
    //      _scrollToBottom(animate: false);
    //   }
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Attempt to scroll only if there's content.
        if (_scrollController.hasClients &&
            _scrollController.position.hasContentDimensions) {
          _scrollToBottom(animate: false);
        }
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animate = true}) {
    if (!_scrollController.hasClients ||
        !_scrollController.position.hasContentDimensions)
      return;

    // Debounce or delay slightly if called rapidly, e.g. after keyboard shows
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          _scrollController.hasClients &&
          _scrollController.position.hasContentDimensions) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        if (animate) {
          _scrollController.animateTo(
            maxScroll,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(maxScroll);
        }
      }
    });
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;
    context.read<ConversationCubit>().sendMessage(messageText);
    _messageController.clear();
    _inputFocusNode.requestFocus(); // Keep focus on input field after sending
  }

  // Placeholder actions for attach/insert image
  void _onAttachFile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Attach file action placeholder",
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  void _onInsertImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Insert image action placeholder",
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The ConversationCubit should be provided by the route in main.dart
    // final conversationCubit = context.read<ConversationCubit>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0.5,
          leadingWidth: 40, // Adjusted for custom back button spacing
          leading: IconButton(
            padding: const EdgeInsets.only(
              right: 8.0,
            ), // For RTL, back is on right
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.darkGreyText,
              size: 22,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            mainAxisSize:
                MainAxisSize.min, // To keep content centered if possible
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
                    'assets/images/Ai_Mama.svg', // Ensure asset exists
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
            const SizedBox(width: 4), // Padding for the last icon
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ConversationCubit, ConversationState>(
              listener: (context, state) {
                if (state is ConversationError) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                          textAlign: TextAlign.right,
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                }
                if (state is ConversationLoaded ||
                    state is ConversationSending) {
                  // Scroll after messages are potentially updated
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _scrollToBottom(),
                  );
                }
              },
              builder: (context, state) {
                List<MessageModel> messages = [];
                if (state is ConversationLoaded) {
                  messages = state.messages;
                } else if (state is ConversationSending) {
                  messages = state.messages; // Show optimistic messages
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
          // "Typing" indicator logic (moved slightly for clarity if needed)
          BlocBuilder<ConversationCubit, ConversationState>(
            builder: (context, state) {
              if (state is ConversationSending) {
                // Check if the AI is "typing" (i.e., user just sent a message)
                // This simple check assumes AI replies after user.
                // A more robust way is a dedicated flag in ConversationState like `isAiTyping`.
                if (state.messages.isNotEmpty &&
                    state.messages.last.senderType == SenderType.me) {
                  return const Padding(
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
                  );
                }
              }
              return const SizedBox.shrink(); // No typing indicator otherwise
            },
          ),
          // Use the shared ChatMessageInputBar widget
          ChatMessageInputBar(
            messageController: _messageController,
            onSendMessage: _sendMessage,
            onAttachFile: _onAttachFile, // Pass the handler
            onInsertImage: _onInsertImage, // Pass the handler
            focusNode: _inputFocusNode,
          ),
        ],
      ),
    );
  }
}
