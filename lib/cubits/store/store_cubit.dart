import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muhjaaa/models/category_model.dart';
import 'package:muhjaaa/models/product_model.dart';
import 'package:muhjaaa/repositories/store_repository.dart'; // Import the repository

part 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  final StoreRepository _storeRepository; // Dependency

  // Constructor now correctly takes a NAMED, REQUIRED storeRepository
  StoreCubit({required StoreRepository storeRepository})
    : _storeRepository = storeRepository,
      super(StoreInitial()) {
    loadStoreData();
  }

  Future<void> loadStoreData({String? categoryId, String query = ''}) async {
    emit(StoreLoading());
    try {
      final categoriesEither = await _storeRepository.fetchCategories();

      await categoriesEither.fold(
        (failure) async {
          emit(StoreError("Failed to load categories: ${failure.message}"));
        },
        (categoriesList) async {
          final productsEither = await _storeRepository.fetchProducts(
            categoryId: categoryId,
            searchQuery: query,
          );

          productsEither.fold(
            (failure) {
              emit(StoreError("Failed to load products: ${failure.message}"));
            },
            (productsList) {
              emit(
                StoreLoaded(
                  categories: categoriesList,
                  products: productsList,
                  selectedCategoryId: categoryId,
                  searchQuery: query,
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      emit(
        StoreError(
          "An unexpected error occurred in loadStoreData: ${e.toString()}",
        ),
      );
    }
  }

  void selectCategory(String? categoryId) {
    String currentQuery = '';
    String? currentSelectedCategoryId;

    if (state is StoreLoaded) {
      final loadedState = state as StoreLoaded;
      currentQuery = loadedState.searchQuery;
      currentSelectedCategoryId = loadedState.selectedCategoryId;
    }
    // Only reload if category actually changes
    if (currentSelectedCategoryId == categoryId) return;

    loadStoreData(categoryId: categoryId, query: currentQuery);
  }

  void searchProducts(String query) {
    String? currentCategoryId;

    if (state is StoreLoaded) {
      final loadedState = state as StoreLoaded;
      // Optional: check if query actually changed to prevent redundant calls if UI triggers rapidly
      // if (loadedState.searchQuery == query && loadedState.selectedCategoryId == currentCategoryId) return;
      currentCategoryId = loadedState.selectedCategoryId;
    }
    loadStoreData(categoryId: currentCategoryId, query: query);
  }
}
