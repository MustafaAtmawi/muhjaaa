import 'package:equatable/equatable.dart';

class SubscriptionPlanModel extends Equatable {
  final String id;
  final String title;
  final String pricePerPeriod; // e.g., "₪12.5/شهرياً"
  final String totalPriceInfo; // e.g., "₪150/سنوياً"
  final String? discountInfo; // e.g., "180" (original price)
  final bool isYearly; // To distinguish plan types

  const SubscriptionPlanModel({
    required this.id,
    required this.title,
    required this.pricePerPeriod,
    required this.totalPriceInfo,
    this.discountInfo,
    required this.isYearly,
  });

  // Example: Factory constructor from JSON
  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'] as String,
      title: json['title'] as String,
      pricePerPeriod: json['pricePerPeriod'] as String,
      totalPriceInfo: json['totalPriceInfo'] as String,
      discountInfo: json['discountInfo'] as String?,
      isYearly: json['isYearly'] as bool,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    pricePerPeriod,
    totalPriceInfo,
    discountInfo,
    isYearly,
  ];
}
