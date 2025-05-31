import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muhjaaa/cubits/chat/chat_list_cubit.dart';
import 'package:muhjaaa/cubits/chat/conversation_cubit.dart';
import 'package:muhjaaa/models/chat_preview_model.dart';
import 'package:muhjaaa/models/doctor_model.dart';
import 'package:muhjaaa/repositories/chat_repository.dart';
import 'package:muhjaaa/screens/conversation_screen.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/active_doctor_avatar.dart';
import 'package:muhjaaa/widgets/chat_list_item.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  int _bottomNavIndex = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        print("ChatListScreen initState: Calling fetchChatListData");
        context.read<ChatListCubit>().fetchChatListData();
      }
    });
  }

  void _navigateToDoctorChat(
    BuildContext context,
    ChatPreviewModel chatPreview,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<ConversationCubit>(
          create: (blocContext) => ConversationCubit(
            chatRepository: blocContext.read<ChatRepository>(),
            conversationId: chatPreview.id,
          )..fetchMessages(),
          child: ConversationScreen(
            doctorName: chatPreview.senderName,
            conversationId: chatPreview.id,
            doctorPlaceholder: chatPreview.placeholderLetter,
            doctorAvatarUrl: chatPreview.avatarUrl,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("ChatListScreen: Build method called");
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                const Text(
                  "المحادثات",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.darkGreyText,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
      body: BlocConsumer<ChatListCubit, ChatListState>(
        listener: (context, state) {
          print(
            "ChatListScreen Listener: Received state - ${state.runtimeType}",
          );
          if (state is ChatListFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, textAlign: TextAlign.right),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          print(
            "ChatListScreen Builder: Building for state - ${state.runtimeType}",
          );

          if (state is ChatListLoading || state is ChatListInitial) {
            print("ChatListScreen Builder: Showing Loading UI");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryRed,
                      ),
                      strokeWidth: 3.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "جاري تحميل المحادثات...",
                    style: TextStyle(
                      color: AppColors.darkGreyText,
                      fontFamily: 'Cairo',
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (state is ChatListLoaded) {
            print(
              "ChatListScreen Builder: Showing Loaded UI with ${state.chatPreviews.length} previews, ${state.activeDoctors.length} doctors",
            );
            final List<DoctorModel> activeDoctors = state.activeDoctors;
            final List<ChatPreviewModel> chatMessages = state.chatPreviews;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: TextField(
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: AppColors.darkGreyText,
                    ),
                    decoration: InputDecoration(
                      hintText: "...البحث",
                      hintStyle: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.lightGrey,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.lightGrey,
                        size: 22,
                      ),
                      filled: true,
                      fillColor: AppColors.searchBarBg,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                if (activeDoctors.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.only(
                      right: 16.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: Text(
                      "نشط الآن",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreyText,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: activeDoctors.length,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      reverse: true,
                      itemBuilder: (context, index) {
                        final doctor = activeDoctors[index];
                        return ActiveDoctorAvatar(
                          placeholderLetter: doctor.placeholderLetter,
                          onTap: () {
                            final String doctorConversationId =
                                "doctor_conv_${doctor.id}";
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider<ConversationCubit>(
                                  create: (blocContext) => ConversationCubit(
                                    chatRepository: blocContext
                                        .read<ChatRepository>(),
                                    conversationId: doctorConversationId,
                                  )..fetchMessages(),
                                  child: ConversationScreen(
                                    doctorName: doctor.name,
                                    conversationId: doctorConversationId,
                                    doctorPlaceholder: doctor.placeholderLetter,
                                    doctorAvatarUrl: doctor.avatarUrl,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
                const Padding(
                  padding: EdgeInsets.only(right: 16.0, top: 16.0, bottom: 8.0),
                  child: Text(
                    "الرسائل",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreyText,
                    ),
                  ),
                ),
                Expanded(
                  child: chatMessages.isEmpty
                      ? const Center(
                          child: Text(
                            "لا توجد محادثات حتى الآن.",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              color: AppColors.lightGrey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: chatMessages.length,
                          itemBuilder: (context, index) {
                            final msgPreview = chatMessages[index];
                            return ChatListItem(
                              senderName: msgPreview.senderName,
                              senderRole: msgPreview.senderRole,
                              lastMessage: msgPreview.lastMessage,
                              timestamp: msgPreview.timestamp,
                              unreadCount: msgPreview.unreadCount,
                              placeholderLetter: msgPreview.placeholderLetter,
                              onTap: () =>
                                  _navigateToDoctorChat(context, msgPreview),
                            );
                          },
                        ),
                ),
              ],
            );
          } else if (state is ChatListFailure) {
            print(
              "ChatListScreen Builder: Showing Failure UI - ${state.message}",
            );
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "حدث خطأ في تحميل البيانات:\n${state.message}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          } else {
            print(
              "ChatListScreen Builder: Showing Unknown State UI for state - ${state.runtimeType}",
            );
            return const Center(
              child: Text(
                "حالة غير معروفة أو واجهة غير محددة لهذه الحالة.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.lightGrey,
                  fontSize: 16,
                ),
              ),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/ai_mama_chat');
          },
          backgroundColor: AppColors
              .primaryRed, // Changed from transparent to see the button
          elevation: 4, // Added some elevation
          // child: Image.asset(
          //   'assets/images/AI_mama.png', // This was causing the error
          //   width: 60,
          //   height: 60,
          //   fit: BoxFit.contain,
          // ),
          child: const Icon(
            Icons.chat_bubble_outline,
            color: Colors.white,
            size: 30,
          ), // Placeholder Icon
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          if (index == 2) {
            if (_bottomNavIndex != index) {
              setState(() {
                _bottomNavIndex = index;
              });
            }
            return;
          }
          setState(() {
            _bottomNavIndex = index;
          });
          String screenName = "";
          switch (index) {
            case 0:
              screenName = "الملف الشخصي (Profile)";
              break;
            case 1:
              screenName = "المتجر (Store)";
              break;
            case 3:
              screenName = "مقالات (Articles)";
              break;
            case 4:
              screenName = "المزيد (More)";
              break;
          }
          if (screenName.isNotEmpty) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "تم تحديد $screenName. سيتم تنفيذ الانتقال لهذه الشاشة لاحقاً.",
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
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
