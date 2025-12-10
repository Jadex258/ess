import 'dart:io';
import 'package:ess/models/payslip.dart';
import 'package:ess/provider/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

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
      final pdfFile = await _generatePDF(payslip, context);
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

  static Future<File> _generatePDF(Payslip payslip, BuildContext context) async {
    final pdf = pw.Document();

    final poppins = pw.Font.ttf(await rootBundle.load('assets/fonts/Poppins-Regular.ttf'));
    final poppinsBold = pw.Font.ttf(await rootBundle.load('assets/fonts/Poppins-Bold.ttf'));
    final roboto = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));

    final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    final employeeName = employeeProvider.employee?.fullName ?? 'Employee Name';

    pw.Widget pesoText(String amount, {bool isBold = false}) {
      return pw.RichText(
        text: pw.TextSpan(
          children: [
            pw.TextSpan(text: '₱', style: pw.TextStyle(font: roboto, fontSize: 14)),
            pw.TextSpan(
              text: amount,
              style: pw.TextStyle(
                font: isBold ? poppinsBold : poppins,
                fontSize: 14,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Cenixys', style: pw.TextStyle(font: poppinsBold, fontSize: 20)),
                      pw.Text('Ormoc City Leyte      cenixys@gmail.com', style: pw.TextStyle(font: poppins, fontSize: 12)),
                    ],
                  ),
                  pw.Text('PAYSLIP', style: pw.TextStyle(font: poppinsBold, fontSize: 24)),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Employee: $employeeName', style: pw.TextStyle(font: poppins)),
                      pw.Text('Employee ID: ${payslip.employeeId}', style: pw.TextStyle(font: poppins)),
                      pw.Text('Period: ${payslip.period}', style: pw.TextStyle(font: poppins)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Generated: ${DateFormat('MMM dd, yyyy').format(payslip.generatedAt)}', style: pw.TextStyle(font: poppins)),
                      pw.Text('Payslip ID: ${payslip.id}', style: pw.TextStyle(font: poppins)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              pw.Text('Earnings', style: pw.TextStyle(font: poppinsBold, fontSize: 16)),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  for (final entry in [
                    ['Basic Pay', payslip.basicPay],
                    ['Allowances', payslip.allowances],
                    ['Overtime', payslip.overtime],
                    ['Total Earnings', payslip.basicPay + payslip.allowances + payslip.overtime],
                  ])
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(entry[0] as String, style: pw.TextStyle(font: poppins)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pesoText((entry[1] as double).toStringAsFixed(2), isBold: entry[0] == 'Total Earnings'),
                        ),
                      ],
                    ),
                ],
              ),

              pw.SizedBox(height: 20),

              pw.Text('Deductions', style: pw.TextStyle(font: poppinsBold, fontSize: 16)),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  if (payslip.deductionBreakdown != null && payslip.deductionBreakdown!.isNotEmpty)
                    for (final entry in payslip.deductionBreakdown!.entries)
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(entry.key, style: pw.TextStyle(font: poppins)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pesoText(entry.value.toStringAsFixed(2)),
                          ),
                        ],
                      )
                  else
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('No deductions', style: pw.TextStyle(font: poppins)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('-', style: pw.TextStyle(font: poppins)),
                        ),
                      ],
                    ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Total Deductions', style: pw.TextStyle(font: poppinsBold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pesoText(payslip.deductions.toStringAsFixed(2), isBold: true),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('NET PAY', style: pw.TextStyle(font: poppinsBold, fontSize: 18)),
                    pesoText(payslip.netPay.toStringAsFixed(2), isBold: true),
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