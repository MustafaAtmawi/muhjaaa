import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/cubits/chat/conversation_cubit.dart';
import 'package:muhjaaa/models/message_model.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/message_bubble.dart';

class ConversationScreen extends StatefulWidget {
  final String doctorName;
  final String conversationId;
  final String doctorPlaceholder;
  final String? doctorAvatarUrl;

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
  final String _timerDisplay = "15:00";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = context.read<ConversationCubit>().state;
        if (state is ConversationLoaded && state.messages.isNotEmpty) {
          _scrollToBottom(animate: false);
        } else if (state is ConversationSending && state.messages.isNotEmpty) {
          _scrollToBottom(animate: false);
        }
      }
    });
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
    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      context.read<ConversationCubit>().sendMessage(messageText);
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildMessageListView(
    List<MessageModel> messagesToDisplay,
    ConversationState currentState,
  ) {
    if (messagesToDisplay.isEmpty) {
      if (currentState is ConversationLoading ||
          currentState is ConversationInitial) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryRed),
        );
      }
      return Center(
        child: Text(
          "ابدأ محادثتك مع ${widget.doctorName}",
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            color: AppColors.lightGrey,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      itemCount: messagesToDisplay.length,
      itemBuilder: (context, index) {
        final message = messagesToDisplay[index];
        String? otherPartyAvatarInitial = widget.doctorPlaceholder;
        return MessageBubble(
          text: message.text,
          senderType: message.senderType,
          avatarInitial: message.senderType == SenderType.otherParty
              ? otherPartyAvatarInitial
              : message.avatarInitial,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.darkGreyText,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                /* TODO: Doctor profile action */
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color.fromRGBO(
                      154,
                      181,
                      189,
                      0.3,
                    ), // AppColors.mutedBlueGrey.withOpacity(0.3)
                    backgroundImage:
                        widget.doctorAvatarUrl != null &&
                            widget.doctorAvatarUrl!.isNotEmpty
                        ? NetworkImage(widget.doctorAvatarUrl!)
                        : null,
                    child:
                        (widget.doctorAvatarUrl == null ||
                            widget.doctorAvatarUrl!.isEmpty)
                        ? Text(
                            widget.doctorPlaceholder.isNotEmpty
                                ? widget.doctorPlaceholder[0].toUpperCase()
                                : 'D',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.doctorName,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.darkGreyText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'متصل الآن',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          color: AppColors.positiveGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 1.0,
                  ),
                  child: Text(
                    _timerDisplay,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ConversationCubit, ConversationState>(
              listener: (context, state) {
                if (state is ConversationLoaded && state.messages.isNotEmpty) {
                  _scrollToBottom();
                } else if (state is ConversationSending &&
                    state.messages.isNotEmpty) {
                  _scrollToBottom();
                } else if (state is ConversationError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message, textAlign: TextAlign.right),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                List<MessageModel> messagesToDisplay = [];

                if (state is ConversationLoaded) {
                  messagesToDisplay = state.messages;
                } else if (state is ConversationSending) {
                  messagesToDisplay = state.messages;
                } else if (state is ConversationError) {
                  messagesToDisplay = state.previousMessages;
                } else if (state is ConversationInitial ||
                    state is ConversationLoading) {
                  messagesToDisplay = [];
                }
                return _buildMessageListView(messagesToDisplay, state);
              },
            ),
          ),
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
                  color: AppColors.searchBarBg,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          hintText: 'اكتب رسالة...',
                          hintStyle: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                            color: AppColors.lightGrey,
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
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/Insert_File.svg',
                        width: 26,
                        height: 26,
                        colorFilter: const ColorFilter.mode(
                          Color.fromRGBO(
                            100,
                            99,
                            99,
                            0.7,
                          ), // AppColors.darkGreyText.withOpacity(0.7)
                          BlendMode.srcIn,
                        ),
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.attach_file,
                              color: AppColors.darkGreyText,
                            ),
                      ),
                      onPressed: () {
                        // print("Attach file tapped");
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/Insert_Image.svg',
                        width: 26,
                        height: 26,
                        colorFilter: const ColorFilter.mode(
                          Color.fromRGBO(
                            100,
                            99,
                            99,
                            0.7,
                          ), // AppColors.darkGreyText.withOpacity(0.7)
                          BlendMode.srcIn,
                        ),
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.image_outlined,
                              color: AppColors.darkGreyText,
                            ),
                      ),
                      onPressed: () {
                        // print("Insert image tapped");
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/Send_message.svg',
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.send, color: AppColors.primaryRed),
                      ),
                      onPressed: _sendMessage,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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
