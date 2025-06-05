import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String iconAssetPath;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconAssetPath,
  });

  @override
  List<Object?> get props => [id, name, iconAssetPath];
}
