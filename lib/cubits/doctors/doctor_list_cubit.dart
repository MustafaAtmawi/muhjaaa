import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muhjaaa/models/doctor_model.dart'; // Updated DoctorModel
// import 'package:muhjaaa/repositories/doctor_repository.dart'; // To be created or use existing relevant repository

part 'doctor_list_state.dart';

class DoctorListCubit extends Cubit<DoctorListState> {
  // final DoctorRepository _doctorRepository; // TODO: Inject actual repository

  DoctorListCubit(/*this._doctorRepository*/) : super(DoctorListInitial()) {
    loadProviders(filter: ProviderListFilter.specialists); // Initial load
  }

  Future<void> loadProviders({
    ProviderListFilter filter = ProviderListFilter.specialists,
    String query = '',
  }) async {
    emit(DoctorListLoading());
    try {
      // TODO: Replace with actual repository call:
      // final providers = await _doctorRepository.getProviders(filter: filter, searchQuery: query);
      await Future.delayed(
        const Duration(milliseconds: 800),
      ); // Simulate network delay
      List<DoctorModel> mockProviders = _getMockProviders(filter, query);

      emit(
        DoctorListLoaded(
          providers: mockProviders,
          selectedFilter: filter,
          searchQuery: query,
        ),
      );
    } catch (e) {
      emit(DoctorListError("Failed to load providers: ${e.toString()}"));
    }
  }

  void applyFilter(ProviderListFilter filter) {
    String currentQuery = '';
    if (state is DoctorListLoaded) {
      currentQuery = (state as DoctorListLoaded).searchQuery;
    }
    loadProviders(filter: filter, query: currentQuery);
  }

  void searchProviders(String query) {
    ProviderListFilter currentFilter =
        ProviderListFilter.specialists; // Default
    if (state is DoctorListLoaded) {
      currentFilter = (state as DoctorListLoaded).selectedFilter;
    }
    loadProviders(filter: currentFilter, query: query);
  }

  // Mock data generation
  List<DoctorModel> _getMockProviders(ProviderListFilter filter, String query) {
    List<DoctorModel> allProviders = [
      const DoctorModel(
        id: '1',
        name: 'د. زهرة محمد',
        specialty: 'نسائية وتوليد',
        avatarUrl: null,
        placeholderLetter: 'ز',
        isActive: true,
      ),
      const DoctorModel(
        id: '2',
        name: 'د. أحمد علي',
        specialty: 'أطفال وحديثي الولادة',
        avatarUrl: 'assets/images/placeholder_doctor_male.png',
        placeholderLetter: 'أ',
        isActive: false,
      ), // Example with asset
      const DoctorModel(
        id: '3',
        name: 'د. سارة إبراهيم',
        specialty: 'جلدية وتجميل',
        avatarUrl: null,
        placeholderLetter: 'س',
        isActive: true,
      ),
      const DoctorModel(
        id: '4',
        name: 'د. عمر حسن',
        specialty: 'عظام ومفاصل',
        avatarUrl: null,
        placeholderLetter: 'ع',
        isActive: true,
      ),
      const DoctorModel(
        id: '5',
        name: 'د. ليلى خالد',
        specialty: 'نسائية وتوليد',
        avatarUrl: 'assets/images/placeholder_doctor_female.png',
        placeholderLetter: 'ل',
        isActive: false,
      ), // Example with asset
      const DoctorModel(
        id: '6',
        name: 'د. يوسف محمود',
        specialty: 'أطفال وحديثي الولادة',
        avatarUrl: null,
        placeholderLetter: 'ي',
        isActive: true,
      ),
      const DoctorModel(
        id: '7',
        name: 'د. رنا قاسم',
        specialty: 'جلدية وتجميل',
        avatarUrl: null,
        placeholderLetter: 'ر',
        isActive: false,
      ),
      const DoctorModel(
        id: '8',
        name: 'د. خالد وليد',
        specialty: 'عظام ومفاصل',
        avatarUrl: null,
        placeholderLetter: 'خ',
        isActive: true,
      ),
    ];

    List<DoctorModel> filteredList;

    if (filter == ProviderListFilter.doctors) {
      filteredList = allProviders
          .where(
            (p) =>
                p.specialty == 'عظام ومفاصل' || p.specialty == 'جلدية وتجميل',
          )
          .toList();
    } else if (filter == ProviderListFilter.specialists) {
      filteredList = allProviders
          .where(
            (p) =>
                p.specialty == 'نسائية وتوليد' ||
                p.specialty == 'أطفال وحديثي الولادة',
          )
          .toList();
    } else {
      // ProviderListFilter.all
      filteredList = allProviders;
    }

    if (query.isNotEmpty) {
      filteredList = filteredList
          .where(
            (p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.specialty.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    return filteredList;
  }
}
