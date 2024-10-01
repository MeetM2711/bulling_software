import 'package:get/get.dart';

class BillingController extends GetxController {
  var customerName = ''.obs;
  var selectedServices = <String, bool>{}.obs;
  var totalAmount = 0.0.obs;

  final Map<String, double> services = {
    'Candid Photography': 40000.0,
    'Candid Videography': 50000.0,
    'Baby Photoshoot': 30000.0,
  };

  void updateCustomerName(String name) {
    customerName.value = name;
  }

  void calculateTotal() {
    final selectedValues =
        selectedServices.entries.where((entry) => entry.value);

    if (selectedValues.isNotEmpty) {
      totalAmount.value = selectedValues
          .map((entry) => services[entry.key]!)
          .reduce((a, b) => a + b);
    } else {
      totalAmount.value = 0.0;
    }
  }

  void toggleService(String service, bool isSelected) {
    selectedServices[service] = isSelected;
    calculateTotal();
  }

  void backupData() {
    // Logic to back up data (e.g., saving to a file)
    print("Backup Data: ${customerName.value}, Total: ₹${totalAmount.value}");
  }
}
