import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/cubits/appointment/appointments_cubit.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/app_drawer.dart';
import 'package:muhjaaa/widgets/appointment_item_card.dart'; // New import

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _bottomNavIndex = 2; // Local UI state for bottom navigation

  // Removed local _selectedFilter and _appointments

  Widget _buildFilterButton(
    BuildContext context, // Added context to access Cubit
    String title,
    AppointmentFilter filterValue,
    AppointmentFilter currentFilter,
  ) {
    final bool isSelected = currentFilter == filterValue;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () {
            context.read<AppointmentsCubit>().selectFilter(filterValue);
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
                  : const BorderSide(color: AppColors.unselectedButtonBorder),
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
    return BlocProvider(
      create: (context) => AppointmentsCubit(), // Provide the Cubit here
      child: Scaffold(
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
              icon: SvgPicture.asset(
                'assets/icons/Right.svg', // Ensure asset exists
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  AppColors.darkGreyText70, // Using AppColors.darkGreyText70
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                // else { TODO: Handle no pop action, maybe open drawer or other default }
              },
            ),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "مواعيدي",
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
                onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        endDrawer: AppDrawer(),
        body: BlocBuilder<AppointmentsCubit, AppointmentsState>(
          builder: (context, state) {
            return Padding(
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
                    onChanged: (query) {
                      // TODO: Implement search logic, potentially by calling cubit method
                    },
                  ),
                  const SizedBox(height: 20.0),
                  if (state
                      is AppointmentsLoaded) // Show filters only when data is loaded
                    Row(
                      children: [
                        _buildFilterButton(
                          context,
                          'أطباء',
                          AppointmentFilter.doctors,
                          state.selectedFilter,
                        ),
                        _buildFilterButton(
                          context,
                          'أخصائيين',
                          AppointmentFilter.specialists,
                          state.selectedFilter,
                        ),
                      ],
                    ),
                  const SizedBox(height: 20.0),
                  Expanded(child: _buildAppointmentsList(state)),
                ],
              ),
            );
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/ai_mama_chat');
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
          currentIndex: _bottomNavIndex,
          onTap: (index) {
            setState(() => _bottomNavIndex = index);
            // TODO: Handle bottom navigation tap - navigate to other screens
            // Example:
            // if (index == 0) Navigator.pushNamed(context, '/profile');
            // else if (index == 1) Navigator.pushNamed(context, '/store');
            // ...
            if (index != 2) {
              // Index 2 is current screen (Home/Appointments)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Navigation to other tabs (index $index) placeholder",
                    textAlign: TextAlign.right,
                  ),
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
      ),
    );
  }

  Widget _buildAppointmentsList(AppointmentsState state) {
    if (state is AppointmentsLoading || state is AppointmentsInitial) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryRed),
      );
    } else if (state is AppointmentsLoaded) {
      if (state.appointments.isEmpty) {
        return const Center(
          child: Text(
            "لا يوجد مواعيد حالياً.",
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              color: AppColors.lightGrey,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }
      return ListView.builder(
        itemCount: state.appointments.length,
        itemBuilder: (context, index) {
          final appointment = state.appointments[index];
          return AppointmentItemCard(
            appointment: appointment,
            onDelete: () {
              // Show confirmation dialog before deleting
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text(
                      "تأكيد الحذف",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                    content: const Text(
                      "هل أنت متأكد أنك تريد حذف هذا الموعد؟",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                    actionsAlignment: MainAxisAlignment.spaceBetween,
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          "إلغاء",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.darkGreyText,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                      TextButton(
                        child: const Text(
                          "حذف",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.primaryRed,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          context.read<AppointmentsCubit>().deleteAppointment(
                            appointment.id,
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      );
    } else if (state is AppointmentsError) {
      return Center(
        child: Text(
          "خطأ: ${state.message}",
          style: const TextStyle(
            fontFamily: 'Cairo',
            color: Colors.red,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    return const SizedBox.shrink(); // Default empty state
  }
}
