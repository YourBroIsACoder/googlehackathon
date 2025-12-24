// import 'package:cloud_firestore/cloud_firestore.dart'; // COMMENTED OUT - Using mock

enum ComplaintStatus {
  open,
  inProgress,
  resolved,
}

enum ComplaintCategory {
  pothole,
  brokenStreetlight,
  garbage,
  waterLeakage,
  roadHazard,
  other,
}

class Complaint {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String title; // Added title field
  final ComplaintCategory category;
  final String description;
  final String? imageUrl;
  final double latitude;
  final double longitude;
  final String? address;
  final ComplaintStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;
  final String? adminNotes;
  final int priority; // 1 = High, 2 = Medium, 3 = Low

  Complaint({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.title,
    required this.category,
    required this.description,
    this.imageUrl,
    required this.latitude,
    required this.longitude,
    this.address,
    this.status = ComplaintStatus.open,
    required this.createdAt,
    this.updatedAt,
    this.resolvedAt,
    this.adminNotes,
    this.priority = 2,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'title': title,
      'category': category.name,
      'description': description,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(), // Changed from Timestamp
      'updatedAt': updatedAt?.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'adminNotes': adminNotes,
      'priority': priority,
    };
  }

  factory Complaint.fromMap(String id, Map<String, dynamic> map) {
    return Complaint(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userEmail: map['userEmail'] ?? '',
      title: map['title'] ?? 'Untitled Complaint',
      category: ComplaintCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => ComplaintCategory.other,
      ),
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'],
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      address: map['address'],
      status: ComplaintStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ComplaintStatus.open,
      ),
      createdAt: map['createdAt'] is String 
          ? DateTime.parse(map['createdAt'])
          : (map['createdAt'] != null ? DateTime.parse(map['createdAt'].toString()) : DateTime.now()),
      updatedAt: map['updatedAt'] != null 
          ? (map['updatedAt'] is String ? DateTime.parse(map['updatedAt']) : DateTime.parse(map['updatedAt'].toString()))
          : null,
      resolvedAt: map['resolvedAt'] != null
          ? (map['resolvedAt'] is String ? DateTime.parse(map['resolvedAt']) : DateTime.parse(map['resolvedAt'].toString()))
          : null,
      adminNotes: map['adminNotes'],
      priority: map['priority'] ?? 2,
    );
  }

  Complaint copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? title,
    ComplaintCategory? category,
    String? description,
    String? imageUrl,
    double? latitude,
    double? longitude,
    String? address,
    ComplaintStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    String? adminNotes,
    int? priority,
  }) {
    return Complaint(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      adminNotes: adminNotes ?? this.adminNotes,
      priority: priority ?? this.priority,
    );
  }

  String get categoryDisplayName {
    switch (category) {
      case ComplaintCategory.pothole:
        return 'Pothole';
      case ComplaintCategory.brokenStreetlight:
        return 'Broken Streetlight';
      case ComplaintCategory.garbage:
        return 'Garbage Accumulation';
      case ComplaintCategory.waterLeakage:
        return 'Water Leakage';
      case ComplaintCategory.roadHazard:
        return 'Road Hazard';
      case ComplaintCategory.other:
        return 'Other';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case ComplaintStatus.open:
        return 'Open';
      case ComplaintStatus.inProgress:
        return 'In Progress';
      case ComplaintStatus.resolved:
        return 'Resolved';
    }
  }

  String get priorityDisplayName {
    switch (priority) {
      case 1:
        return 'High';
      case 2:
        return 'Medium';
      case 3:
        return 'Low';
      default:
        return 'Medium';
    }
  }
}
