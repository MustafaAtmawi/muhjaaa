import 'package:muhjaaa/models/chat_preview_model.dart';
import 'package:muhjaaa/models/doctor_model.dart'; // For SenderType and DoctorModel
import 'package:muhjaaa/models/message_model.dart'; // For SenderType and MessageModel
import 'package:muhjaaa/repositories/failure.dart';
import 'package:muhjaaa/utils/either.dart'; // For FutureEither type and Either definition

class ChatRepository {
  FutureEither<List<ChatPreviewModel>> getChatPreviews() async {
    await Future.delayed(const Duration(seconds: 1));
    final List<ChatPreviewModel> mockPreviews = [
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
    return Right(mockPreviews);
  }

  FutureEither<List<DoctorModel>> getActiveDoctors() async {
    await Future.delayed(const Duration(seconds: 1));
    final List<DoctorModel> mockDoctors = [
      const DoctorModel(
        id: 'doc1',
        name: 'د. أحمد',
        specialty: 'طبيب عام', // MODIFIED: Added specialty
        placeholderLetter: 'أ',
        isActive: true,
      ),
      const DoctorModel(
        id: 'doc2',
        name: 'د. فاطمة',
        specialty: 'اخصائية اطفال', // MODIFIED: Added specialty
        placeholderLetter: 'ف',
        isActive: true,
      ),
    ];
    return Right(mockDoctors);
  }

  FutureEither<List<MessageModel>> getMessages(String conversationId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      const String currentUserId = "user123"; // Placeholder

      if (conversationId == "ai_mama_chat") {
        final List<MessageModel> mockMessages = [
          MessageModel(
            id: 'msg1_ai',
            text:
                'مرحباً ماما 👋 أنا مهجة مساعدتك الذكية! كيف يمكنني مساعدتك اليوم؟',
            senderType: SenderType.aiMama,
            senderId: 'ai_mama_id',
            timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
            avatarAssetPath: 'assets/images/Ai_Mama.svg',
          ),
          MessageModel(
            id: 'msg2_ai',
            text:
                'مرحباً مهجة، ابني عمره 7 شهور وبصحى كتير بالليل، تعبت جداً 😥',
            senderType: SenderType.me,
            senderId: currentUserId, // Use placeholder
            timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
            avatarInitial: 'أ', // Placeholder initial for user
          ),
          MessageModel(
            id: 'msg3_ai',
            text:
                'شكراً ❤️ هي بعض النصائح تساعد على نوم أعمق:\n• حاولي، تعملي روتين نوم ثابت (حمام دافئ، تهدئة الغرفة، تهدئة).\n• خلي وقت القيلولة لا يتجاوز الـ3 ساعات.\n• لا ترضعيه لينام حتى في آخر رضعة قبل النوم بـ20 دقيقة.\n• إذا صحي، لا تحمليه فوراً، جربي تطبطبي عليه وهو بسريره.',
            senderType: SenderType.aiMama,
            senderId: 'ai_mama_id',
            timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
            avatarAssetPath: 'assets/images/Ai_Mama.svg',
          ),
        ];
        return Right(mockMessages);
      } else if (conversationId == "chat1") {
        // Example doctor chat
        final List<MessageModel> mockMessages = [
          MessageModel(
            id: 'msg1_doc_chat1',
            text: 'مرحباً، كيف حال طفلك اليوم؟',
            senderType: SenderType.otherParty,
            senderId: 'doc1', // Matches active doctor ID
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            avatarInitial: 'أ', // Matches active doctor placeholder
          ),
          MessageModel(
            id: 'msg2_user_chat1',
            text: 'الحمد لله، لكن ما زال يعاني من بعض المغص.',
            senderType: SenderType.me,
            senderId: currentUserId,
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
            avatarInitial: 'م', // Placeholder for user
          ),
        ];
        return Right(mockMessages);
      } else if (conversationId == "chat2") {
        // Example other doctor chat
        return const Right(<MessageModel>[]); // Start with empty chat
      }
      // Add other conversation IDs if needed, like for the doctor_conv_doc1, etc.
      // This part needs careful handling if you want dynamic conversation creation
      // For simplicity, new doctor chats might start empty or with a welcome message.
      else if (conversationId.startsWith("doctor_conv_")) {
        // For new chats initiated from active doctors list, return empty or a placeholder message
        // For example:
        // final doctorId = conversationId.replaceFirst("doctor_conv_", "");
        // return Right([
        //   MessageModel(
        //       id: 'welcome_${doctorId}',
        //       text: 'مرحباً! كيف يمكنني مساعدتك اليوم؟',
        //       senderType: SenderType.otherParty,
        //       senderId: doctorId,
        //       timestamp: DateTime.now(),
        //       avatarInitial: 'د' // Generic or fetch specific doctor initial
        //   )
        // ]);
        return const Right(<MessageModel>[]); // Default to empty for now
      }

      return const Left(Failure("Conversation not found", statusCode: 404));
    } catch (e) {
      return Left(
        Failure(
          "Critical error in repository getMessages: ${e.toString()}",
          statusCode: 500,
        ),
      );
    }
  }

  FutureEither<MessageModel> sendMessage(
    String conversationId,
    String text,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    const String currentUserId = "user123"; // Placeholder
    final MessageModel sentMessage = MessageModel(
      id: "msg-${DateTime.now().millisecondsSinceEpoch}",
      text: text,
      senderType: SenderType.me,
      senderId: currentUserId,
      timestamp: DateTime.now(),
      avatarInitial: 'م', // Placeholder for user
    );
    return Right(sentMessage);
  }
}
