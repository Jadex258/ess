import 'package:ess/models/payslip.dart';
import 'package:ess/utils/export_payslip.dart';
import 'package:ess/utils/helper.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewPayslipScreen extends StatelessWidget {
  final Payslip payslip;

  const ViewPayslipScreen({super.key, required this.payslip});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '',
      decimalDigits: 2,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        bgColor: const Color(0xFFF5F5F5),
        title: 'Payslip Details',
        trailing: IconButton(
          icon: const Icon(Icons.download),
          onPressed: () => PayslipDownloadHelper.downloadPayslip(payslip, context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNetPayCard(currencyFormat),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                spacing: 12,
                children: [
                  _buildInfoChip('Period', payslip.period),
                  _buildInfoChip('Generated', DateFormat('MMM d, yyyy').format(payslip.generatedAt)),
                ],
              ),
            ),
            _buildEarningsSection(currencyFormat),
            _buildDeductionsSection(currencyFormat),
            _buildSummarySection(currencyFormat),
          ],
        ),
      ),
    );
  }

  Widget _buildNetPayCard(NumberFormat currencyFormat) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Net Pay',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),  buildPesoRichText(currencyFormat.format(payslip.netPay), 36, FontWeight.bold),
          const SizedBox(height: 4),
          Text(
            payslip.period,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsSection(NumberFormat currencyFormat) {
    final totalEarnings = payslip.basicPay + payslip.allowances + payslip.overtime;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Earnings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildEarningRow('Basic Pay', payslip.basicPay, currencyFormat),
                const Divider(height: 16, color: Colors.grey),
                _buildEarningRow('Allowances', payslip.allowances, currencyFormat),
                const Divider(height: 16, color: Colors.grey),
                _buildEarningRow('Overtime', payslip.overtime, currencyFormat),
                const Divider(height: 16, color: Colors.grey),
                _buildEarningRow('Total Earnings', totalEarnings, currencyFormat, isTotal: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningRow(String label, double amount, NumberFormat currencyFormat, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: isTotal ? Colors.black : Colors.black87,
          ),
        ),  buildPesoRichText(
          currencyFormat.format(amount),
          isTotal ? 16 : 14,
          isTotal ? FontWeight.w600 : FontWeight.w400,
          color: isTotal ? const Color(0xFF43A047) : Colors.black87,
        ),
      ],
    );
  }

  Widget _buildDeductionsSection(NumberFormat currencyFormat) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Deductions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),  buildPesoRichText(
                currencyFormat.format(payslip.deductions),
                16,
                FontWeight.w600,
                color: const Color(0xFFD32F2F),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (payslip.deductionBreakdown != null && payslip.deductionBreakdown!.isNotEmpty)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: payslip.deductionBreakdown!.entries.map((entry) {
                return _buildDeductionCard(entry.key, entry.value, currencyFormat);
              }).toList(),
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No deductions', style: TextStyle(color: Colors.grey)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDeductionCard(String title, double amount, NumberFormat currencyFormat) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_downward, color: Color(0xFFD32F2F), size: 14),
              const SizedBox(width: 2),
              Flexible(
                child: buildPesoRichText(
                  currencyFormat.format(amount),
                  14,
                  FontWeight.w600,
                  color: Colors.black,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(NumberFormat currencyFormat) {
    final totalEarnings = payslip.basicPay + payslip.allowances + payslip.overtime;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          _buildSummaryRow('Total Earnings', totalEarnings, currencyFormat, isPositive: true),
          const SizedBox(height: 6),
          _buildSummaryRow('Total Deductions', payslip.deductions, currencyFormat, isPositive: false),
          const Divider(height: 20),
          _buildSummaryRow('Net Pay', payslip.netPay, currencyFormat, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, NumberFormat currencyFormat, {bool isPositive = true, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: Colors.black87,
          ),
        ),  buildPesoRichText(
          currencyFormat.format(amount),
          isTotal ? 18 : 15,
          isTotal ? FontWeight.bold : FontWeight.w600,
          color: isTotal
              ? const Color(0xFF43A047)
              : (isPositive ? Colors.black87 : const Color(0xFFD32F2F)),
        ),
      ],
    );
  }
}
