import 'package:muhjaaa/models/category_model.dart';
import 'package:muhjaaa/models/product_model.dart';
import 'package:muhjaaa/utils/either.dart';
import 'package:muhjaaa/repositories/failure.dart';

// Abstract interface for the Store Repository
abstract class StoreRepository {
  FutureEither<List<CategoryModel>> fetchCategories();
  FutureEither<List<ProductModel>> fetchProducts({
    String? categoryId,
    String? searchQuery,
  });
}

// Mock implementation of the Store Repository
class MockStoreRepository implements StoreRepository {
  // --- Simplified Mock Data for stability ---
  final List<CategoryModel> _mockCategories = [
    const CategoryModel(
      id: 'cat1_test',
      name: 'تصنيف ١',
      iconAssetPath: 'assets/icons/milk_category.svg',
    ), // Ensure asset valid & simple
    const CategoryModel(
      id: 'cat2_test',
      name: 'تصنيف ٢',
      iconAssetPath: 'assets/icons/toys_category.svg',
    ), // Ensure asset valid & simple
  ];

  final List<ProductModel> _allMockProducts = [
    const ProductModel(
      id: 'p1_test',
      name: 'منتج اختبار أ',
      categoryId: 'cat1_test',
      imageUrl: 'assets/images/s26_gold.png',
      price: 10.0,
    ), // Ensure asset valid & simple
    const ProductModel(
      id: 'p2_test',
      name: 'منتج اختبار ب',
      categoryId: 'cat2_test',
      imageUrl: 'assets/images/pampers.png',
      price: 20.0,
    ), // Ensure asset valid & simple
  ];
  // --- End Simplified Mock Data ---

  @override
  FutureEither<List<CategoryModel>> fetchCategories() async {
    // NO DELAY: await Future.delayed(const Duration(milliseconds: 10));
    try {
      return Right(_mockCategories);
    } catch (e) {
      return Left(
        Failure("MockError: Could not fetch categories: ${e.toString()}"),
      );
    }
  }

  @override
  FutureEither<List<ProductModel>> fetchProducts({
    String? categoryId,
    String? searchQuery,
  }) async {
    // NO DELAY: await Future.delayed(const Duration(milliseconds: 10));
    try {
      List<ProductModel> filteredProducts = _allMockProducts;

      if (categoryId != null) {
        filteredProducts = filteredProducts
            .where((p) => p.categoryId == categoryId)
            .toList();
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        filteredProducts = filteredProducts
            .where(
              (p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();
      }
      return Right(filteredProducts);
    } catch (e) {
      return Left(
        Failure("MockError: Could not fetch products: ${e.toString()}"),
      );
    }
  }
}
