class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool isAdmin;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isAdmin = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isAdmin': isAdmin,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      isAdmin: map['isAdmin'] ?? false,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

