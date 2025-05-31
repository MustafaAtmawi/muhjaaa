import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class ActiveDoctorAvatar extends StatelessWidget {
  final VoidCallback? onTap;
  final String placeholderLetter;
  final String? avatarUrl;
  final String? name;

  const ActiveDoctorAvatar({
    super.key,
    this.onTap,
    required this.placeholderLetter,
    this.avatarUrl,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatarChild;
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      avatarChild = ClipOval(
        child: Image.network(
          avatarUrl!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                placeholderLetter.isNotEmpty
                    ? placeholderLetter[0].toUpperCase()
                    : 'D',
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.white,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          loadingBuilder:
              (
                BuildContext context,
                Widget child,
                ImageChunkEvent? loadingProgress,
              ) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2.0,
                    color: AppColors.primaryRed,
                  ),
                );
              },
        ),
      );
    } else {
      avatarChild = Center(
        child: Text(
          placeholderLetter.isNotEmpty
              ? placeholderLetter[0].toUpperCase()
              : 'D',
          style: const TextStyle(
            fontSize: 20,
            color: AppColors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: const Color.fromRGBO(
                  154,
                  181,
                  189,
                  0.5,
                ), // AppColors.mutedBlueGrey.withOpacity(0.5)
                child: avatarChild,
              ),
              Positioned(
                top: 15,
                right: 5,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.positiveGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
