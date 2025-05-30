import 'package:muhjaaa/models/chat_preview_model.dart';
import 'package:muhjaaa/models/doctor_model.dart';
import 'package:muhjaaa/models/message_model.dart';
import 'package:muhjaaa/repositories/failure.dart';
import 'package:muhjaaa/widgets/message_bubble.dart'; // For SenderType
import 'auth_repository.dart'; // For FutureEither type

class ChatRepository {
  // In a real app, inject an HTTP client

  FutureEither<List<ChatPreviewModel>> getChatPreviews() async {
    // TODO: Implement actual API call
    print('ChatRepository: Fetching chat previews');
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Mock data
    final mockPreviews = [
      const ChatPreviewModel(
        id: 'chat1',
        senderName: 'د. كريم',
        senderRole: 'طبيب أطفال',
        lastMessage: 'جربي تتبعي روتين النوم يومياً...',
        timestamp: '9:30 PM',
        unreadCount: 1,
        placeholderLetter: 'ك',
      ),
      const ChatPreviewModel(
        id: 'chat2',
        senderName: 'د. علياء',
        senderRole: 'اخصائية تغذية',
        lastMessage: 'بالتأكيد، يمكننا وضع خطة تغذية...',
        timestamp: '8:15 PM',
        unreadCount: 0,
        placeholderLetter: 'ع',
      ),
    ];
    return const Right(mockPreviews);
    // Example of failure:
    // return Left(Failure("Failed to fetch chat previews", statusCode: 500));
  }

  FutureEither<List<DoctorModel>> getActiveDoctors() async {
    // TODO: Implement actual API call
    print('ChatRepository: Fetching active doctors');
    await Future.delayed(const Duration(seconds: 1));

    final mockDoctors = [
      const DoctorModel(
        id: 'doc1',
        name: 'د. أحمد',
        placeholderLetter: 'أ',
        isActive: true,
      ),
      const DoctorModel(
        id: 'doc2',
        name: 'د. فاطمة',
        placeholderLetter: 'ف',
        isActive: true,
      ),
    ];
    return const Right(mockDoctors);
  }

  FutureEither<List<MessageModel>> getMessages(String conversationId) async {
    // TODO: Implement actual API call, using conversationId
    print('ChatRepository: Fetching messages for conversation $conversationId');
    await Future.delayed(const Duration(seconds: 1));

    // Mock data - assuming 'current_user_id' is the ID of the logged-in user
    // You'll need a way to get the current user's ID in a real scenario
    const String currentUserId = "user123"; // Placeholder

    if (conversationId == "ai_mama_chat") {
      final mockMessages = [
        MessageModel(
          id: 'msg1_ai',
          text:
              'مرحباً ماما 👋 أنا مهجة مساعدتك الذكية! كيف يمكنني مساعدتك اليوم؟',
          senderType: SenderType.aiMama,
          senderId: 'ai_mama_id',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          avatarAssetPath: 'assets/images/AI_mama.png',
        ),
        MessageModel(
          id: 'msg2_ai',
          text: 'مرحباً مهجة، ابني عمره 7 شهور وبصحى كتير بالليل، تعبت جداً 😥',
          senderType: SenderType.me,
          senderId:
              currentUserId, // This should be the actual current user's ID
          timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
          avatarInitial: 'أ',
        ),
        MessageModel(
          id: 'msg3_ai',
          text:
              'شكراً ❤️ هي بعض النصائح تساعد على نوم أعمق:\n• حاولي، تعملي روتين نوم ثابت (حمام دافئ، تهدئة الغرفة، تهدئة).\n• خلي وقت القيلولة لا يتجاوز الـ3 ساعات.\n• لا ترضعيه لينام حتى في آخر رضعة قبل النوم بـ20 دقيقة.\n• إذا صحي، لا تحمليه فوراً، جربي تطبطبي عليه وهو بسريره.',
          senderType: SenderType.aiMama,
          senderId: 'ai_mama_id',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          avatarAssetPath: 'assets/images/AI_mama.png',
        ),
      ];
      return Right(mockMessages);
    } else if (conversationId == "chat1") {
      // Example for D. Karim
      final mockMessages = [
        MessageModel(
          id: 'msg1_doc',
          text: 'مرحباً، كيف حال طفلك اليوم؟',
          senderType: SenderType.otherParty,
          senderId: 'doc_karim_id', // Example doctor ID
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          avatarInitial: 'ك',
        ),
        MessageModel(
          id: 'msg2_doc',
          text: 'الحمد لله، لكن ما زال يعاني من بعض المغص.',
          senderType: SenderType.me,
          senderId: currentUserId,
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          avatarInitial: 'أ',
        ),
      ];
      return Right(mockMessages);
    }

    return const Left(Failure("Conversation not found", statusCode: 404));
  }

  FutureEither<MessageModel> sendMessage(
    String conversationId,
    String text,
  ) async {
    // TODO: Implement actual API call
    print(
      'ChatRepository: Sending message "$text" to conversation $conversationId',
    );
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate sending a message and getting it back (or a confirmation)
    // In a real app, the backend would assign the ID and timestamp.
    // The senderId should be the current user's ID.
    const String currentUserId = "user123"; // Placeholder
    final sentMessage = MessageModel(
      id: "msg-${DateTime.now().millisecondsSinceEpoch}",
      text: text,
      senderType: SenderType.me,
      senderId: currentUserId,
      timestamp: DateTime.now(),
      avatarInitial: 'أ', // Assuming 'أ' is the current user's initial
    );
    return Right(sentMessage);
    // Example for AI:
    // If conversationId is for AI, you might get an AI response back instead,
    // or send the user message and then poll/listen for an AI response.
  }
}
