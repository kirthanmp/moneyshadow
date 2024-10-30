class Withdrawal {
  final String id;
  final String fundId;
  final String memberId;
  final String memberName;
  final String withdrawAmount;
  final String balance;
  final String withdrawMonth;

  const Withdrawal({
    required this.id,
    required this.fundId,
    required this.memberId,
    required this.memberName,
    required this.withdrawAmount,
    required this.balance,
    required this.withdrawMonth,
  });

  factory Withdrawal.fromJson(Map<String, dynamic> json) {
    return Withdrawal(
      id: json['id'].toString(),
      fundId: json['fundId'].toString(),
      memberId: json['memberId'].toString(),
      memberName: json['memberName'].toString(),
      withdrawAmount: json['withdrawAmount'].toString(),
      balance: json['balance'].toString(),
      withdrawMonth: json['withdrawMonth'].toString(),
    );
  }
}
