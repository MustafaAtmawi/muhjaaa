import 'package:equatable/equatable.dart';

class DoctorModel extends Equatable {
  final String id;
  final String name;
  final String specialty; // Added specialty field
  final String placeholderLetter;
  final String? avatarUrl; // Optional: if you have image URLs from backend
  final bool isActive;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty, // Added to constructor
    required this.placeholderLetter,
    this.avatarUrl,
    required this.isActive,
  });

  // Example: Factory constructor from JSON (you'll adapt this to your API)
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      specialty: json['specialty'] as String, // Added
      placeholderLetter: json['placeholderLetter'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      isActive: json['isActive'] as bool,
    );
  }

  // Optional: Method for converting a DoctorModel instance to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty, // Added
      'placeholderLetter': placeholderLetter,
      'avatarUrl': avatarUrl,
      'isActive': isActive,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    specialty,
    placeholderLetter,
    avatarUrl,
    isActive,
  ];
}
