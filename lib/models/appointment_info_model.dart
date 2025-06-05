import 'package:equatable/equatable.dart';

// Enum for Appointment Status for type safety
enum AppointmentStatus {
  upcoming,
  completed,
  cancelled,
  unknown, // Fallback for unexpected values
}

// Renamed class to AppointmentInfoModel
class AppointmentInfoModel extends Equatable {
  final String id;
  final String doctorName;
  final String specialty;
  final DateTime startDateTime; // Replaces String date and part of timeSlot
  final DateTime endDateTime; // Replaces part of timeSlot
  final String avatarAsset; // Path to a local asset
  final bool isOnline;
  final AppointmentStatus status; // Changed to Enum

  const AppointmentInfoModel({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.startDateTime,
    required this.endDateTime,
    required this.avatarAsset,
    required this.isOnline,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    doctorName,
    specialty,
    startDateTime,
    endDateTime,
    avatarAsset,
    isOnline,
    status,
  ];

  // Factory constructor for creating a new AppointmentInfoModel instance from a map (JSON)
  factory AppointmentInfoModel.fromJson(Map<String, dynamic> json) {
    return AppointmentInfoModel(
      id: json['id'] as String,
      doctorName: json['doctorName'] as String,
      specialty: json['specialty'] as String,
      startDateTime: DateTime.parse(json['startDateTime'] as String),
      endDateTime: DateTime.parse(json['endDateTime'] as String),
      avatarAsset: json['avatarAsset'] as String,
      isOnline: json['isOnline'] as bool,
      status: AppointmentStatus.values.firstWhere(
        (e) =>
            e.name ==
            json['status'], // Using .name for Dart 2.15+ enum string conversion
        orElse: () =>
            AppointmentStatus.unknown, // Fallback for unknown status strings
      ),
    );
  }

  // Method for converting an AppointmentInfoModel instance to a map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorName': doctorName,
      'specialty': specialty,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'avatarAsset': avatarAsset,
      'isOnline': isOnline,
      'status':
          status.name, // Using .name for Dart 2.15+ enum string conversion
    };
  }

  // Example helper to get a displayable time slot string (you might want intl package for complex formatting)
  String get displayTimeSlot {
    // Basic formatting, consider using 'intl' package for localization and more complex formats
    String formatTime(DateTime dt) {
      String period = dt.hour < 12 ? 'AM' : 'PM';
      int hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      String minute = dt.minute.toString().padLeft(2, '0');
      return '$hour:$minute $period';
    }

    return '${formatTime(startDateTime)} - ${formatTime(endDateTime)}';
  }

  String get displayDate {
    // Basic formatting
    return '${startDateTime.year}-${startDateTime.month.toString().padLeft(2, '0')}-${startDateTime.day.toString().padLeft(2, '0')}';
  }
}
