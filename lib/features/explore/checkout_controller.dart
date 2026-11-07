import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'site_model.dart';
import 'bookings_controller.dart';
import '../main_controller.dart';

class CheckoutController extends GetxController {
  final TourismSite site;
  final double baseTotal;

  CheckoutController({required this.site, required this.baseTotal});

  final double serviceFee = 4.50;
  final double insuranceFee = 2.00;
  final double usdRate = 1.41;

  var discount = 0.0.obs;
  var selectedPayment = 'credit'.obs;

  var isCreditCardLinked = false.obs;
  var isPaypalLinked = false.obs;

  // Dynamic text variables to show on the UI buttons
  var ccLast4 = ''.obs;
  var userEmail = ''.obs;

  // Text Controllers for popups
  final promoController = TextEditingController();
  final ccNumberController = TextEditingController();
  final ccExpiryController = TextEditingController();
  final ccCvvController = TextEditingController();
  final ccNameController = TextEditingController();
  final paypalEmailController = TextEditingController();
  final paypalPassController = TextEditingController();

  double get totalPayable => (baseTotal + serviceFee + insuranceFee) - discount.value;
  double get totalUsd => totalPayable * usdRate;

  @override
  void onClose() {
    promoController.dispose();
    ccNumberController.dispose();
    ccExpiryController.dispose();
    ccCvvController.dispose();
    ccNameController.dispose();
    paypalEmailController.dispose();
    paypalPassController.dispose();
    super.onClose();
  }

  void applyPromoCode() {
    final code = promoController.text.trim().toUpperCase();
    if (code == 'JORDAN10' || code == 'TRIPMATE') {
      discount.value = 10.0;
      Get.snackbar('Success', 'Promo code applied! 10 JOD discount.', backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      discount.value = 0.0;
      Get.snackbar('Invalid Code', 'This promo code is invalid or expired.', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void selectPaymentMethod(String method) {
    if (method == 'credit') {
      if (!isCreditCardLinked.value) _showCreditCardPopup();
      else selectedPayment.value = 'credit';
    } else if (method == 'paypal') {
      if (!isPaypalLinked.value) _showPaypalPopup();
      else selectedPayment.value = 'paypal';
    }
  }

  void _showCreditCardPopup() {
    Get.defaultDialog(
      title: 'Add Credit Card',
      contentPadding: const EdgeInsets.all(16),
      content: Column(
        children: [
          TextField(
            controller: ccNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
            decoration: const InputDecoration(labelText: 'Card Number (16 Digits)', hintText: '0000 0000 0000 0000'),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: TextField(
                controller: ccExpiryController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [LengthLimitingTextInputFormatter(5)],
                decoration: const InputDecoration(labelText: 'MM/YY')
              )),
              const SizedBox(width: 16),
              Expanded(child: TextField(
                controller: ccCvvController,
                keyboardType: TextInputType.number,
                obscureText: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                decoration: const InputDecoration(labelText: 'CVV')
              )),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: ccNameController,
            keyboardType: TextInputType.name,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))], // Only letters and spaces
            decoration: const InputDecoration(labelText: 'Cardholder Name'),
          ),
        ],
      ),
      textConfirm: 'Save Card',
      confirmTextColor: Colors.white,
      onConfirm: () {
        // --- VALIDATIONS ---
        if (ccNumberController.text.length < 16) {
          Get.snackbar('Error', 'Card number must be 16 digits.', backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }
        if (ccNameController.text.trim().isEmpty || ccCvvController.text.length < 3) {
          Get.snackbar('Error', 'Please fill all fields correctly.', backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }

        // Save dynamic data
        ccLast4.value = ccNumberController.text.substring(12);
        isCreditCardLinked.value = true;
        selectedPayment.value = 'credit';
        Get.back();
        Get.snackbar('Card Added', 'Your credit card was linked successfully.', backgroundColor: Colors.green, colorText: Colors.white);
      },
      textCancel: 'Cancel',
    );
  }

  void _showPaypalPopup() {
    Get.defaultDialog(
      title: 'Link PayPal',
      contentPadding: const EdgeInsets.all(16),
      content: Column(
        children: [
          TextField(
            controller: paypalEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'PayPal Email', hintText: 'email@example.com'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: paypalPassController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
        ],
      ),
      textConfirm: 'Link Account',
      confirmTextColor: Colors.white,
      onConfirm: () {
        // --- VALIDATIONS ---
        if (!GetUtils.isEmail(paypalEmailController.text)) {
          Get.snackbar('Error', 'Please enter a valid email address.', backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }
        if (paypalPassController.text.isEmpty) {
          Get.snackbar('Error', 'Password cannot be empty.', backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }

        userEmail.value = paypalEmailController.text;
        isPaypalLinked.value = true;
        selectedPayment.value = 'paypal';
        Get.back();
        Get.snackbar('PayPal Linked', 'Your PayPal account is ready.', backgroundColor: Colors.green, colorText: Colors.white);
      },
      textCancel: 'Cancel',
    );
  }

  void confirmPayment() {
    if (selectedPayment.value == 'credit' && !isCreditCardLinked.value) {
      Get.snackbar('Payment Error', 'Please link a credit card first.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (selectedPayment.value == 'paypal' && !isPaypalLinked.value) {
      Get.snackbar('Payment Error', 'Please link your PayPal account first.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // 1. Generate a random Ref Number
    String refNum = 'TM-${(1000 + DateTime.now().millisecond * 9)}';

    // 2. Add to Bookings
    Get.find<BookingsController>().addTrip(
      site: site,
      totalPaid: totalPayable,
      refNumber: refNum,
      date: DateTime.now().add(const Duration(days: 5)) // Mock future date
    );

    // 3. Show Success
    Get.snackbar('Payment Successful!', 'Your trip to ${site.name} is confirmed!', backgroundColor: Colors.green, colorText: Colors.white);

    // 4. Navigate to the Bookings Tab (Index 2) and clear the stack!
    Get.find<MainController>().changeTab(2);
    Get.until((route) => route.isFirst);
  }
}
