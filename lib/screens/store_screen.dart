import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // SVG specific import might not be needed if all SVGs are removed
import 'package:muhjaaa/cubits/store/store_cubit.dart';
import 'package:muhjaaa/models/category_model.dart';
import 'package:muhjaaa/repositories/store_repository.dart';
import 'package:muhjaaa/utils/app_colors.dart';
// import 'package:muhjaaa/widgets/category_filter_item.dart'; // Usage was replaced
import 'package:muhjaaa/widgets/product_grid_card.dart';
import 'package:muhjaaa/widgets/app_drawer.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final int _currentBottomNavIndex = 1;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Using the simplified version from previous step (uses placeholder Icon for category item)
  Widget _buildFilterButton(
    BuildContext context,
    CategoryModel category,
    String? selectedCategoryId,
  ) {
    final bool isSelected = selectedCategoryId == category.id;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        context.read<StoreCubit>().selectCategory(category.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryRed.withOpacity(0.15)
                    : AppColors.searchBarBg,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: isSelected ? AppColors.primaryRed : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  // Placeholder for category SVG
                  Icons.category,
                  size: 28,
                  color: isSelected
                      ? AppColors.primaryRed
                      : AppColors.darkGreyText70,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppColors.primaryRed
                    : AppColors.darkGreyText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllCategoryButton(
    BuildContext context,
    String? selectedCategoryId,
  ) {
    final bool isAllSelected = selectedCategoryId == null;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        context.read<StoreCubit>().selectCategory(null);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isAllSelected
                    ? AppColors.primaryRed.withOpacity(0.15)
                    : AppColors.searchBarBg,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: isAllSelected
                      ? AppColors.primaryRed
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.apps_outlined,
                size: 28,
                color: isAllSelected
                    ? AppColors.primaryRed
                    : AppColors.darkGreyText70,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "الكل",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: isAllSelected ? FontWeight.bold : FontWeight.normal,
                color: isAllSelected
                    ? AppColors.primaryRed
                    : AppColors.darkGreyText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoreCubit(storeRepository: MockStoreRepository()),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.screenBackground,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: AppColors.darkGreyText,
              size: 28,
            ),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          title: const Text(
            "المتجر",
            style: TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.darkGreyText,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              // **** MODIFIED APPBAR ICON ****
              icon: const Icon(
                Icons.arrow_forward_ios, // Simple Material Icon
                color: AppColors.darkGreyText70,
                size: 22,
              ),
              // **** END OF MODIFICATION ****
              onPressed: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        endDrawer: AppDrawer(),
        body: BlocConsumer<StoreCubit, StoreState>(
          listener: (context, state) {
            if (state is StoreError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      "خطأ في تحميل بيانات المتجر: ${state.message}",
                      textAlign: TextAlign.right,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: TextField(
                    controller: _searchController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'البحث في المتجر...',
                      hintStyle: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.lightGrey,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.lightGrey,
                        size: 22,
                      ),
                      filled: true,
                      fillColor: AppColors.searchBarBg,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (query) {
                      context.read<StoreCubit>().searchProducts(query);
                    },
                  ),
                ),
                if (state is StoreLoaded && state.categories.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        reverse: true,
                        itemCount: state.categories.length + 1,
                        itemBuilder: (context, index) {
                          if (index == state.categories.length) {
                            return _buildAllCategoryButton(
                              context,
                              state.selectedCategoryId,
                            );
                          }
                          final category = state.categories[index];
                          return _buildFilterButton(
                            context,
                            category,
                            state.selectedCategoryId,
                          );
                        },
                      ),
                    ),
                  )
                else if (state is StoreLoading)
                  const SizedBox(height: 90, child: Center()),
                Expanded(child: _buildProductGrid(state)),
              ],
            );
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/ai_mama_chat');
            },
            backgroundColor: AppColors.white,
            elevation: 4,
            // **** MODIFIED FAB ICON ****
            child: const Icon(
              Icons.support_agent_outlined, // Simple Material Icon
              color: AppColors.primaryRed, // Or another suitable color
              size: 28, // Adjust size as needed
            ),
            // **** END OF MODIFICATION ****
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentBottomNavIndex,
          onTap: (index) {
            if (index == _currentBottomNavIndex) return;
            switch (index) {
              case 0:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Navigate to Profile (Placeholder)",
                      textAlign: TextAlign.right,
                    ),
                  ),
                );
                break;
              case 2:
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/chat_list',
                  (route) => false,
                );
                break;
              case 3:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Navigate to Articles (Placeholder)",
                      textAlign: TextAlign.right,
                    ),
                  ),
                );
                break;
              case 4:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Navigate to More (Placeholder)",
                      textAlign: TextAlign.right,
                    ),
                  ),
                );
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primaryRed,
          unselectedItemColor: AppColors.darkGreyText,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 10,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "الملف الشخصي",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: "المتجر",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "الرئيسية",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              label: "مقالات",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps_outlined),
              label: "المزيد",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(StoreState state) {
    if (state is StoreInitial || state is StoreLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryRed),
      );
    } else if (state is StoreLoaded) {
      if (state.products.isEmpty) {
        return Center(
          child: Text(
            state.searchQuery.isNotEmpty || state.selectedCategoryId != null
                ? "لا توجد منتجات تطابق بحثك/فلترك."
                : "لا توجد منتجات متاحة حالياً.",
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              color: AppColors.lightGrey,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }
      return GridView.builder(
        padding: const EdgeInsets.all(12.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.65,
        ),
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          final product = state.products[index];
          return ProductGridCard(product: product);
        },
      );
    } else if (state is StoreError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "حدث خطأ في عرض المنتجات: ${state.message}",
            style: const TextStyle(
              fontFamily: 'Cairo',
              color: Colors.red,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
