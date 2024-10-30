
class Member {

  final String emailId;
  final String phoneNo;
  final String firstName;
  final String lastName;
  final String country;
  final String gender;
  final String birthDate;
  final String idNumber;
  final String idType;
  final String stateOrProvince;
  final String jobTitle;

  const Member({
    required this.emailId,
    required this.phoneNo,
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.gender,
    required this.birthDate,
    required this.idNumber,
    required this.idType,
    required this.stateOrProvince,
    required this.jobTitle,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      emailId: json['emailId'].toString(),
      phoneNo: json['phoneNo'].toString(),
      firstName: json['firstName'].toString(),
      lastName: json['lastName'].toString(),
      country: json['country'].toString(),
      gender: json['gender'].toString(),
      birthDate: json['birthDate'].toString(),
      idNumber: json['idNumber'].toString(),
      idType: json['idType'].toString(),
      stateOrProvince: json['stateOrProvince'].toString(),
      jobTitle: json['jobTitle'].toString(),);
  }
}