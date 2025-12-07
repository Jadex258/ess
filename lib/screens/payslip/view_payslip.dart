import 'package:ess/models/payslip.dart';
import 'package:ess/utils/export_payslip.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewPayslipScreen extends StatelessWidget {
  final Payslip payslip;

  const ViewPayslipScreen({super.key, required this.payslip});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
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
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNetPayCard(currencyFormat.format(payslip.netPay)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoChip('Period', payslip.period),
                  _buildInfoChip(
                      'Generated',
                      DateFormat('MMM d, yyyy').format(payslip.generatedAt)
                  ),
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

  Widget _buildNetPayCard(String formattedAmount) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          const SizedBox(height: 8),
          Text(
            formattedAmount,
            style: const TextStyle(
              fontSize: 36,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
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
    return Container(
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
    );
  }

  Widget _buildEarningsSection(NumberFormat currencyFormat) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                _buildEarningRow(
                  label: 'Basic Pay',
                  amount: currencyFormat.format(payslip.basicPay),
                  isTotal: false,
                ),
                const Divider(height: 16, color: Colors.grey),
                _buildEarningRow(
                  label: 'Allowances',
                  amount: currencyFormat.format(payslip.allowances),
                  isTotal: false,
                ),
                const Divider(height: 16, color: Colors.grey),
                _buildEarningRow(
                  label: 'Overtime',
                  amount: currencyFormat.format(payslip.overtime),
                  isTotal: false,
                ),
                const Divider(height: 16, color: Colors.grey),
                _buildEarningRow(
                  label: 'Total Earnings',
                  amount: currencyFormat.format(payslip.basicPay + payslip.allowances + payslip.overtime),
                  isTotal: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningRow({
    required String label,
    required String amount,
    required bool isTotal,
  }) {
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
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: isTotal ? const Color(0xFF43A047) : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDeductionsSection(NumberFormat currencyFormat) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
              ),
              Text(
                currencyFormat.format(payslip.deductions),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD32F2F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (payslip.deductionBreakdown != null && payslip.deductionBreakdown!.isNotEmpty)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: payslip.deductionBreakdown!.entries.map((entry) {
                return _buildDeductionCard(
                  title: entry.key,
                  amount: currencyFormat.format(entry.value),
                );
              }).toList(),
            )
          else Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildDeductionCard(
                title: 'SSS',
                amount: currencyFormat.format(payslip.deductions * 0.4),
              ),
              _buildDeductionCard(
                title: 'PhilHealth',
                amount: currencyFormat.format(payslip.deductions * 0.2),
              ),
              _buildDeductionCard(
                title: 'Pag-IBIG',
                amount: currencyFormat.format(payslip.deductions * 0.1),
              ),
              _buildDeductionCard(
                title: 'Tax',
                amount: currencyFormat.format(payslip.deductions * 0.3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeductionCard({
    required String title,
    required String amount,
  }) {
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
              const Icon(
                Icons.arrow_downward,
                color: Color(0xFFD32F2F),
                size: 14,
              ),
              const SizedBox(width:2),
              Flexible(
                child: Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            label: 'Total Earnings',
            amount: currencyFormat.format(totalEarnings),
            isPositive: true,
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            label: 'Total Deductions',
            amount: currencyFormat.format(payslip.deductions),
            isPositive: false,
          ),
          const Divider(height: 20),
          _buildSummaryRow(
            label: 'Net Pay',
            amount: currencyFormat.format(payslip.netPay),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String amount,
    bool isPositive = true,
    bool isTotal = false,
  }) {
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
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal
                ? const Color(0xFF43A047)
                : (isPositive ? Colors.black87 : const Color(0xFFD32F2F)),
          ),
        ),
      ],
    );
  }
}
