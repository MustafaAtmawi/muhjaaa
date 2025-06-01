import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart'; // Assuming AppColors is in this path
import 'package:muhjaaa/widgets/term_item.dart';

class TermsAndConditionsSheet extends StatelessWidget {
  final VoidCallback onAgreed;

  const TermsAndConditionsSheet({super.key, required this.onAgreed});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0), // Colors.grey[300]
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: AppColors.primaryRed,
                      child: Icon(Icons.check, color: Colors.white, size: 40),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 13,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.darkGreyText,
                      ),
                      label: const Text(
                        "عودة",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          color: AppColors.darkGreyText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 5, 24, 0),
              child: Text(
                'شروط وأحكام الاشتراك في مهجة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreyText,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                children: [
                  Text(
                    'قبل ما تكمل اشتراكك, ضروري تقرأى هاي الشروط:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: AppColors.mutedBlueGrey,
                    ),
                  ),
                  SizedBox(height: 16),
                  TermItem(
                    text:
                        "الاشتراك المدفوع يوفر صلاحيات وخدمات خاصة داخل التطبيق.",
                  ),
                  TermItem(
                    text:
                        "بياناتك بأمان وتستخدم لتحسين تجربتك فقط! اقرئى مراجعة سياسة الخصوصية.",
                  ),
                  TermItem(
                    text:
                        "لا يوجد استرداد للمبلغ بعد الاشتراك, إلا بحالات خاصة مثل أعطال تقنية.",
                  ),
                  TermItem(
                    text: "الاستخدام شخصي فقط, لا يجوز مشاركة حسابك مع غيرك.",
                  ),
                  TermItem(
                    text:
                        "أي استخدام مخالف من الممكن أن يتسبب في إلغاء اشتراكك.",
                  ),
                  SizedBox(height: 20),
                  Text(
                    'بالضغط على "أوافق", أنت توافقين على كل البنود.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreyText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the sheet first
                  onAgreed(); // Then call the agreed callback
                },
                child: const Text(
                  'أوافق',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
