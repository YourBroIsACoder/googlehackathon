// Mock Storage Service - For testing without Firebase Storage
// Replace this with storage_service.dart when Firebase is configured

import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'interfaces/i_storage_service.dart';

class StorageService implements IStorageService {
  // Mock storage - in real implementation this would be Firebase Storage
  static const String _mockBaseUrl = 'https://mock-storage.example.com/complaint-images';
  final ImagePicker _picker = ImagePicker();
  
  @override
  Future<XFile?> pickImage() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
    } catch (e) {
      // Handle permission errors gracefully
      return null;
    }
  }
  
  @override
  Future<XFile?> pickImageFromGallery() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
    } catch (e) {
      // Handle permission errors gracefully
      return null;
    }
  }
  
  @override
  Future<String> uploadComplaintImage(XFile imageFile, String complaintId) async {
    // Mock delay to simulate upload
    await Future.delayed(const Duration(seconds: 2));
    
    // Generate mock URL
    final fileName = imageFile.name;
    final mockUrl = '$_mockBaseUrl/$complaintId/$fileName';
    
    // In real implementation, this would upload to Firebase Storage
    // For now, just return a mock URL
    return mockUrl;
  }
  
  @override
  Future<void> deleteComplaintImage(String imageUrl) async {
    // Mock delay to simulate deletion
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In real implementation, this would delete from Firebase Storage
    // For now, just simulate success
  }
  
  @override
  Stream<double>? getUploadProgress(String uploadId) {
    // Mock upload progress stream
    return Stream.periodic(const Duration(milliseconds: 100), (count) {
      final progress = (count + 1) * 0.1;
      return progress > 1.0 ? 1.0 : progress;
    }).take(10);
  }
}