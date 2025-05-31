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
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.placeholderInitial,
  });
}

// ... (imports)
class AppDrawer extends StatelessWidget {
  AppDrawer({super.key}); // Can be const if _childProfiles is const

  // If _childProfiles were const and _ChildProfile had a const constructor
  // final List<_ChildProfile> _childProfiles = const [
  //   _ChildProfile(id: '1', name: 'خالد', placeholderInitial: 'خ'),
  //   _ChildProfile(id: '2', name: 'أحمد', placeholderInitial: 'أ'),
  // ];
  // For now, keeping it non-const as _ChildProfile constructor isn't const by default.

  final List<_ChildProfile> _childProfiles = [
    _ChildProfile(id: '1', name: 'خالد', placeholderInitial: 'خ'),
    _ChildProfile(id: '2', name: 'أحمد', placeholderInitial: 'أ'),
  ];

  Widget _buildChildProfileAvatar(_ChildProfile profile, BuildContext context) {
    // ... (logic for avatar)
    // Example of const inside:
    // const SizedBox(height: 4),
    // Text(profile.name, style: const TextStyle(...))
    // This method itself cannot be const if it depends on non-const `profile` members or context.
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.lightGrey.withAlpha(
                127,
              ), // Cannot be const if withAlpha is used directly
              child: profile.avatarUrl == null
                  ? Text(
                      profile.placeholderInitial,
                      style: const TextStyle(
                        // Made const
                        fontSize: 20,
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null, // Placeholder for actual image widget
            ),
            const SizedBox(height: 4), // Made const
            Text(
              profile.name,
              style: const TextStyle(
                // Made const
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
        padding: EdgeInsets.zero, // Made const
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              // Made const
              top: 40.0,
              bottom: 20.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
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
                const SizedBox(width: 10), // Made const
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey.withAlpha(
                        51,
                      ), // Cannot be const if withAlpha is used
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      // Made const
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
            // Made const
            height: 1,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
          ),
          _buildDrawerItem(
            iconAsset: 'assets/icons/Person.svg',
            text: 'حسابي',
            iconColor: iconColor,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/my_account');
            },
          ),
          _buildDrawerItem(
            iconData: Icons.history_outlined,
            text: 'سجل نشاطاتي',
            iconColor: iconColor,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/activity_log');
            },
          ),
          _buildDrawerItem(
            iconData: Icons.settings_outlined,
            text: 'الإعدادات',
            iconColor: iconColor,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          _buildDrawerItem(
            iconData: Icons.people_alt_outlined,
            text: 'أطفالي',
            iconColor: iconColor,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/my_children');
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20.0), // Made const
            child: ElevatedButton.icon(
              icon: const Icon(
                // Made const
                Icons.logout,
                color: AppColors.white,
                textDirection: TextDirection.rtl,
              ),
              label: const Text(
                // Made const
                'تسجيل الخروج',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                context.read<AuthCubit>().logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                minimumSize: const Size(double.infinity, 50), // Made const
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Made const
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    String? iconAsset,
    IconData? iconData,
    required String text,
    required Color iconColor, // This cannot be const if iconColor isn't
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: const Icon(
        // Made const
        Icons.chevron_left,
        color: AppColors.lightGrey,
        size: 22,
      ),
      title: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          text,
          style: const TextStyle(
            // Made const
            fontSize: 15,
            fontFamily: 'Cairo',
            color: AppColors.darkGreyText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      trailing: iconAsset != null
          ? SvgPicture.asset(
              iconAsset,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                iconColor,
                BlendMode.srcIn,
              ), // Cannot be const due to iconColor
            )
          : Icon(
              iconData,
              color: iconColor,
              size: 24,
            ), // Cannot be const due to iconColor
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        // Made const
        horizontal: 24.0,
        vertical: 4.0,
      ),
    );
  }
}

// Definition for _ChildProfile if it were to be const
// class _ChildProfile {
//   final String id;
//   final String name;
//   final String? avatarUrl;
//   final String placeholderInitial;

//   const _ChildProfile({ // Const constructor
//     required this.id,
//     required this.name,
//     this.avatarUrl,
//     required this.placeholderInitial,
//   });
// }
