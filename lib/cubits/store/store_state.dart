part of 'store_cubit.dart';

abstract class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object?> get props => [];
}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreLoaded extends StoreState {
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final String? selectedCategoryId;
  final String searchQuery;

  const StoreLoaded({
    required this.categories,
    required this.products,
    this.selectedCategoryId,
    this.searchQuery = '',
  });

  StoreLoaded copyWith({
    List<CategoryModel>? categories,
    List<ProductModel>? products,
    String? selectedCategoryId,
    bool clearSelectedCategory = false,
    String? searchQuery,
  }) {
    return StoreLoaded(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedCategoryId: clearSelectedCategory
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    products,
    selectedCategoryId,
    searchQuery,
  ];
}

class StoreError extends StoreState {
  final String message;

  const StoreError(this.message);

  @override
  List<Object?> get props => [message];
}
