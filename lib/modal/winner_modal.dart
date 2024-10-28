class Winner {
  final int id;
  final int amount;
  final String title;
  final String user;

  Winner({
    required this.id,
    required this.amount,
    required this.title,
    required this.user,
  });

  factory Winner.fromJson(Map<String, dynamic> json) {
    return Winner(
      id: json['id'],
      amount: json['amount'],
      title: json['title'],
      user: json['user'],
    );
  }
}
