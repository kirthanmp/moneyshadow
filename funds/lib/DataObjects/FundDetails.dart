class Funds {

  final String name;
  final String capital;
  final String capacity;
  final String duration;
  final String contribution;
  final String agentCommission;
  final String minimumBiddingPercentage;
  final String status;

  const Funds({
    required this.name,
    required this.capital,
    required this.capacity,
    required this.duration,
    required this.contribution,
    required this.agentCommission,
    required this.minimumBiddingPercentage,
    required this.status
  });

  factory Funds.fromJson(Map<String, dynamic> json) {
    return Funds(
      name: json['name'].toString(),
      capital: json['capital'].toString(),
      capacity: json['capacity'].toString(),
      duration: json['duration'].toString(),
      contribution: json['contribution'].toString(),
      agentCommission: json['agentCommission'].toString(),
      minimumBiddingPercentage: json['minimumBiddingPercentage'].toString(),
      status: json['status'].toString(),
    );
  }
}