import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      print('Error picking image: $e');
    }
    return null;
  }

  Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
    return null;
  }

  Future<String> uploadComplaintImage(XFile imageFile, String complaintId) async {
    try {
      final ref = _storage.ref().child('complaints/$complaintId.jpg');
      
      if (kIsWeb) {
        // For web, use putData with Uint8List
        final bytes = await imageFile.readAsBytes();
        await ref.putData(bytes);
      } else {
        // For mobile platforms, use putFile
        await ref.putFile(File(imageFile.path));
      }
      
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}

