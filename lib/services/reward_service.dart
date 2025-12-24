// Mock Reward Service
import '../models/reward.dart';

class RewardService {
  final List<Reward> _availableRewards = [];
  final Map<String, UserRewards> _userRewards = {};

  RewardService() {
    _initializeRewards();
  }

  void _initializeRewards() {
    _availableRewards.addAll([
      Reward(
        id: 'reward_1',
        title: '10% Off at Local Restaurant',
        description: 'Get 10% discount on your next meal',
        pointsRequired: 50,
        couponCode: 'CIVIC10',
        discountPercent: 10.0,
        expiryDate: DateTime.now().add(const Duration(days: 30)),
      ),
      Reward(
        id: 'reward_2',
        title: 'Free Coffee',
        description: 'One free coffee at participating cafes',
        pointsRequired: 30,
        couponCode: 'CIVICCOFFEE',
        discountAmount: 'Free',
        expiryDate: DateTime.now().add(const Duration(days: 15)),
      ),
      Reward(
        id: 'reward_3',
        title: '20% Off Shopping',
        description: '20% discount at local stores',
        pointsRequired: 100,
        couponCode: 'CIVIC20',
        discountPercent: 20.0,
        expiryDate: DateTime.now().add(const Duration(days: 45)),
      ),
      Reward(
        id: 'reward_4',
        title: 'Movie Ticket Discount',
        description: 'Get ₹50 off on movie tickets',
        pointsRequired: 75,
        couponCode: 'CIVICMOVIE',
        discountAmount: '₹50',
        expiryDate: DateTime.now().add(const Duration(days: 60)),
      ),
      Reward(
        id: 'reward_5',
        title: 'Free Parking Voucher',
        description: 'One day free parking',
        pointsRequired: 40,
        couponCode: 'CIVICPARK',
        discountAmount: 'Free',
        expiryDate: DateTime.now().add(const Duration(days: 20)),
      ),
    ]);
  }

  // Points earned per action
  static const int pointsPerComplaint = 10;
  static const int pointsPerResolvedComplaint = 25;
  static const int pointsPerFirstComplaint = 50;

  List<Reward> getAvailableRewards() {
    return _availableRewards.where((r) => r.isActive).toList();
  }

  UserRewards getUserRewards(String userId) {
    return _userRewards[userId] ?? UserRewards(userId: userId, totalPoints: 0);
  }

  void addPoints(String userId, int points, {String? reason}) {
    final userRewards = getUserRewards(userId);
    userRewards.totalPoints += points;
    userRewards.lastUpdated = DateTime.now();
    _userRewards[userId] = userRewards;
  }

  bool redeemReward(String userId, String rewardId) {
    final reward = _availableRewards.firstWhere((r) => r.id == rewardId);
    final userRewards = getUserRewards(userId);

    if (userRewards.totalPoints >= reward.pointsRequired) {
      userRewards.totalPoints -= reward.pointsRequired;
      userRewards.redeemedCoupons.add(rewardId);
      userRewards.lastUpdated = DateTime.now();
      _userRewards[userId] = userRewards;
      return true;
    }
    return false;
  }

  List<Reward> getRedeemedRewards(String userId) {
    final userRewards = getUserRewards(userId);
    return _availableRewards
        .where((r) => userRewards.redeemedCoupons.contains(r.id))
        .toList();
  }
}




