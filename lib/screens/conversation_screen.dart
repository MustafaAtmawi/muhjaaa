import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muhjaaa/cubits/chat/conversation_cubit.dart';
import 'package:muhjaaa/models/message_model.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/message_bubble.dart';

class ConversationScreen extends StatefulWidget {
  final String doctorName;
  final String conversationId; // This will be used by the Cubit
  final String doctorPlaceholder;
  final String? doctorAvatarUrl; // Optional

  const ConversationScreen({
    super.key,
    required this.doctorName,
    required this.conversationId,
    required this.doctorPlaceholder,
    this.doctorAvatarUrl,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // final String _appBarTimerDisplay = "15:00"; // Timer logic would be separate

  @override
  void initState() {
    super.initState();
    // Messages are fetched by the Cubit when it's created for this route
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
    // The conversationId is already part of the Cubit instance for this screen
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
        preferredSize: const Size.fromHeight(65.0),
        child: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.darkGreyText,
                      size: 22,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.mutedBlueGrey,
                    // TODO: Use widget.doctorAvatarUrl if available with Image.network
                    child: Text(
                      widget.doctorPlaceholder,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctorName,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.darkGreyText,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        // TODO: Fetch and display actual doctor status (online/offline)
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.positiveGreen,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              "متصل الآن", // This should come from doctor's status
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: AppColors.positiveGreen,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Timer display - This would require separate logic (e.g., another Cubit or local state with Timer)
                  // For now, keeping it static as in original code.
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  //   decoration: BoxDecoration(color: AppColors.primaryRed, borderRadius: BorderRadius.circular(20)),
                  //   child: Text(
                  //     _appBarTimerDisplay,
                  //     style: const TextStyle(
                  //         fontFamily: 'Cairo', color: AppColors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  // const SizedBox(width: 48), // Balances the leading IconButton
                ],
              ),
            ),
          ),
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
                    ? Center(
                        child: Text(
                          "ابدأ محادثتك مع ${widget.doctorName}",
                          style: const TextStyle(
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        "${widget.doctorName} يكتب...",
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
                    // AI Mama avatar is not relevant here, so removing it for doctor chat
                    // InkWell(
                    //   onTap: () {}, // No action or different action
                    //   child: CircleAvatar(
                    //     radius: 22,
                    //     backgroundColor: Colors.transparent,
                    //     // child: Image.asset('assets/images/AI_mama.png', fit: BoxFit.contain),
                    //   ),
                    // ),
                    // const SizedBox(width: 8),
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
                    const SizedBox(width: 8),
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
                    const SizedBox(width: 0),
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
                    const SizedBox(width: 8),
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
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
