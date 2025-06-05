part of 'appointments_cubit.dart';

enum AppointmentFilter { doctors, specialists } // Using an enum for filters

abstract class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object?> get props => [];
}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoaded extends AppointmentsState {
  final List<AppointmentInfoModel> appointments;
  final AppointmentFilter selectedFilter;

  const AppointmentsLoaded({
    required this.appointments,
    this.selectedFilter = AppointmentFilter.specialists, // Default filter
  });

  AppointmentsLoaded copyWith({
    List<AppointmentInfoModel>? appointments,
    AppointmentFilter? selectedFilter,
  }) {
    return AppointmentsLoaded(
      appointments: appointments ?? this.appointments,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [appointments, selectedFilter];
}

class AppointmentsError extends AppointmentsState {
  final String message;

  const AppointmentsError(this.message);

  @override
  List<Object?> get props => [message];
}
