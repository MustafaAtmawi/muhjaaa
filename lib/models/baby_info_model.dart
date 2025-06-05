import 'package:equatable/equatable.dart';

enum Gender { male, female, unknown }

class BabyInfoModel extends Equatable {
  final String? id;
  final String name;
  final Gender gender;
  final double? lengthCm;
  final double? weightGm;
  final String? bloodType;
  final DateTime? birthDate;
  final bool hasSpecialCondition;

  const BabyInfoModel({
    this.id,
    this.name = '',
    this.gender = Gender.unknown,
    this.lengthCm,
    this.weightGm,
    this.bloodType,
    this.birthDate,
    this.hasSpecialCondition = false,
  });

  BabyInfoModel copyWith({
    String? id,
    String? name,
    Gender? gender,
    double? lengthCm,
    double? weightGm,
    String? bloodType,
    DateTime? birthDate,
    bool? hasSpecialCondition,
  }) {
    return BabyInfoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      lengthCm: lengthCm ?? this.lengthCm,
      weightGm: weightGm ?? this.weightGm,
      bloodType: bloodType ?? this.bloodType,
      birthDate: birthDate ?? this.birthDate,
      hasSpecialCondition: hasSpecialCondition ?? this.hasSpecialCondition,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    gender,
    lengthCm,
    weightGm,
    bloodType,
    birthDate,
    hasSpecialCondition,
  ];
}
