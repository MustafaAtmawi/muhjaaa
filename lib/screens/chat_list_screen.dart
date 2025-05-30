import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/active_doctor_avatar.dart';
import 'package:muhjaaa/widgets/chat_list_item.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  int _bottomNavIndex = 0;

  static const List<Map<String, String>> _activeDoctors = [
    {'name': 'د. أحمد', 'placeholder': 'أ'},
    {'name': 'د. فاطمة', 'placeholder': 'ف'},
    {'name': 'د. يوسف', 'placeholder': 'ي'},
    {'name': 'د. سارة', 'placeholder': 'س'},
    {'name': 'د. عمر', 'placeholder': 'ع'},
  ];

  static const List<Map<String, dynamic>> _chatMessages = [
    {
      'name': 'د. كريم',
      'role': 'طبيب أطفال',
      'message':
          'جربي تتبعي روتين النوم يومياً، ورح تلاحظي الفرق بسرعة ان شاء الله.',
      'time': '9:30 PM',
      'unread': 1,
      'placeholder': 'ك',
    },
    {
      'name': 'د. علياء',
      'role': 'اخصائية تغذية',
      'message': 'بالتأكيد، يمكننا وضع خطة تغذية مناسبة لطفلك، متى يناسبك؟',
      'time': '8:15 PM',
      'unread': 0,
      'placeholder': 'ع',
    },
    {
      'name': 'د. سامي',
      'role': 'طبيب عام',
      'message': 'لا تقلقي، هذه الأعراض طبيعية جداً في هذه المرحلة.',
      'time': 'أمس',
      'unread': 2,
      'placeholder': 'س',
    },
    {
      'name': 'مجموعة الأمهات',
      'role': 'دعم ومساندة',
      'message': 'مرحباً بك في مجموعتنا! شاركينا استفساراتك.',
      'time': 'الاثنين',
      'unread': 0,
      'placeholder': 'م',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // itemExtent has been removed as it seemed to negatively impact performance in this case.
    // This might be due to estimated values not being perfectly accurate,
    // or items not being as uniform in size as assumed.

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
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.darkGreyText,
                    size: 22,
                  ),
                  onPressed: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                ),
                const Text(
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
          ),
        ),
      ),
      body: Column(
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
          const Padding(
            padding: EdgeInsets.only(right: 16.0, top: 10.0, bottom: 10.0),
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
              itemCount: _activeDoctors.length,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              reverse: true,
              // itemExtent removed
              itemBuilder: (context, index) {
                final doctor = _activeDoctors[index];
                return ActiveDoctorAvatar(
                  placeholderLetter: doctor['placeholder']!,
                  onTap: () => print("Tapped on ${doctor['name']}"),
                );
              },
            ),
          ),
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _chatMessages.length,
              // itemExtent removed
              itemBuilder: (context, index) {
                final msg = _chatMessages[index];
                return ChatListItem(
                  senderName: msg['name'],
                  senderRole: msg['role'],
                  lastMessage: msg['message'],
                  timestamp: msg['time'],
                  unreadCount: msg['unread'],
                  placeholderLetter: msg['placeholder'],
                  onTap: () => print("Tapped on chat with ${msg['name']}"),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          onPressed: () {
            print("Mama Muhja FAB tapped");
            // If you still want to test the Icon version for performance:
            // Temporarily use this:
            // child: const Icon(Icons.chat, color: AppColors.primaryRed, size: 30),
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Image.asset(
            'assets/images/AI_mama.png',
            width: 60,
            height: 60,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
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
