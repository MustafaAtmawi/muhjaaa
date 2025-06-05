import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/cubits/doctors/doctor_list_cubit.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/doctor_grid_card.dart';
import 'package:muhjaaa/widgets/app_drawer.dart'; // Assuming you might want a drawer

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      // Basic debounce could be added here if searching on every keystroke
      // For now, search on submit or explicit action
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildFilterButton(
    BuildContext context,
    String title,
    ProviderListFilter filterValue,
    ProviderListFilter currentFilter,
  ) {
    final bool isSelected = currentFilter == filterValue;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () {
            FocusScope.of(context).unfocus(); // Dismiss keyboard
            context.read<DoctorListCubit>().applyFilter(filterValue);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected
                ? AppColors.primaryRed
                : AppColors.white,
            foregroundColor: isSelected ? Colors.white : AppColors.darkGreyText,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: isSelected
                  ? BorderSide.none
                  : const BorderSide(color: AppColors.unselectedButtonBorder),
            ),
            elevation: isSelected ? 2 : 0,
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
            ), // Adjusted padding
          ),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13, // Adjusted font size
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // It's often better to provide Cubits higher up if they need to persist
    // or be accessed by multiple sibling routes. For a dedicated screen, this is fine.
    return BlocProvider(
      create: (context) => DoctorListCubit(), // Provide DoctorListCubit
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.screenBackground,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/Right.svg', // Or a more appropriate icon like close/back if this screen is pushed
              width: 20, // Adjusted size
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.darkGreyText70,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
          title: const Text(
            "               قائمة الأطباء والأخصائيين",
            style: TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.darkGreyText,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ), // Adjusted font size
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
        endDrawer: AppDrawer(), // Optional: if you want the standard drawer
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: TextField(
                controller: _searchController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'البحث عن طبيب أو أخصائي...',
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
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (query) {
                  context.read<DoctorListCubit>().searchProviders(query);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: BlocBuilder<DoctorListCubit, DoctorListState>(
                // For filter buttons
                builder: (context, state) {
                  ProviderListFilter currentFilter =
                      ProviderListFilter.specialists; // Default
                  if (state is DoctorListLoaded) {
                    currentFilter = state.selectedFilter;
                  }
                  return Row(
                    children: [
                      _buildFilterButton(
                        context,
                        'أطباء',
                        ProviderListFilter.doctors,
                        currentFilter,
                      ),
                      _buildFilterButton(
                        context,
                        'أخصائيين',
                        ProviderListFilter.specialists,
                        currentFilter,
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<DoctorListCubit, DoctorListState>(
                builder: (context, state) {
                  if (state is DoctorListLoading ||
                      state is DoctorListInitial) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryRed,
                      ),
                    );
                  } else if (state is DoctorListLoaded) {
                    if (state.providers.isEmpty) {
                      return Center(
                        child: Text(
                          state.searchQuery.isNotEmpty
                              ? "لا توجد نتائج لبحثك."
                              : "لا يوجد مقدموا خدمة متاحون حالياً.",
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            color: AppColors.lightGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.all(
                        12.0,
                      ), // Padding around the grid
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns
                            crossAxisSpacing:
                                8.0, // Horizontal space between cards
                            mainAxisSpacing:
                                8.0, // Vertical space between cards
                            childAspectRatio:
                                0.75, // Adjust for card height to width ratio
                          ),
                      itemCount: state.providers.length,
                      itemBuilder: (context, index) {
                        final doctor = state.providers[index];
                        return DoctorGridCard(
                          doctor: doctor,
                          onBookAppointment: () {
                            // TODO: Implement navigation to booking screen for 'doctor'
                            print('Book appointment for ${doctor.name}');
                          },
                          onSendMessage: () {
                            // TODO: Implement navigation to chat screen with 'doctor'
                            print('Send message to ${doctor.name}');
                          },
                        );
                      },
                    );
                  } else if (state is DoctorListError) {
                    return Center(
                      child: Text(
                        "حدث خطأ: ${state.message}",
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.red,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        // You might want a FAB here if there's a primary action for this screen
        // floatingActionButton: FloatingActionButton(...)
      ),
    );
  }
}
