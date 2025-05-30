import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // Not used directly
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/message_bubble.dart';

class AiMamaChatScreen extends StatefulWidget {
  const AiMamaChatScreen({super.key});

  @override
  State<AiMamaChatScreen> createState() => _AiMamaChatScreenState();
}

class _AiMamaChatScreenState extends State<AiMamaChatScreen> {
  int _bottomNavIndex = 2; // "Home" is the 3rd item, so index 2
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _timer; // If a timer were used for something on this screen

  // Mock messages for AI Mama Chat
  final List<Map<String, dynamic>> _messages = [
    {
      'text':
          'مرحباً ماما 👋 أنا مهجة مساعدتك الذكية! كيف يمكنني مساعدتك اليوم؟',
      'senderType': SenderType.aiMama,
      'avatarAsset': 'assets/images/AI_mama.png',
    },
    {
      'text': 'مرحباً مهجة، ابني عمره 7 شهور وبصحى كتير بالليل، تعبت جداً 😥',
      'senderType': SenderType.me,
      'avatarInitial': 'أ',
    }, // User avatar initial, or null if no avatar
    {
      'text':
          'أهلاً ماما 👋 نوم الأطفال بهذا العمر فعلاً ممكن يكون متقطع. ممكن تفصلي أكتر عن روتين يومه؟',
      'senderType': SenderType.aiMama,
      'avatarAsset': 'assets/images/AI_mama.png',
    },
    {
      'text':
          'شكراً ❤️ هي بعض النصائح تساعد على نوم أعمق:\n• حاولي، تعملي روتين نوم ثابت (حمام دافئ، تهدئة الغرفة، تهدئة).\n• خلي وقت القيلولة لا يتجاوز الـ3 ساعات.\n• لا ترضعيه لينام حتى في آخر رضعة قبل النوم بـ20 دقيقة.\n• إذا صحي، لا تحمليه فوراً، جربي تطبطبي عليه وهو بسريره.',
      'senderType': SenderType.aiMama,
      'avatarAsset': 'assets/images/AI_mama.png',
    },
    {
      'text': 'راح اجرب هاذ الروتين اليومي، شكراً كتير ❤️',
      'senderType': SenderType.me,
      'avatarInitial': 'أ',
    },
  ];

  // State for AppBar icons
  bool _isSpeaking = false;

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
    final userMessage = _messageController.text.trim();
    setState(() {
      _messages.add({
        'text': userMessage,
        'senderType': SenderType.me,
        'avatarInitial':
            'أ', // User avatar if needed, else null if "only mama have circular avatar" means no user avatar at all
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
    // TODO: Send message to AI backend and add AI response to _messages
    // For now, simulate an AI response:
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add({
          'text': "فهمتك يا ماما، سأبحث لك عن أفضل النصائح بخصوص هذا الموضوع.",
          'senderType': SenderType.aiMama,
          'avatarAsset': 'assets/images/AI_mama.png',
        });
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
    });
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
          leadingWidth: 40, // Adjusted for single back button
          leading: IconButton(
            padding: const EdgeInsets.only(
              right: 8.0,
            ), // Adjust padding for RTL
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
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(
                  'assets/images/AI_mama.png',
                ), // Ensure asset exists
              ),
            ],
          ),
          centerTitle: true, // To center the Row in the title space
          actions: [
            IconButton(
              icon: Icon(
                _isSpeaking
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded, // Dynamic icon
                color: AppColors.darkGreyText,
                size: 24,
              ),
              onPressed: () {
                setState(() {
                  _isSpeaking = !_isSpeaking;
                });
                // TODO: Implement text-to-speech toggle logic
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
              },
            ),
            const SizedBox(width: 4), // Adjust spacing if needed
          ],
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
                return MessageBubble(
                  text: messageData['text'],
                  senderType: messageData['senderType'],
                  avatarInitial: messageData['senderType'] == SenderType.me
                      ? messageData['avatarInitial']
                      : null,
                  avatarAssetPath:
                      messageData['senderType'] == SenderType.aiMama
                      ? messageData['avatarAsset']
                      : null,
                );
              },
            ),
          ),
          // Message Input Area (No AI Mama avatar here as per request)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: const BoxDecoration(color: AppColors.messageInputBg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Send Button (Leftmost)
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
                // Attachment Icon
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
                // Camera Icon
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
                // Text Field (Rightmost, Expanded)
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            2, // "Home" is typically the middle (2nd index if 0-based 5 items)
        onTap: (index) {
          setState(() {
            _bottomNavIndex =
                index; // Update state if needed, though this screen might not manage global nav
          });
          // TODO: Implement actual navigation
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.lightGrey,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 10,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "الملف الشخصي",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
            label: "المتجر",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: "مقالات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps_outlined),
            activeIcon: Icon(Icons.apps),
            label: "المزيد",
          ),
        ],
      ),
    );
  }
}
