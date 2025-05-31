import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg
import 'package:muhjaaa/cubits/chat/chat_list_cubit.dart';
import 'package:muhjaaa/cubits/chat/conversation_cubit.dart';
import 'package:muhjaaa/models/chat_preview_model.dart';
import 'package:muhjaaa/models/doctor_model.dart';
import 'package:muhjaaa/repositories/chat_repository.dart';
import 'package:muhjaaa/screens/conversation_screen.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/active_doctor_avatar.dart';
import 'package:muhjaaa/widgets/chat_list_item.dart';
import 'package:muhjaaa/widgets/app_drawer.dart'; // Import the AppDrawer

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  int _bottomNavIndex = 2; // Default to Home/ChatList
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Add a ScaffoldKey

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
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
    return Scaffold(
      key: _scaffoldKey, // Assign the key to the Scaffold
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/Right.svg',
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                AppColors.darkGreyText.withOpacity(0.7),
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              // TODO: Implement action for right arrow (e.g., context.pop() if it's not a main screen)
              print("AppBar leading (Right.svg) icon pressed");
            },
          ),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "المحادثات",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.darkGreyText,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          centerTitle:
              false, // Title is aligned to the end (right in RTL) due to Row properties
          actions: [
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: AppColors.darkGreyText,
                size: 28,
              ),
              onPressed: () {
                _scaffoldKey.currentState
                    ?.openEndDrawer(); // Open the drawer from the right
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      endDrawer:
          AppDrawer(), // Set AppDrawer to endDrawer to appear from the right
      body: BlocConsumer<ChatListCubit, ChatListState>(
        listener: (context, state) {
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
          if (state is ChatListLoading || state is ChatListInitial) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryRed,
                      ),
                      strokeWidth: 3.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
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
            final List<DoctorModel> activeDoctors = state.activeDoctors;
            final List<ChatPreviewModel> chatMessages = state.chatPreviews;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
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
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Icon(
                          Icons.search,
                          color: AppColors.lightGrey,
                          size: 22,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.searchBarBg,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                if (activeDoctors.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.only(
                      right: 16.0,
                      left: 16.0,
                      top: 8.0,
                      bottom: 12.0,
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
                    height:
                        85, // Consider if this needs to be dynamic or check constraints
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: activeDoctors.length,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      reverse: true,
                      itemBuilder: (context, index) {
                        final doctor = activeDoctors[index];
                        return ActiveDoctorAvatar(
                          name: doctor.name,
                          avatarUrl: doctor.avatarUrl,
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
                  padding: EdgeInsets.only(
                    right: 16.0,
                    left: 16.0,
                    top: 20.0,
                    bottom: 8.0,
                  ),
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
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
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
                              avatarUrl: msgPreview.avatarUrl,
                              onTap: () =>
                                  _navigateToDoctorChat(context, msgPreview),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                        ),
                ),
              ],
            );
          } else if (state is ChatListFailure) {
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
        padding: const EdgeInsets.only(bottom: 70.0, left: 16.0),
        child: SizedBox(
          width: 65,
          height: 65,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/ai_mama_chat');
            },
            backgroundColor: Colors.white,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: ClipOval(
                child: SvgPicture.asset(
                  'assets/images/Subscription_mama.svg',
                  fit: BoxFit.cover,
                  width: 61,
                  height: 61,
                  placeholderBuilder: (BuildContext context) => const Icon(
                    Icons.support_agent,
                    color: AppColors.primaryRed,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          if (index == 2) {
            if (_bottomNavIndex != index) {
              // context.read<ChatListCubit>().fetchChatListData(); // Optionally refresh
            }
            setState(() {
              _bottomNavIndex = index;
            });
            return;
          }
          setState(() {
            _bottomNavIndex = index;
          });
          String screenName = "";
          switch (index) {
            case 0:
              screenName = "الملف الشخصي (Profile)";
              // Navigator.pushNamed(context, '/my_account'); // Example navigation
              break;
            case 1:
              screenName = "المتجر (Store)";
              // Navigator.pushNamed(context, '/store'); // Example navigation
              break;
            case 3:
              screenName = "مقالات (Articles)";
              // Navigator.pushNamed(context, '/articles'); // Example navigation
              break;
            case 4:
              screenName = "المزيد (More)";
              // Navigator.pushNamed(context, '/more'); // Example navigation
              break;
          }
          if (screenName.isNotEmpty) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "التنقل إلى $screenName غير مبرمج بعد.",
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
        unselectedItemColor: AppColors.darkGreyText,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 10,
        ),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Person.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _bottomNavIndex == 0
                    ? AppColors.primaryRed
                    : AppColors.darkGreyText,
                BlendMode.srcIn,
              ),
            ),
            label: "الملف الشخصي",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: _bottomNavIndex == 1
                  ? AppColors.primaryRed
                  : AppColors.darkGreyText,
            ),
            label: "المتجر",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons
                  .home_outlined, // Consider Icons.chat_bubble_outline if this is purely for chats
              color: _bottomNavIndex == 2
                  ? AppColors.primaryRed
                  : AppColors.darkGreyText,
            ),
            label: "الرئيسية", // Or "المحادثات" if more appropriate
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_book_outlined,
              color: _bottomNavIndex == 3
                  ? AppColors.primaryRed
                  : AppColors.darkGreyText,
            ),
            label: "مقالات",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.apps_outlined,
              color: _bottomNavIndex == 4
                  ? AppColors.primaryRed
                  : AppColors.darkGreyText,
            ),
            label: "المزيد",
          ),
        ],
      ),
    );
  }
}
