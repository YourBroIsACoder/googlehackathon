class Reward {
  final String id;
  final String title;
  final String description;
  final int pointsRequired;
  final String? couponCode;
  final double? discountPercent;
  final String? discountAmount;
  final String? imageUrl;
  final DateTime expiryDate;
  final bool isActive;

  Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsRequired,
    this.couponCode,
    this.discountPercent,
    this.discountAmount,
    this.imageUrl,
    required this.expiryDate,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'pointsRequired': pointsRequired,
      'couponCode': couponCode,
      'discountPercent': discountPercent,
      'discountAmount': discountAmount,
      'imageUrl': imageUrl,
      'expiryDate': expiryDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Reward.fromMap(Map<String, dynamic> map) {
    return Reward(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      pointsRequired: map['pointsRequired'] ?? 0,
      couponCode: map['couponCode'],
      discountPercent: map['discountPercent']?.toDouble(),
      discountAmount: map['discountAmount'],
      imageUrl: map['imageUrl'],
      expiryDate: DateTime.parse(map['expiryDate'] ?? DateTime.now().toIso8601String()),
      isActive: map['isActive'] ?? true,
    );
  }
}

class UserRewards {
  final String userId;
  int totalPoints;
  final List<String> redeemedCoupons;
  DateTime lastUpdated;

  UserRewards({
    required this.userId,
    this.totalPoints = 0,
    List<String>? redeemedCoupons,
    DateTime? lastUpdated,
  })  : redeemedCoupons = redeemedCoupons ?? [],
        lastUpdated = lastUpdated ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalPoints': totalPoints,
      'redeemedCoupons': redeemedCoupons,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory UserRewards.fromMap(Map<String, dynamic> map) {
    return UserRewards(
      userId: map['userId'] ?? '',
      totalPoints: map['totalPoints'] ?? 0,
      redeemedCoupons: List<String>.from(map['redeemedCoupons'] ?? []),
      lastUpdated: DateTime.parse(map['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }
}

