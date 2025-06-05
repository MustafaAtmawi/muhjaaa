part of 'doctor_list_cubit.dart';

enum ProviderListFilter {
  specialists, // Default or as per your primary use case
  doctors,
  // all, // Could be an option too
}

abstract class DoctorListState extends Equatable {
  const DoctorListState();
  @override
  List<Object?> get props => [];
}

class DoctorListInitial extends DoctorListState {}

class DoctorListLoading extends DoctorListState {}

class DoctorListLoaded extends DoctorListState {
  final List<DoctorModel> providers;
  final ProviderListFilter selectedFilter;
  final String searchQuery;

  const DoctorListLoaded({
    required this.providers,
    this.selectedFilter = ProviderListFilter.specialists, // Default
    this.searchQuery = '',
  });

  DoctorListLoaded copyWith({
    List<DoctorModel>? providers,
    ProviderListFilter? selectedFilter,
    String? searchQuery,
    bool?
    isLoading, // Though loading is a separate state, useful for partial updates
  }) {
    return DoctorListLoaded(
      providers: providers ?? this.providers,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [providers, selectedFilter, searchQuery];
}

class DoctorListError extends DoctorListState {
  final String message;
  const DoctorListError(this.message);
  @override
  List<Object?> get props => [message];
}
