import 'package:flutter/material.dart';

class PayslipPage extends StatelessWidget {
  const PayslipPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Light grey background similar to the design
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Account Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Total Net Pay Card
            _buildTotalNetPayCard(),

            const SizedBox(height: 32),

            // 2. Deductions Section
            const Text(
              'Deductions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildDeductionsRow(),

            const SizedBox(height: 32),

            // 3. Payslips List Section
            const Text(
              'Payslips',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildPayslipsList(context),
          ],
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildTotalNetPayCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB), // Slightly darker grey for the card
        borderRadius: BorderRadius.circular(16),
        // No explicit shadow in the flat design image, but subtle depth is okay
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDeductionCard(title: 'Late', amount: '\$13.5', subtext: '3h 3m'),
        const SizedBox(width: 12),
        _buildDeductionCard(
          title: 'Absent',
          amount: '\$21.4',
          subtext: '2 days',
        ),
        const SizedBox(width: 12),
        _buildDeductionCard(
          title: 'Undertime',
          amount: '\$8.9',
          subtext: '-3 hours',
        ),
      ],
    );
  }

  Widget _buildDeductionCard({
    required String title,
    required String amount,
    required String subtext,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFEBEBEB), // Matching the main card color
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.arrow_downward,
                  color: Color(0xFFD32F2F),
                  size: 20,
                ), // Red Arrow
                const SizedBox(width: 4),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              subtext,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayslipsList(BuildContext context) {
    // Mock Data based on the image
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

    // Using a Column inside the ScrollView instead of ListView to avoid scrolling conflicts
    // since the parent is already a SingleChildScrollView.
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: payslips.map((slip) {
          return _buildPayslipItem(
            context,
            title: slip['title']!,
            date: slip['date']!,
            amount: slip['amount']!,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPayslipItem(
    BuildContext context, {
    required String title,
    required String date,
    required String amount,
  }) {
    return InkWell(
      onTap: () {
        // Simple navigation to a dummy details page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PayslipDetailsPage()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Row(
          children: [
            const Icon(
              Icons.arrow_upward,
              color: Color(0xFF43A047),
              size: 24,
            ), // Green Arrow
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy Details Page for Navigation Test
class PayslipDetailsPage extends StatelessWidget {
  const PayslipDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payslip Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: const Center(child: Text("Full Payslip Breakdown would go here")),
    );
  }
}
