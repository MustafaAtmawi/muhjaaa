import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muhjaaa/models/appointment_info_model.dart'; // Use the official model

part 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit() : super(AppointmentsInitial()) {
    // Fetch initial appointments, defaulting to specialists or a default filter
    fetchAppointments(AppointmentFilter.specialists);
  }

  // In a real app, this would come from an AppointmentRepository
  // final AppointmentRepository _appointmentRepository;
  // AppointmentsCubit(this._appointmentRepository) : super(AppointmentsInitial());

  Future<void> fetchAppointments(AppointmentFilter filter) async {
    emit(AppointmentsLoading());
    // Simulate API call with delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      List<AppointmentInfoModel> mockAppointments = [];
      final now = DateTime.now(); // For creating relative dates if needed

      if (filter == AppointmentFilter.specialists) {
        mockAppointments = List.generate(3, (index) {
          // Example: Create dates dynamically based on current date or a fixed future date
          final appointmentDay = 15 + index;
          return AppointmentInfoModel(
            id: 'spec_apt_$index',
            doctorName: 'د. سمر خليل',
            specialty: 'أخصائية تغذية',
            // Using fixed year/month for simplicity in mock data
            startDateTime: DateTime(
              now.year,
              now.month,
              appointmentDay,
              10,
              20,
            ), // 10:20 AM
            endDateTime: DateTime(
              now.year,
              now.month,
              appointmentDay,
              12,
              30,
            ), // 12:30 PM
            avatarAsset: 'assets/images/placeholder_doctor_female.png',
            isOnline: true,
            status: AppointmentStatus.upcoming, // Use Enum
          );
        });
      } else if (filter == AppointmentFilter.doctors) {
        mockAppointments = List.generate(2, (index) {
          final appointmentDay = 20 + index;
          return AppointmentInfoModel(
            id: 'doc_apt_$index',
            doctorName: 'د. أحمد ياسين',
            specialty: 'طبيب عام',
            startDateTime: DateTime(
              now.year,
              now.month,
              appointmentDay,
              14,
              0,
            ), // 2:00 PM
            endDateTime: DateTime(
              now.year,
              now.month,
              appointmentDay,
              15,
              30,
            ), // 3:30 PM
            avatarAsset: 'assets/images/placeholder_doctor_male.png',
            isOnline: false,
            status: AppointmentStatus.completed, // Use Enum
          );
        });
      }
      emit(
        AppointmentsLoaded(
          appointments: mockAppointments,
          selectedFilter: filter,
        ),
      );
    } catch (e) {
      emit(AppointmentsError("Failed to load appointments: ${e.toString()}"));
    }
  }

  void selectFilter(AppointmentFilter filter) {
    // Check current state to avoid unnecessary re-fetches if filter is already selected,
    // though fetchAppointments itself could also handle this.
    bool shouldFetch = true;
    if (state is AppointmentsLoaded) {
      final currentState = state as AppointmentsLoaded;
      if (currentState.selectedFilter == filter) {
        shouldFetch =
            false; // Already on this filter, no need to refetch identical mock data
      }
    }

    if (shouldFetch) {
      fetchAppointments(filter);
    }
  }

  Future<void> deleteAppointment(String appointmentId) async {
    if (state is AppointmentsLoaded) {
      final currentState = state as AppointmentsLoaded;
      // Emit a loading state for the list, or handle optimistically
      // For optimistic UI, remove immediately and then sync with backend.
      // For now, simulate backend delay then update.

      // Create a new list without the deleted appointment
      final updatedList = currentState.appointments
          .where((apt) => apt.id != appointmentId)
          .toList();

      // Optimistically update UI
      emit(currentState.copyWith(appointments: updatedList));

      // Simulate API call for deletion
      // In a real app:
      // final success = await _appointmentRepository.deleteAppointment(appointmentId);
      // if (!success) {
      //   // Revert UI or show error
      //   emit(AppointmentsError("Failed to delete appointment. Please try again."));
      //   fetchAppointments(currentState.selectedFilter); // Re-fetch to restore state
      // } else {
      //   // Optionally show a success message via a different mechanism (e.g., event Cubit)
      // }
      await Future.delayed(
        const Duration(milliseconds: 300),
      ); // Simulate network delay
      print("Appointment $appointmentId supposedly deleted from backend.");
    }
  }
}
