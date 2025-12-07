import 'package:ess/enums/request_enums.dart';

class Request {
  final String id;
  final String employeeId;
  final RequestType type;
  final RequestStatus status;
  final DateTime createdAt;
  final DateTime? respondedAt;
  final String? respondedBy;
  final Map<String, dynamic> data;
  final String? remarks;

  Request({
    required this.id,
    required this.employeeId,
    required this.type,
    required this.status,
    required this.createdAt,
    this.respondedAt,
    this.respondedBy,
    required this.data,
    this.remarks,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      type: RequestType.values.firstWhere(
            (e) => e.name == json['type'],
      ),
      status: RequestStatus.values.firstWhere(
            (e) => e.name == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      respondedAt: json['respondedAt'] != null
          ? DateTime.parse(json['respondedAt'] as String)
          : null,
      respondedBy: json['respondedBy'] as String?,
      data: Map<String, dynamic>.from(json['data'] as Map),
      remarks: json['remarks'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'type': type.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
      'respondedBy': respondedBy,
      'data': data,
      'remarks': remarks,
    };
  }

  // Helpers for leave request
  String? get leaveStartDate => data['startDate'] as String?;
  String? get leaveEndDate => data['endDate'] as String?;
  String? get leaveReason => data['reason'] as String?;
  // Helpers for overtime request
  String? get overTimeDate => data['date'] as String?;
  String? get overTimeHours => data['hours'] as String?;
  String? get overTimeReason => data['reason'] as String?;

  String? get correctionDate => data['date'] as String?;
  String? get correctionType => data['correctionType'] as String?;
  String? get correctionActualTime => data['actualTime'] as String?;
  String? get correctionCorrectTime => data['correctTime'] as String?;
  String? get correctionReason => data['reason'] as String?;

  // Helpers for correction request


  bool get isPending => status == RequestStatus.pending;
  bool get isApproved => status == RequestStatus.approved;
  bool get isRejected => status == RequestStatus.rejected;

  Request copyWith({
    String? id,
    String? employeeId,
    RequestType? type,
    RequestStatus? status,
    DateTime? createdAt,
    DateTime? respondedAt,
    String? respondedBy,
    Map<String, dynamic>? data,
    String? remarks,
  }) {
    return Request(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt ?? this.respondedAt,
      respondedBy: respondedBy ?? this.respondedBy,
      data: data ?? this.data,
      remarks: remarks ?? this.remarks,
    );
  }
}