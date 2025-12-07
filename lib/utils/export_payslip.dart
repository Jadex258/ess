import 'dart:io';
import 'package:ess/models/payslip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PayslipDownloadHelper {
  static Future<void> downloadPayslip(Payslip payslip, BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Generating payslip...'),
            ],
          ),
        ),
      );
      final pdfFile = await _generatePDF(payslip);
      Navigator.pop(context);
      showModalBottomSheet(
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                visualDensity: VisualDensity.compact,
                leading: const Icon(Icons.visibility),
                title: const Text('Preview'),
                onTap: () {
                  Navigator.pop(context);
                  _previewPDF(pdfFile, context);
                },
              ),
              ListTile(
                visualDensity: VisualDensity.compact,
                leading: const Icon(Icons.download),
                title: const Text('Download'),
                onTap: () {
                  Navigator.pop(context);
                  _downloadPDF(pdfFile, context);
                },
              ),
            ],
          ),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate payslip: $e')),
      );
      print(e);
    }
  }

  static Future<File> _generatePDF(Payslip payslip) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('EVSU OCC',
                          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Ormoc City Leyte - evsuocc@evsu.edu.ph'),
                    ],
                  ),
                  pw.Text('PAYSLIP',
                      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Employee: John Doe'),
                      pw.Text('Employee ID: ${payslip.employeeId}'),
                      pw.Text('Period: ${payslip.period}'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Generated: ${DateFormat('MMM dd, yyyy').format(payslip.generatedAt)}'),
                      pw.Text('Payslip ID: ${payslip.id}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                context: context,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: ['Earnings', 'Amount'],
                data: [
                  ['Basic Pay', '\$${payslip.basicPay.toStringAsFixed(2)}'],
                  ['Allowances', '\$${payslip.allowances.toStringAsFixed(2)}'],
                  ['Overtime', '\$${payslip.overtime.toStringAsFixed(2)}'],
                  ['Total Earnings', '\$${(payslip.basicPay + payslip.allowances + payslip.overtime).toStringAsFixed(2)}'],
                ],
              ),
              pw.SizedBox(height: 20),
              if (payslip.deductionBreakdown != null)
                pw.TableHelper.fromTextArray(
                  context: context,
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headers: ['Deductions', 'Amount'],
                  data: payslip.deductionBreakdown!.entries.map((e) => [e.key, '\$${e.value.toStringAsFixed(2)}']).toList(),
                ),
              pw.SizedBox(height: 20),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('NET PAY',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
                    pw.Text('\$${payslip.netPay.toStringAsFixed(2)}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24, color: PdfColors.green)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Payslip_${payslip.period.replaceAll(' ', '_')}.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static Future<void> _previewPDF(File file, BuildContext context) async {
    await Printing.layoutPdf(
      onLayout: (_) => file.readAsBytes(),
    );
  }

  static Future<void> _downloadPDF(File file, BuildContext context) async {
    await OpenFile.open(file.path);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payslip saved to: ${file.path}')),
    );
  }
}