import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/cubits/auth/auth_cubit.dart';
import 'package:muhjaaa/utils/app_colors.dart';

// Placeholder for child profile data model
class _ChildProfile {
  final String id;
  final String name;
  final String? avatarUrl;
  final String placeholderInitial;

  _ChildProfile({
    // Removed const as it's not used with a const list currently
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.placeholderInitial,
  });
}

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final List<_ChildProfile> _childProfiles = [
    _ChildProfile(id: '1', name: 'خالد', placeholderInitial: 'خ'),
    _ChildProfile(id: '2', name: 'أحمد', placeholderInitial: 'أ'),
  ];

  Widget _buildChildProfileAvatar(_ChildProfile profile, BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Implement child profile selection logic
        Navigator.pop(context);
        // Example: context.read<ChildManagementCubit>().selectChild(profile.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color.fromRGBO(
                157,
                189,
                187,
                0.5,
              ), // AppColors.lightGrey with 0.5 opacity
              // In a real app, you'd load the avatarUrl if available:
              // backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
              child: profile.avatarUrl == null
                  ? Text(
                      profile.placeholderInitial,
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              profile.name,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.darkGreyText,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color iconColor = AppColors.darkGreyText;

    return Drawer(
      backgroundColor: AppColors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              top: 40.0, // Adjust top padding considering status bar
              bottom: 20.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse:
                        true, // To have items flow from right to left and scroll starts from right
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
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    // TODO: Implement "add child" logic
                    Navigator.pop(context);
                    // Example: Navigator.pushNamed(context, '/add_child');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Add child action placeholder",
                          textAlign: TextAlign.right,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(
                        157,
                        189,
                        187,
                        0.2,
                      ), // AppColors.lightGrey with 0.2 opacity
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: AppColors.primaryRed,
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
            color: Color.fromRGBO(
              157,
              189,
              187,
              0.5,
            ), // Consistent light grey for divider
          ),
          _buildDrawerItem(
            context: context,
            iconAsset: 'assets/icons/Person.svg', // Ensure asset exists
            text: 'حسابي',
            iconColor: iconColor,
            onTap: () {
              Navigator.pop(context);
              // Navigator.pushNamed(context, '/my_account'); // Assuming you have this route
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Navigate to My Account (Placeholder)",
                    textAlign: TextAlign.right,
                  ),
                ),
              );
            },
          ),
          _buildDrawerItem(
            context: context,
            iconData: Icons.history_outlined,
            text: 'سجل نشاطاتي',
            iconColor: iconColor,
            onTap: () {
              Navigator.pop(context);
              // Navigator.pushNamed(context, '/activity_log');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Navigate to Activity Log (Placeholder)",
                    textAlign: TextAlign.right,
                  ),
                ),
              );
            },
          ),
          _buildDrawerItem(
            context: context,
            iconData: Icons.settings_outlined,
            text: 'الإعدادات',
            iconColor: iconColor,
            onTap: () {
              Navigator.pop(context);
              // Navigator.pushNamed(context, '/settings');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Navigate to Settings (Placeholder)",
                    textAlign: TextAlign.right,
                  ),
                ),
              );
            },
          ),
          _buildDrawerItem(
            context: context,
            iconData: Icons.people_alt_outlined,
            text: 'أطفالي',
            iconColor: iconColor,
            onTap: () {
              Navigator.pop(context);
              // Navigator.pushNamed(context, '/my_children');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Navigate to My Children (Placeholder)",
                    textAlign: TextAlign.right,
                  ),
                ),
              );
            },
          ),
          _buildDrawerItem(
            // Example for Subscription Screen
            context: context,
            iconData: Icons.card_membership,
            text: 'الاشتراك',
            iconColor: iconColor,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/subscription');
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.logout,
                color: AppColors.white,
                textDirection: TextDirection
                    .rtl, // Ensures icon is on the right of text for RTL
              ),
              label: const Text(
                'تسجيل الخروج',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              onPressed: () {
                // Close drawer first
                Navigator.pop(context);
                // Dispatch logout event
                context.read<AuthCubit>().logout();
                // Navigate to login screen and remove all previous routes
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamedAndRemoveUntil(
                  '/login', // Ensure '/login' route is defined in main.dart
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext
    context, // Added context for navigation/snackbar if needed from item
    String? iconAsset,
    IconData? iconData,
    required String text,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: const Icon(
        // Chevron on the left for RTL
        Icons.chevron_left,
        color: AppColors.lightGrey,
        size: 22,
      ),
      title: Align(
        alignment: AlignmentDirectional
            .centerStart, // Text starts after potential icon
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: 'Cairo',
            color: AppColors.darkGreyText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      trailing:
          iconAsset !=
              null // Icon on the right for RTL
          ? SvgPicture.asset(
              iconAsset,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            )
          : Icon(iconData, color: iconColor, size: 24),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 4.0, // Reduced vertical padding for a denser list
      ),
    );
  }
}
