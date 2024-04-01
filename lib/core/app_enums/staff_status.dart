
// ignore_for_file: constant_identifier_names

enum StaffStatus {
  ACTIVE('ACTIVE'),
  NEW('NEW'),
  DEACTIVE('DE-ACTIVE');

  const StaffStatus(this.stringValue);
  final String stringValue;
}
