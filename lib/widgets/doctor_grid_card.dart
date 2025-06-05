import 'package:flutter/material.dart';
import 'package:muhjaaa/models/doctor_model.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class DoctorGridCard extends StatelessWidget {
  final DoctorModel doctor;
  // Callbacks for actions, to be implemented in the screen
  final VoidCallback? onBookAppointment;
  final VoidCallback? onSendMessage;

  const DoctorGridCard({
    super.key,
    required this.doctor,
    this.onBookAppointment,
    this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    // Determine action button text and callback based on your logic
    // For this example, we'll use a generic "Book Appointment"
    // In a real app, this might differ or you might have multiple buttons
    const String actionButtonText = "حجز موعد";
    final VoidCallback primaryAction =
        onBookAppointment ??
        () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Book appointment for ${doctor.name} (Placeholder)",
                textAlign: TextAlign.right,
              ),
            ),
          );
        };

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(4), // Add some margin for spacing in grid
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Adjusted padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              // Group for avatar, name, specialty
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 32, // Slightly smaller avatar for grid
                      backgroundColor: AppColors.lightGrey.withOpacity(0.2),
                      backgroundImage:
                          doctor.avatarUrl != null &&
                              doctor.avatarUrl!.startsWith('assets/')
                          ? AssetImage(doctor.avatarUrl!)
                                as ImageProvider // For local assets
                          : doctor.avatarUrl != null
                          ? NetworkImage(
                              doctor.avatarUrl!,
                            ) // For network images
                          : null,
                      child: (doctor.avatarUrl == null)
                          ? Text(
                              doctor.placeholderLetter,
                              style: const TextStyle(
                                fontSize: 26, // Adjusted size
                                color: AppColors.primaryRed,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            )
                          : null,
                    ),
                    if (doctor.isActive)
                      Positioned(
                        bottom: 0, // Adjust position relative to avatar size
                        right: 0, // Adjust position relative to avatar size
                        child: Container(
                          width: 10, // Smaller indicator
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.positiveGreen,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  doctor.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13, // Slightly smaller for grid card
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreyText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  doctor.specialty,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11, // Slightly smaller for grid card
                    color: AppColors.mutedBlueGrey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: primaryAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ), // Adjusted padding
                textStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ), // Adjusted font size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(90, 32), // Adjusted min size
              ),
              child: const Text(actionButtonText),
            ),
          ],
        ),
      ),
    );
  }
}
