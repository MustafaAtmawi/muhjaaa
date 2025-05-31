import 'package:muhjaaa/models/chat_preview_model.dart';
import 'package:muhjaaa/models/doctor_model.dart';
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
    return Right(mockDoctors);
  }

  FutureEither<List<MessageModel>> getMessages(String conversationId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      const String currentUserId = "user123";

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
            senderId: currentUserId,
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
            avatarAssetPath: 'assets/images/Ai_Mama.svg',
          ),
        ];
        return Right(mockMessages);
      } else if (conversationId == "chat1") {
        final List<MessageModel> mockMessages = [
          MessageModel(
            id: 'msg1_doc',
            text: 'مرحباً، كيف حال طفلك اليوم؟',
            senderType: SenderType.otherParty,
            senderId: 'doc_karim_id',
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
      } else if (conversationId == "chat2") {
        return const Right(<MessageModel>[]);
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
    const String currentUserId = "user123";
    final MessageModel sentMessage = MessageModel(
      id: "msg-${DateTime.now().millisecondsSinceEpoch}",
      text: text,
      senderType: SenderType.me,
      senderId: currentUserId,
      timestamp: DateTime.now(),
      avatarInitial: 'أ',
    );
    return Right(sentMessage);
  }
}
