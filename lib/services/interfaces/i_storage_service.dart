import 'package:image_picker/image_picker.dart';

/// Abstract interface for storage services
/// Provides a common contract for both Firebase Storage and mock implementations
abstract class IStorageService {
  /// Pick image from camera or gallery
  /// Returns XFile if image selected, null if cancelled
  Future<XFile?> pickImage();
  
  /// Pick image from gallery specifically
  /// Returns XFile if image selected, null if cancelled
  Future<XFile?> pickImageFromGallery();
  
  /// Upload complaint image to storage
  /// Returns the download URL of the uploaded image
  /// Throws Exception on error
  Future<String> uploadComplaintImage(XFile imageFile, String complaintId);
  
  /// Delete complaint image from storage
  /// Takes the full storage URL as parameter
  /// Throws Exception on error
  Future<void> deleteComplaintImage(String imageUrl);
  
  /// Get upload progress stream (optional)
  /// Returns stream of upload progress (0.0 to 1.0)
  /// May return null if not supported by implementation
  Stream<double>? getUploadProgress(String uploadId) => null;
}