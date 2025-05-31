// lib/models/appointment_info_model.dart
import 'package:equatable/equatable.dart';

class AppointmentInfo extends Equatable {
  final String
  id; // Added an ID for potential future use (e.g., API integration, deletion)
  final String doctorName;
  final String specialty;
  final String
  timeSlot; // Could be DateTime in the future for more robust handling
  final String date; // Could be DateTime
  final String avatarAsset;
  final bool isOnline;
  final String status; // e.g., "Upcoming", "Completed", "Cancelled"

  const AppointmentInfo({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.timeSlot,
    required this.date,
    required this.avatarAsset,
    required this.isOnline,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    doctorName,
    specialty,
    timeSlot,
    date,
    avatarAsset,
    isOnline,
    status,
  ];

  // Optional: Add fromJson/toJson if you plan to serialize this model
  // factory AppointmentInfo.fromJson(Map<String, dynamic> json) { ... }
  // Map<String, dynamic> toJson() { ... }
}
