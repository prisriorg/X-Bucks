class Profile {
  final bool status;
  final String name;
  final String email;
  final int payouts;
  Profile({
    required this.status,
    required this.name,
    required this.email,
    required this.payouts,
  });
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      status: json['status'],
      name: json['name'],
      email: json['email'],
      payouts: json['payouts'],
    );
  }
}
