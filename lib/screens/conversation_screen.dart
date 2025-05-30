import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // Not used directly
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/message_bubble.dart'; // Make sure SenderType is imported

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final String _appBarTimerDisplay = "15:00";
  Timer? _timer;

  // Updated Mock messages to use SenderType
  final List<Map<String, dynamic>> _messages = [
    // Assuming the first message from "م" (Muhja/Doctor) is SenderType.otherParty here
    {
      'text':
          'مرحباً ماما 👋 أنا مهجة مساعدتك الذكية! كيف يمكنني مساعدتك اليوم؟',
      'senderType': SenderType.otherParty,
      'avatarInitial': 'م',
    },
    {
      'text': 'مرحباً مهجة، ابني عمره 7 شهور وبصحى كتير بالليل، تعبت جداً 😥',
      'senderType': SenderType.me,
      'avatarInitial': 'أ',
    },
    {
      'text':
          'أهلاً ماما 👋 نوم الأطفال بهذا العمر فعلاً ممكن يكون متقطع ممكن تساعديني بأدوية صغيرة حتى أفهم الوضع أكثر؟',
      'senderType': SenderType.me,
      'avatarInitial': 'أ',
    },
    {
      'text': 'طبعاً',
      'senderType': SenderType.otherParty,
      'avatarInitial': 'م',
    },
    {
      'text': 'هل يرضع قبل النوم مباشرة؟ وهل ينام بغرفته ولا معك؟',
      'senderType': SenderType.otherParty,
      'avatarInitial': 'م',
    },
    {
      'text': 'يرضع قبله، وبينام معي بنفس الغرفة',
      'senderType': SenderType.me,
      'avatarInitial': 'أ',
    },
    {
      'text':
          'تمام، من الأفضل تقليل الاعتماد على الرضاعة كوسيلة أساسية للنوم. حاولي تقديم وجبة مشبعة قبل ساعة من النوم، ثم روتين هادئ مثل حمام دافئ وقراءة قصة.',
      'senderType': SenderType.otherParty,
      'avatarInitial': 'م',
    },
    {
      'text': 'فكرة جيدة، سأجرب ذلك. شكراً لك!',
      'senderType': SenderType.me,
      'avatarInitial': 'أ',
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'text': _messageController.text.trim(),
        'senderType': SenderType.me, // Messages sent by user are SenderType.me
        'avatarInitial': 'أ',
      });
      _messageController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
    // TODO: Actual send message logic (API call)
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
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors
                        .mutedBlueGrey, // Placeholder for doctor avatar
                    child: Text(
                      "DR",
                      style: TextStyle(
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
                        const Text(
                          "د.خالد رامي",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.darkGreyText,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
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
                              "متصل الآن",
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _appBarTimerDisplay,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balances the leading IconButton
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: false,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final messageData = _messages[index];
                // User messages should not show an avatar as per recent clarification for AI Chat
                // For ConversationScreen, user avatar with initial 'أ' seems fine based on previous screenshots.
                // AI Mama has her image. Doctor (otherParty) has an initial.
                String? avatarInitialForBubble;
                String? avatarAssetPathForBubble;

                if (messageData['senderType'] == SenderType.me) {
                  avatarInitialForBubble = messageData['avatarInitial'];
                } else if (messageData['senderType'] == SenderType.otherParty) {
                  avatarInitialForBubble = messageData['avatarInitial'];
                }
                // No avatarAssetPath needed for ConversationScreen's SenderType.otherParty or SenderType.me

                return MessageBubble(
                  text: messageData['text'],
                  senderType:
                      messageData['senderType'], // Now correctly passing SenderType
                  avatarInitial: avatarInitialForBubble,
                  avatarAssetPath:
                      avatarAssetPathForBubble, // Will be null here
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: const BoxDecoration(color: AppColors.messageInputBg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    print("Mama Muhja AI avatar tapped in input");
                  },
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      'assets/images/AI_mama.png',
                      fit: BoxFit.contain,
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
      ),
    );
  }
}
