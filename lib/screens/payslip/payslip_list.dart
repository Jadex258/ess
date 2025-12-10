import 'package:ess/models/payslip.dart';
import 'package:ess/screens/payslip/view_payslip.dart';
import 'package:ess/services/payslip_service.dart';
import 'package:ess/widgets/app_bar.dart';
import 'package:ess/widgets/empty_widget.dart';
import 'package:ess/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class PayslipListScreen extends StatelessWidget {
  const PayslipListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        bgColor: const Color(0xFFF5F5F5),
        title: 'Payslips',
      ),
      body: StreamBuilder<List<Payslip>>(
        stream: PayslipService.streamPayslips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(loadingText: "Getting attendance...",);
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return EmptyWidget(
              title: 'No payslips found.',
            );
          }

          final payslips = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTotalNetPayCard(payslips),
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
                      _buildDeductionsRow(payslips),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildPayslipsList(context, payslips),
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _buildTotalNetPayCard(List<Payslip> payslips) {
    final totalNetPay = payslips.fold<double>(
      0.0, (sum, payslip) => sum + payslip.netPay,
    );

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
            'Total Net Pay',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: '₱',
                  style: TextStyle(
                    fontFamily: 'Material Icons',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: totalNetPay.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }

  Widget _buildDeductionsRow(List<Payslip> payslips) {
    final Map<String, double> totalDeductions = {};

    for (var payslip in payslips) {
      if (payslip.deductionBreakdown != null) {
        payslip.deductionBreakdown!.forEach((key, value) {
          totalDeductions[key] = (totalDeductions[key] ?? 0.0) + value;
        });
      }
    }

    if (totalDeductions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'No deductions',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: totalDeductions.entries.map((entry) {
        return _buildDeductionCard(
          title: entry.key,
          amount: entry.value.toStringAsFixed(2),
        );
      }).toList(),
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
                child: RichText(
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: '₱',
                        style: TextStyle(
                          fontFamily: 'Material Icons',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: amount,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )

              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPayslipsList(BuildContext context, List<Payslip> payslips) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payslips',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          ...payslips.map((p) => Column(
            children: [
              _buildPayslipItem(
                context,
                payslip: p,
              ),
            ],
          )),
        ],
      ),
    );
  }


  Widget _buildPayslipItem(
      BuildContext context, {
        required Payslip payslip,
      }) {
    final formattedDate = "${payslip.generatedAt.toLocal()}".split(".")[0];

    return ListTile(
      onTap: () {
        pushWithoutNavBar(
          context,
          CupertinoPageRoute(
            builder: (context) => ViewPayslipScreen(payslip: payslip),
          ),
        );
      },
      visualDensity: VisualDensity(vertical: -4),
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: const Icon(
        Icons.monetization_on_outlined,
        color: Color(0xFF43A047),
        size: 24,
      ),
      title: Text(
        payslip.period,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        formattedDate,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: '₱',
              style: TextStyle(
                fontFamily: 'Material Icons',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: payslip.netPay.toStringAsFixed(2),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      )

    );
  }

}