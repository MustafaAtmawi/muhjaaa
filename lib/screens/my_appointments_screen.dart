import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/utils/app_colors.dart'; // For SVG assets like the FAB icon
import 'package:muhjaaa/widgets/app_drawer.dart'; // Added import for AppDrawer

// Data model for appointment item (as you provided)
class AppointmentInfo {
  final String doctorName;
  final String specialty;
  final String timeSlot;
  final String avatarAsset; // Placeholder asset path
  final bool isOnline;

  AppointmentInfo({
    required this.doctorName,
    required this.specialty,
    required this.timeSlot,
    required this.avatarAsset,
    required this.isOnline,
  });
}

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  // Added ScaffoldKey to control the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _selectedFilter =
      "أخصائيين"; // Default selected filter (as you provided)
  int _bottomNavIndex = 2; // Assuming "Home" is the default (as you provided)

  // Mock data for the list (as you provided)
  final List<AppointmentInfo> _appointments = List.generate(
    3,
    (index) => AppointmentInfo(
      doctorName: 'د. سمر خليل',
      specialty: 'أخصائية تغذية',
      timeSlot: '10:20 AM - 12:30 PM',
      avatarAsset: 'assets/images/placeholder_doctor_female.png',
      isOnline: true,
    ),
  );

  // _buildFilterButton method (as you provided)
  Widget _buildFilterButton(String title) {
    final bool isSelected = _selectedFilter == title;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedFilter = title;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected
                ? AppColors.primaryRed
                : AppColors.white,
            foregroundColor: isSelected
                ? AppColors.white
                : AppColors.darkGreyText,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: isSelected
                  ? BorderSide.none
                  : BorderSide(
                      color:
                          AppColors.unselectedButtonBorder ??
                          Colors.grey.shade300, // Added null check for safety
                    ),
            ),
            elevation: isSelected ? 2 : 0,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the key to the Scaffold
      backgroundColor: AppColors.screenBackground,
      // AppBar copied from ChatListScreen.dart
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
                "المحادثات", // This title is from ChatListScreen's AppBar
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.darkGreyText,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: AppColors.darkGreyText,
                size: 28,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer(); // Open the drawer
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      endDrawer: AppDrawer(), // Added endDrawer for the AppBar's menu button
      body: Padding(
        // Body content (as you provided)
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'البحث...',
                hintStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.lightGrey,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.lightGrey,
                ),
                filled: true,
                fillColor: AppColors.searchBarBg,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                _buildFilterButton('أطباء'),
                _buildFilterButton('أخصائيين'),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _appointments.length,
                itemBuilder: (context, index) {
                  return _AppointmentItemCard(
                    appointment: _appointments[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        // FloatingActionButton (as you provided)
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          onPressed: () {
            // TODO: Action for AI Mama FAB
            // Navigator.pushNamed(context, '/ai_mama_chat');
          },
          backgroundColor: AppColors.white,
          elevation: 4,
          child: CircleAvatar(
            radius: 26,
            backgroundColor: Colors.transparent,
            child: SvgPicture.asset(
              'assets/images/Subscription_mama.svg',
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              placeholderBuilder: (context) => const Icon(
                Icons.person,
                size: 30,
                color: AppColors.primaryRed,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        // BottomNavigationBar (as you provided)
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
          // TODO: Handle bottom navigation tap
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "الملف الشخصي",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: "المتجر",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: "مقالات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps_outlined),
            label: "المزيد",
          ),
        ],
      ),
    );
  }
}

// _AppointmentItemCard class (as you provided, with minor color fix for errorBuilder)
class _AppointmentItemCard extends StatelessWidget {
  final AppointmentInfo appointment;

  const _AppointmentItemCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color:
          AppColors.cardBackground ??
          AppColors.white, // Added null check for safety
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    appointment.avatarAsset,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: AppColors
                          .chipText, // Changed from AppColors.chipText to AppColors.lightGrey for better placeholder
                      child: const Icon(
                        Icons.person,
                        color: AppColors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                if (appointment.isOnline)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.positiveGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.doctorName,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.darkGreyText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    appointment.specialty,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: AppColors.lightGrey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 3.0,
                    ),
                    decoration: BoxDecoration(
                      color:
                          AppColors.chipBackground ??
                          AppColors.primaryRed, // Added null check for safety
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      appointment.timeSlot,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color:
                            AppColors.chipText ??
                            AppColors.primaryRed, // Added null check for safety
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 55, // Kept your dimensions
              height: 30, // Kept your dimensions
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.white,
                  size: 22,
                ),
                onPressed: () {
                  // TODO: Implement delete action
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
