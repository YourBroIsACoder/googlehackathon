import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/complaint.dart';
import 'interfaces/i_complaint_service.dart';
import 'reward_service.dart';

class ComplaintService implements IComplaintService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RewardService _rewardService = RewardService();

  @override
  Stream<List<Complaint>> getComplaintsForUser(String userId) {
    debugPrint('📋 Getting complaints for user: $userId');
    
    return _firestore
        .collection('complaints')
        .where('userId', isEqualTo: userId)
        .orderBy('priority')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      final complaints = snapshot.docs
          .map((doc) => Complaint.fromMap(doc.id, doc.data()))
          .toList();
      
      debugPrint('📋 Found ${complaints.length} complaints for user');
      return complaints;
    });
  }

  @override
  Stream<List<Complaint>> getAllComplaints() {
    debugPrint('📋 Getting all complaints (admin view)');
    
    return _firestore
        .collection('complaints')
        .orderBy('priority')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      final complaints = snapshot.docs
          .map((doc) => Complaint.fromMap(doc.id, doc.data()))
          .toList();
      
      debugPrint('📋 Found ${complaints.length} total complaints');
      return complaints;
    });
  }

  @override
  Stream<List<Complaint>> getComplaintsByStatus(ComplaintStatus status) {
    debugPrint('📋 Getting complaints with status: ${status.name}');
    
    return _firestore
        .collection('complaints')
        .where('status', isEqualTo: status.name)
        .orderBy('priority')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      final complaints = snapshot.docs
          .map((doc) => Complaint.fromMap(doc.id, doc.data()))
          .toList();
      
      debugPrint('📋 Found ${complaints.length} complaints with status ${status.name}');
      return complaints;
    });
  }

  @override
  Future<String> createComplaint(Complaint complaint) async {
    try {
      debugPrint('📝 Creating new complaint: ${complaint.title}');
      
      // Create a new document reference to get the ID
      final docRef = _firestore.collection('complaints').doc();
      
      // Create complaint with the generated ID
      final complaintWithId = complaint.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
      );
      
      // Save to Firestore
      await docRef.set(complaintWithId.toMap());
      
      // Award points for submitting complaint
      try {
        // Check if this is user's first complaint
        final userComplaints = await _firestore
            .collection('complaints')
            .where('userId', isEqualTo: complaint.userId)
            .get();
        
        final isFirstComplaint = userComplaints.docs.length == 1; // Just created one
        
        if (isFirstComplaint) {
          _rewardService.addPoints(
            complaint.userId, 
            RewardService.pointsPerFirstComplaint,
            reason: 'First complaint bonus!',
          );
          debugPrint('🎉 Awarded first complaint bonus points');
        } else {
          _rewardService.addPoints(
            complaint.userId,
            RewardService.pointsPerComplaint,
            reason: 'Complaint submitted',
          );
          debugPrint('🎉 Awarded complaint submission points');
        }
      } catch (rewardError) {
        debugPrint('⚠️ Failed to award points: $rewardError');
      }
      
      debugPrint('✅ Complaint created successfully with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('❌ Failed to create complaint: $e');
      throw Exception('Failed to create complaint: $e');
    }
  }

  @override
  Future<void> updateComplaintStatus(
    String complaintId,
    ComplaintStatus status, {
    String? adminNotes,
  }) async {
    try {
      debugPrint('🔄 Updating complaint $complaintId status to ${status.name}');
      
      // Get current complaint to check if it was resolved
      final complaintDoc = await _firestore
          .collection('complaints')
          .doc(complaintId)
          .get();
      
      if (!complaintDoc.exists) {
        throw Exception('Complaint not found');
      }
      
      final currentComplaint = Complaint.fromMap(complaintDoc.id, complaintDoc.data()!);
      final wasResolved = currentComplaint.status == ComplaintStatus.resolved;
      final isNowResolved = status == ComplaintStatus.resolved;
      
      // Prepare update data
      final updateData = <String, dynamic>{
        'status': status.name,
        'updatedAt': DateTime.now().toIso8601String(),
      };
      
      if (adminNotes != null) {
        updateData['adminNotes'] = adminNotes;
      }
      
      if (status == ComplaintStatus.resolved) {
        updateData['resolvedAt'] = DateTime.now().toIso8601String();
      }
      
      // Update in Firestore
      await _firestore
          .collection('complaints')
          .doc(complaintId)
          .update(updateData);
      
      // Award points when complaint is resolved
      if (!wasResolved && isNowResolved) {
        try {
          _rewardService.addPoints(
            currentComplaint.userId,
            RewardService.pointsPerResolvedComplaint,
            reason: 'Complaint resolved!',
          );
          debugPrint('🎉 Awarded resolution points to user');
        } catch (rewardError) {
          debugPrint('⚠️ Failed to award resolution points: $rewardError');
        }
      }
      
      debugPrint('✅ Complaint status updated successfully');
    } catch (e) {
      debugPrint('❌ Failed to update complaint status: $e');
      throw Exception('Failed to update complaint status: $e');
    }
  }

  @override
  Future<void> updateComplaintPriority(String complaintId, int priority) async {
    try {
      debugPrint('🔄 Updating complaint $complaintId priority to $priority');
      
      await _firestore
          .collection('complaints')
          .doc(complaintId)
          .update({
        'priority': priority,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      
      debugPrint('✅ Complaint priority updated successfully');
    } catch (e) {
      debugPrint('❌ Failed to update complaint priority: $e');
      throw Exception('Failed to update complaint priority: $e');
    }
  }

  @override
  Future<Complaint?> getComplaintById(String complaintId) async {
    try {
      debugPrint('🔍 Getting complaint by ID: $complaintId');
      
      final doc = await _firestore
          .collection('complaints')
          .doc(complaintId)
          .get();
      
      if (doc.exists) {
        final complaint = Complaint.fromMap(doc.id, doc.data()!);
        debugPrint('✅ Found complaint: ${complaint.title}');
        return complaint;
      } else {
        debugPrint('❌ Complaint not found');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Failed to get complaint: $e');
      throw Exception('Failed to get complaint: $e');
    }
  }
}