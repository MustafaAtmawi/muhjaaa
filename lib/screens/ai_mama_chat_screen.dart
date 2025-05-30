import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  bool _isSpeaking = false; // Local UI state for the speaker icon

  @override
  void initState() {
    super.initState();
    // Messages are fetched by the Cubit when it's created for this route in main.dart
    // Add listener to scroll to bottom when new messages arrive or keyboard appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/images/AI_mama.png'),
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
                // TODO: Implement text-to-speech toggle logic
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
                // TODO: Implement share/upload action
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
      body: BlocConsumer<ConversationCubit, ConversationState>(
        listener: (context, state) {
          if (state is ConversationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, textAlign: TextAlign.right),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is ConversationLoaded || state is ConversationSending) {
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
            messages = state.messages;
          } else if (state is ConversationError) {
            messages = state.previousMessages;
          }

          if (state is ConversationLoading && messages.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryRed),
            );
          }

          return Column(
            children: [
              Expanded(
                child: messages.isEmpty && state is! ConversationLoading
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
                      ),
              ),
              if (state is ConversationSending &&
                  messages.isNotEmpty &&
                  messages.last.senderType == SenderType.me)
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.messageInputBg,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(22),
                      child: InkWell(
                        onTap: _sendMessage,
                        borderRadius: BorderRadius.circular(22),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.send,
                            color: AppColors.white,
                            size: 20,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        /* TODO: Implement attachment logic */
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.attach_file,
                          color: AppColors.mutedBlueGrey,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 0),
                    InkWell(
                      onTap: () {
                        /* TODO: Implement camera logic */
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.mutedBlueGrey,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          color: AppColors.darkGreyText,
                        ),
                        decoration: InputDecoration(
                          hintText: "اكتب رسالتك هنا",
                          hintStyle: const TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.messageInputHintText,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppColors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10.0,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                        textInputAction: TextInputAction.send,
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      // The BottomNavigationBar is not typically part of a detail chat screen.
      // It's usually on top-level screens like ChatListScreen.
      // If you intend for it to be here, ensure _bottomNavIndex is managed appropriately.
      // For now, I'll remove it from this specific chat screen.
    );
  }
}
