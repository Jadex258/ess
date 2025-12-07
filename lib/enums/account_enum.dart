enum AccountStatus {
  pendingSetup,
  active,
  suspended;

  String get label {
    switch (this) {
      case AccountStatus.pendingSetup:
        return 'Pending Setup';
      case AccountStatus.active:
        return 'Active';
      case AccountStatus.suspended:
        return 'Suspended';
    }
  }
}

enum EmploymentType {
  fullTime,
  partTime,
  contractor,
  intern;

  String get label {
    switch (this) {
      case EmploymentType.fullTime:
        return 'Full Time';
      case EmploymentType.partTime:
        return 'Part Time';
      case EmploymentType.contractor:
        return 'Contractor';
      case EmploymentType.intern:
        return 'Intern';
    }
  }

  String get shortLabel {
    switch (this) {
      case EmploymentType.fullTime:
        return 'FT';
      case EmploymentType.partTime:
        return 'PT';
      case EmploymentType.contractor:
        return 'CON';
      case EmploymentType.intern:
        return 'INT';
    }
  }
}
