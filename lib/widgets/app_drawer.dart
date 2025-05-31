import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart'; // If you use SVGs for icons
import 'package:muhjaaa/cubits/auth/auth_cubit.dart'; // Assuming you have logout here
import 'package:muhjaaa/utils/app_colors.dart'; // Your app colors

// Placeholder for child profile data model
class _ChildProfile {
  final String id;
  final String name;
  final String? avatarUrl; // Could be a local asset path or network URL
  final String placeholderInitial;

  _ChildProfile({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.placeholderInitial,
  });
}

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  // Mock data for child profiles - replace with data from your Cubit/State
  // Current mock data: Khaled, then Ahmed.
  // With SingleChildScrollView(reverse: true), this will display as Ahmed (right-most of profiles), Khaled (to his left).
  final List<_ChildProfile> _childProfiles = [
    _ChildProfile(
      id: '1',
      name: 'خالد',
      placeholderInitial: 'خ',
    ), // Placeholder, use actual images if available
    _ChildProfile(id: '2', name: 'أحمد', placeholderInitial: 'أ'), //
  ];

  Widget _buildChildProfileAvatar(_ChildProfile profile, BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Implement child switching logic
        print("Selected child: ${profile.name}");
        Navigator.pop(context); // Close drawer after selection
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 28, //
              backgroundColor: AppColors.lightGrey.withOpacity(0.5), //
              child:
                  profile.avatarUrl ==
                      null // Placeholder if no image
                  ? Text(
                      profile.placeholderInitial,
                      style: const TextStyle(
                        fontSize: 20, //
                        color: AppColors.primaryRed, //
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              profile.name,
              style: const TextStyle(
                fontSize: 13, //
                color: AppColors.darkGreyText, //
                fontFamily: 'Cairo', //
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color iconColor = AppColors.darkGreyText; //

    return Drawer(
      backgroundColor: AppColors.white, //
      child: ListView(
        padding: EdgeInsets.zero, //
        children: <Widget>[
          // Profile Switcher Header
          Container(
            padding: const EdgeInsets.only(
              top: 40.0, //
              bottom: 20.0, //
              left: 16.0, //
              right: 16.0, //
            ),
            child: Row(
              // Children arranged to have profiles on the visual right, add button on the visual left for RTL.
              children: [
                // Existing Child Profiles (scrollable horizontally)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, //
                    reverse:
                        true, // This makes items from _childProfiles list appear from right to left
                    // and scrolling will reveal items towards the conceptual start of the list (left).
                    // For [Khaled, Ahmed], it shows Ahmed then Khaled (RTL), scrolling reveals Khaled first.
                    child: Row(
                      children: _childProfiles
                          .map(
                            (profile) =>
                                _buildChildProfileAvatar(profile, context),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 10), //
                // Add Child Button (appears on the visual left in RTL)
                InkWell(
                  onTap: () {
                    // TODO: Implement add child profile action
                    print("Add child tapped");
                    Navigator.pop(context); //
                    // Example: Navigator.pushNamed(context, '/add_child');
                  },
                  child: Container(
                    width: 56, //
                    height: 56, //
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey.withOpacity(0.2), //
                      borderRadius: BorderRadius.circular(12), // Rounded square
                    ),
                    child: const Icon(
                      Icons.add, //
                      size: 30, //
                      color: AppColors.primaryRed, //
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
          ), //
          // Navigation Menu Items
          _buildDrawerItem(
            iconAsset: 'assets/icons/Person.svg', //
            text: 'حسابي', //
            iconColor: iconColor,
            onTap: () {
              Navigator.pop(context); // Close drawer
              // TODO: Define '/my_account' route and screen
              Navigator.pushNamed(context, '/my_account');
              print("حسابي tapped - Navigating to /my_account");
            },
          ),
          _buildDrawerItem(
            iconData: Icons.history_outlined, //
            text: 'سجل نشاطاتي', //
            iconColor: iconColor,
            onTap: () {
              Navigator.pop(context); // Close drawer
              // TODO: Define '/activity_log' route and screen
              Navigator.pushNamed(context, '/activity_log');
              print("سجل نشاطاتي tapped - Navigating to /activity_log");
            },
          ),
          _buildDrawerItem(
            iconData: Icons.settings_outlined, //
            text: 'الإعدادات', //
            iconColor: iconColor,
            onTap: () {
              Navigator.pop(context); // Close drawer
              // TODO: Define '/settings' route and screen
              Navigator.pushNamed(context, '/settings');
              print("الإعدادات tapped - Navigating to /settings");
            },
          ),
          _buildDrawerItem(
            iconData: Icons.people_alt_outlined, //
            text: 'أطفالي', //
            iconColor: iconColor,
            onTap: () {
              Navigator.pop(context); // Close drawer
              // TODO: Define '/my_children' route and screen
              Navigator.pushNamed(context, '/my_children');
              print("أطفالي tapped - Navigating to /my_children");
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20.0), //
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.logout, //
                color: AppColors.white, //
                textDirection: TextDirection.rtl, //
              ),
              label: const Text(
                'تسجيل الخروج', //
                style: TextStyle(
                  fontSize: 16, //
                  fontFamily: 'Cairo', //
                  fontWeight: FontWeight.bold, //
                  color: AppColors.white, //
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Close drawer first
                context.read<AuthCubit>().logout(); //
                // Navigate to login screen and remove all previous routes
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (Route<dynamic> route) => false,
                );
                print("Logout tapped - Navigating to /login");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed, //
                minimumSize: const Size(double.infinity, 50), //
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), //
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    String? iconAsset,
    IconData? iconData,
    required String text,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: const Icon(
        Icons.chevron_left, //
        color: AppColors.lightGrey, //
        size: 22, //
      ), // Arrow on the left
      title: Align(
        alignment: AlignmentDirectional
            .centerStart, // Text aligns to the start (right in RTL)
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15, //
            fontFamily: 'Cairo', //
            color: AppColors.darkGreyText, //
            fontWeight: FontWeight.w500, //
          ),
        ),
      ),
      trailing: iconAsset != null
          ? SvgPicture.asset(
              iconAsset, //
              width: 24, //
              height: 24, //
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn), //
            )
          : Icon(iconData, color: iconColor, size: 24), //
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24.0, //
        vertical: 4.0, //
      ),
    );
  }
}
