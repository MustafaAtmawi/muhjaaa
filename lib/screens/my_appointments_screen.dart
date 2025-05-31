import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/app_drawer.dart';

// Data model for appointment item
class AppointmentInfo {
  // Kept local as it's only used here and not a core domain model yet
  final String doctorName;
  final String specialty;
  final String timeSlot;
  final String avatarAsset;
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _selectedFilter = "أخصائيين";
  int _bottomNavIndex =
      2; // Assuming "Home" (index 2) is where "My Appointments" might be accessed or is a default

  // Mock data for the list
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
                  : BorderSide(color: AppColors.unselectedButtonBorder),
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
      key: _scaffoldKey,
      backgroundColor: AppColors.screenBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leading: IconButton(
            // Back button or navigation icon
            icon: SvgPicture.asset(
              'assets/icons/Right.svg', // This is usually a "back" or "close" icon in LTR, so "forward" in RTL
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                AppColors.darkGreyText.withAlpha((0.7 * 255).round()),
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
          title: const Row(
            mainAxisAlignment:
                MainAxisAlignment.end, // Aligns title to the right for RTL
            children: [
              Text(
                "مواعيدي", // Corrected Title: "My Appointments"
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.darkGreyText,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          centerTitle: false, // Title is aligned via the Row
          actions: [
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: AppColors.darkGreyText,
                size: 28,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      endDrawer: AppDrawer(),
      body: Padding(
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
                  // Prefix will be on the left visually in RTL
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
              child: _appointments.isEmpty
                  ? const Center(
                      child: Text(
                        "لا يوجد مواعيد حالياً.",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          color: AppColors.lightGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
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
        padding: const EdgeInsets.only(
          bottom: 50.0,
        ), // Adjusted padding if bottom bar is tall
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
              'assets/images/Subscription_mama.svg', // Ensure this asset exists
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              placeholderBuilder: (context) => const Icon(
                Icons.person, // Fallback icon
                size: 30,
                color: AppColors.primaryRed,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // Keep as is for RTL consistency if FAB is on left
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(
              Icons.home_outlined,
            ), // This should be "الرئيسية" or "مواعيدي"
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

class _AppointmentItemCard extends StatelessWidget {
  final AppointmentInfo appointment;

  const _AppointmentItemCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: AppColors.cardBackground,
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          textDirection: TextDirection.rtl, // Ensures layout is RTL
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    // Assuming avatarAsset is a local asset path
                    appointment.avatarAsset,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.chipText, // Better placeholder color
                        borderRadius: BorderRadius.circular(8.0),
                      ),
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
                    top: 2, // Adjust position as needed
                    right: 2, // Adjust position as needed
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
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Aligns text to the right in RTL
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
                      color: AppColors.lightGrey, // Original color
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 3.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.chipBackground,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      // Displaying actual time slot
                      appointment.timeSlot,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.chipText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12), // Spacing before the delete button
            Container(
              width: 55,
              height: 30,
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
                  // TODO: Implement delete action for the appointment
                },
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(), // To make icon fill the container
              ),
            ),
          ],
        ),
      ),
    );
  }
}
