import 'package:ess/enums/account_enum.dart';

class Employee {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? phoneNumber;
  final String? address;
  final String department;
  final String position;
  final EmploymentType employmentType;
  final DateTime hireDate;
  final AccountStatus accountStatus;

  Employee({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.phoneNumber,
    this.address,
    required this.department,
    required this.position,
    required this.employmentType,
    required this.hireDate,
    required this.accountStatus,
  });

  // From Firestore
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      middleName: json['middleName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      department: json['department'] as String,
      position: json['position'] as String,
      employmentType: EmploymentType.values.firstWhere(
            (e) => e.name == json['employmentType'],
        orElse: () => EmploymentType.fullTime,
      ),
      hireDate: DateTime.parse(json['hireDate'] as String),
      accountStatus: AccountStatus.values.firstWhere(
            (e) => e.name == json['accountStatus'],
        orElse: () => AccountStatus.active,
      ),
    );
  }

  // To Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'phoneNumber': phoneNumber,
      'address': address,
      'department': department,
      'position': position,
      'employmentType': employmentType,
      'hireDate': hireDate.toIso8601String(),
      'accountStatus': accountStatus.name,
    };
  }

  // Helpers
  String get fullName {
    final middle = middleName != null ? ' $middleName ' : ' ';
    return '$firstName$middle$lastName';
  }

  bool get needsSetup => accountStatus == AccountStatus.pendingSetup;

  // Mutable copy
  Employee copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? middleName,
    String? phoneNumber,
    String? address,
    String? department,
    String? position,
    EmploymentType? employmentType,
    DateTime? hireDate,
    AccountStatus? accountStatus,
  }) {
    return Employee(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      department: department ?? this.department,
      position: position ?? this.position,
      employmentType: employmentType ?? this.employmentType,
      hireDate: hireDate ?? this.hireDate,
      accountStatus: accountStatus ?? this.accountStatus,
    );
  }
}