import 'dart:async';
import '../../models/complaint.dart';

/// Abstract interface for complaint services
/// Provides a common contract for both Firebase and mock implementations
abstract class IComplaintService {
  /// Get stream of complaints for a specific user
  /// Returns real-time updates of user's complaints
  Stream<List<Complaint>> getComplaintsForUser(String userId);
  
  /// Get stream of all complaints (admin access)
  /// Returns real-time updates of all complaints in the system
  Stream<List<Complaint>> getAllComplaints();
  
  /// Get stream of complaints filtered by status
  /// Returns real-time updates of complaints with specified status
  Stream<List<Complaint>> getComplaintsByStatus(ComplaintStatus status);
  
  /// Create a new complaint
  /// Returns the ID of the created complaint
  /// Throws Exception on error
  Future<String> createComplaint(Complaint complaint);
  
  /// Update complaint status (admin function)
  /// Optionally includes admin notes
  /// Throws Exception on error
  Future<void> updateComplaintStatus(
    String complaintId,
    ComplaintStatus status, {
    String? adminNotes,
  });
  
  /// Update complaint priority (admin function)
  /// Priority: 1 = High, 2 = Medium, 3 = Low
  /// Throws Exception on error
  Future<void> updateComplaintPriority(String complaintId, int priority);
  
  /// Get a specific complaint by ID
  /// Returns Complaint if found, null otherwise
  /// Throws Exception on error
  Future<Complaint?> getComplaintById(String complaintId);
}