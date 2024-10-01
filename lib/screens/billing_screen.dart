import 'package:billing_project/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:billing_project/controllers/billing_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BillingScreen extends StatelessWidget {
  final BillingController controller = Get.put(BillingController());

  BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                controller.updateCustomerName(value);
              },
              decoration:
                  const InputDecoration(labelText: AppText.customerName),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.services.length,
                itemBuilder: (context, index) {
                  String service = controller.services.keys.elementAt(index);
                  return Obx(() => CheckboxListTile(
                        title: Text(service),
                        value: controller.selectedServices[service] ?? false,
                        onChanged: (value) {
                          controller.toggleService(service, value!);
                        },
                      ));
                },
              ),
            ),
            Obx(() => Text(
                  '${AppText.totleAmount} ${controller.totalAmount.value}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _generateBill();
              },
              child: const Text(AppText.generateBill),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                controller.backupData();
              },
              child: const Text(AppText.backupData),
            ),
          ],
        ),
      ),
    );
  }

  void _generateBill() async {
    final pdf = pw.Document();
    final font = await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
    final ttf = pw.Font.ttf(font);

    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
              'Bill To: ${Get.find<BillingController>().customerName.value}',
              style: pw.TextStyle(fontSize: 24, font: ttf)),
          pw.SizedBox(height: 20),
          pw.Text('Selected Services:',
              style: pw.TextStyle(fontSize: 20, font: ttf)),
          pw.SizedBox(height: 10),
          ...Get.find<BillingController>()
              .selectedServices
              .entries
              .where((entry) => entry.value)
              .map((entry) => pw.Text(
                  '${entry.key} - ₹ ${Get.find<BillingController>().services[entry.key]}',
                  style: pw.TextStyle(font: ttf))),
          pw.SizedBox(height: 20),
          pw.Text('Total: ₹ ${Get.find<BillingController>().totalAmount.value}',
              style: pw.TextStyle(fontSize: 24, font: ttf)),
        ],
      );
    }));

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
