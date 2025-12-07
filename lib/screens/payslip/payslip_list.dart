import 'package:ess/models/payslip.dart';
import 'package:ess/screens/payslip/view_payslip.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class PayslipListScreen extends StatelessWidget {
  const PayslipListScreen({super.key});

  // Dummy payslip data creation
  Payslip createDummyPayslip() {
    return Payslip(
      id: 'PSL-2024-12-001',
      employeeId: 'EMP-001',
      period: 'December 1-15, 2024',
      generatedAt: DateTime(2024, 12, 15, 14, 30),
      basicPay: 15000.00,
      allowances: 2500.00,
      overtime: 1250.50,
      deductions: 1850.75,
      netPay: 15000.00 + 2500.00 + 1250.50 - 1850.75,
      deductionBreakdown: {
        'SSS': 750.25,
        'PhilHealth': 375.50,
        'Pag-IBIG': 200.00,
        'Tax': 525.00,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        bgColor: const Color(0xFFF5F5F5),
        title: 'Payslips',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTotalNetPayCard(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Deductions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDeductionsRow(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildPayslipsList(context),
          ],
        ),
      ),
    );
  }


  Widget _buildTotalNetPayCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: const [
          Text(
            'Total Net Pay',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '\$34,567.89',
            style: TextStyle(
              fontSize: 36,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeductionsRow() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildDeductionCard(
          title: 'PhilHealth',
          amount: '\$700.9',
        ),
        _buildDeductionCard(
          title: 'SSS',
          amount: '\$8.9',
        ),
        _buildDeductionCard(
          title: 'Pag Ibig',
          amount: '\$8.9',
        ),
        _buildDeductionCard(
          title: 'Tax',
          amount: '\$8.9',
        ),
      ],
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

  Widget _buildPayslipsList(BuildContext context) {
    final List<Map<String, String>> payslips = [
      {
        'title': 'November pay',
        'date': '2 December 2025 3:41 pm',
        'amount': '\$200.00',
      },
      {
        'title': 'October pay',
        'date': '2 September 2025 3:41 pm',
        'amount': '\$200.00',
      },
      {
        'title': 'September pay',
        'date': '2 August 2025 3:41 pm',
        'amount': '\$200.00',
      },
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payslips',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...payslips.map((slip) {
            return Column(
              children: [
                _buildPayslipItem(
                  context,
                  title: slip['title']!,
                  date: slip['date']!,
                  amount: slip['amount']!,
                ),
                const SizedBox(height: 12),
              ],
            );
          }),
        ],
      ),
    );
  }


  Widget _buildPayslipItem(
      BuildContext context, {
        required String title,
        required String date,
        required String amount,
      }) {
    return ListTile(
      onTap: () {
        pushWithoutNavBar(
          context,
          CupertinoPageRoute(
            builder: (context) => ViewPayslipScreen(
              payslip: createDummyPayslip(),
            ),
          ),
        );
      },
      visualDensity: VisualDensity(vertical: -4),
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      dense: true,
      leading: const Icon(
        Icons.monetization_on_outlined,
        color: Color(0xFF43A047),
        size: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        date,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: Text(
        amount,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}