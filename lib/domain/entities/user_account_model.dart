class UserAccount {
  final String name;
  final int userId;
  final String phone;
  final int memberType;
  final String memberTypeName;

  UserAccount({
    required this.name,
    required this.userId,
    required this.phone,
    required this.memberType,
    required this.memberTypeName,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      name: json['name']?.toString() ?? '',
      userId: int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      phone: json['phone']?.toString() ?? '',
      memberType: int.tryParse(json['member_type']?.toString() ?? '0') ?? 0,
      memberTypeName: json['member_type_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'user_id': userId,
      'phone': phone,
      'member_type': memberType,
      'member_type_name': memberTypeName,
    };
  }
}
