class Payslip {
  final String id;
  final String employeeId;
  final String period; // e.g., "December 1-15, 2024"
  final DateTime generatedAt;
  final double basicPay;
  final double allowances;
  final double overtime;
  final double deductions;
  final double netPay;
  final Map<String, double>? deductionBreakdown; // SSS, PhilHealth, etc.

  Payslip({
    required this.id,
    required this.employeeId,
    required this.period,
    required this.generatedAt,
    required this.basicPay,
    this.allowances = 0.0,
    this.overtime = 0.0,
    required this.deductions,
    required this.netPay,
    this.deductionBreakdown,
  });

  factory Payslip.fromJson(Map<String, dynamic> json) {
    return Payslip(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      period: json['period'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      basicPay: (json['basicPay'] as num).toDouble(),
      allowances: (json['allowances'] as num?)?.toDouble() ?? 0.0,
      overtime: (json['overtime'] as num?)?.toDouble() ?? 0.0,
      deductions: (json['deductions'] as num).toDouble(),
      netPay: (json['netPay'] as num).toDouble(),
      deductionBreakdown: json['deductionBreakdown'] != null
          ? Map<String, double>.from(json['deductionBreakdown'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'period': period,
      'generatedAt': generatedAt.toIso8601String(),
      'basicPay': basicPay,
      'allowances': allowances,
      'overtime': overtime,
      'deductions': deductions,
      'netPay': netPay,
      'deductionBreakdown': deductionBreakdown,
    };
  }

  double get grossPay => basicPay + allowances + overtime;
}
