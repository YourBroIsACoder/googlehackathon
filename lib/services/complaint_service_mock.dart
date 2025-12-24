// Mock Complaint Service - For testing without Firebase
// Replace this with complaint_service.dart when Firebase is configured

import 'dart:async';
import '../models/complaint.dart';
import 'reward_service.dart';
import 'interfaces/i_complaint_service.dart';

class ComplaintService implements IComplaintService {
  final List<Complaint> _complaints = [];
  final _complaintsController = StreamController<List<Complaint>>.broadcast();

  ComplaintService() {
    // Initialize with some mock data
    _initializeMockData();
  }

  void _initializeMockData() {
    _complaints.addAll([
      Complaint(
        id: 'mock_1',
        userId: 'mock_user_1',
        userName: 'John Doe',
        userEmail: 'john@example.com',
        title: 'Large Pothole on Main Street',
        category: ComplaintCategory.pothole,
        description: 'Large pothole on Main Street causing traffic issues. Needs immediate attention.',
        latitude: 28.6139,
        longitude: 77.2090,
        address: 'Main Street, New Delhi',
        status: ComplaintStatus.open,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        priority: 1,
      ),
      Complaint(
        id: 'mock_2',
        userId: 'mock_user_2',
        userName: 'Jane Smith',
        userEmail: 'jane@example.com',
        title: 'Broken Streetlight Near Park',
        category: ComplaintCategory.brokenStreetlight,
        description: 'Streetlight not working near the park. Area is very dark at night.',
        latitude: 28.7041,
        longitude: 77.1025,
        address: 'Central Park Area, New Delhi',
        status: ComplaintStatus.inProgress,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
        priority: 2,
      ),
      Complaint(
        id: 'mock_3',
        userId: 'mock_user_1',
        userName: 'John Doe',
        userEmail: 'john@example.com',
        title: 'Garbage Accumulation at Market',
        category: ComplaintCategory.garbage,
        description: 'Garbage accumulation near the market. Unpleasant smell.',
        latitude: 28.5355,
        longitude: 77.3910,
        address: 'Market Area, New Delhi',
        status: ComplaintStatus.resolved,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        resolvedAt: DateTime.now().subtract(const Duration(days: 1)),
        priority: 2,
      ),
    ]);
    _notifyListeners();
  }

  @override
  Stream<List<Complaint>> getComplaintsForUser(String userId) {
    _notifyListeners();
    return _complaintsController.stream.map((all) => 
      all.where((c) => c.userId == userId).toList()
    );
  }

  @override
  Stream<List<Complaint>> getAllComplaints() {
    _notifyListeners();
    return _complaintsController.stream;
  }

  @override
  Stream<List<Complaint>> getComplaintsByStatus(ComplaintStatus status) {
    _notifyListeners();
    return _complaintsController.stream.map((all) => 
      all.where((c) => c.status == status).toList()
    );
  }

  @override
  Future<String> createComplaint(Complaint complaint) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final newComplaint = complaint.copyWith(
      id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
    );
    
    _complaints.insert(0, newComplaint);
    
    // Award points for submitting complaint
    final rewardService = RewardService();
    final isFirstComplaint = _complaints.where((c) => c.userId == complaint.userId).length == 1;
    
    if (isFirstComplaint) {
      rewardService.addPoints(complaint.userId, RewardService.pointsPerFirstComplaint, 
          reason: 'First complaint bonus!');
    } else {
      rewardService.addPoints(complaint.userId, RewardService.pointsPerComplaint,
          reason: 'Complaint submitted');
    }
    
    _notifyListeners();
    return newComplaint.id;
  }

  @override
  Future<void> updateComplaintStatus(
    String complaintId,
    ComplaintStatus status, {
    String? adminNotes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _complaints.indexWhere((c) => c.id == complaintId);
    if (index != -1) {
      final complaint = _complaints[index];
      final wasResolved = complaint.status == ComplaintStatus.resolved;
      final isNowResolved = status == ComplaintStatus.resolved;
      
      _complaints[index] = complaint.copyWith(
        status: status,
        updatedAt: DateTime.now(),
        resolvedAt: status == ComplaintStatus.resolved ? DateTime.now() : complaint.resolvedAt,
        adminNotes: adminNotes ?? complaint.adminNotes,
      );
      
      // Award points when complaint is resolved
      if (!wasResolved && isNowResolved) {
        final rewardService = RewardService();
        rewardService.addPoints(complaint.userId, RewardService.pointsPerResolvedComplaint,
            reason: 'Complaint resolved!');
      }
      
      _notifyListeners();
    }
  }

  @override
  Future<void> updateComplaintPriority(String complaintId, int priority) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _complaints.indexWhere((c) => c.id == complaintId);
    if (index != -1) {
      final complaint = _complaints[index];
      _complaints[index] = complaint.copyWith(
        priority: priority,
        updatedAt: DateTime.now(),
      );
      _notifyListeners();
    }
  }

  @override
  Future<Complaint?> getComplaintById(String complaintId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _complaints.firstWhere((c) => c.id == complaintId);
    } catch (e) {
      return null;
    }
  }

  void _notifyListeners() {
    // Sort by priority and creation date
    _complaints.sort((a, b) {
      if (a.priority != b.priority) {
        return a.priority.compareTo(b.priority);
      }
      return b.createdAt.compareTo(a.createdAt);
    });
    _complaintsController.add(List.from(_complaints));
  }
}


